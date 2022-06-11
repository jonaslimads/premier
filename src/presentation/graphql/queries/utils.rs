use std::collections::HashMap;

use async_graphql::types::connection::{self, Connection as BaseConnection};
use async_graphql::types::connection::{CursorType, Edge, EmptyFields};
use async_graphql::{Enum, Error, ErrorExtensions, InputObject};
use async_graphql::{ObjectType, OutputType, Result, SimpleObject};
use serde::{Deserialize, Serialize};

use crate::presentation::PresentationError;

pub type Connection<Node, EdgeFields = EmptyFields> =
    BaseConnection<usize, Node, ConnectionFields, EdgeFields>;

pub type Filter = Option<HashMap<String, String>>;

pub type Ordering = Option<Vec<OrderBy>>;

#[derive(Clone, Debug, Deserialize, Eq, Hash, InputObject, PartialEq, Serialize, SimpleObject)]
pub struct OrderBy {
    field: String,
    order: Order,
}

impl OrderBy {
    pub fn asc(field: &str) -> Self {
        Self {
            field: field.to_string(),
            order: Order::Asc,
        }
    }

    pub fn desc(field: &str) -> Self {
        Self {
            field: field.to_string(),
            order: Order::Desc,
        }
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Enum, Eq, Hash, PartialEq, Serialize)]
enum Order {
    Asc,
    Desc,
}

type Comparator<T> = Box<dyn FnMut(&T, &T) -> std::cmp::Ordering + Send + Sync>;

#[derive(SimpleObject)]
pub struct ConnectionFields {
    total: u32,
}

impl ConnectionFields {
    pub fn new(total: u32) -> Self {
        Self { total }
    }
}

pub async fn query_vec<Node>(
    vec: Option<Vec<Node>>,
    after: Option<String>,
    before: Option<String>,
    first: Option<i32>,
    last: Option<i32>,
) -> Result<Connection<Node, EmptyFields>>
where
    Node: Clone + OutputType,
{
    query_vec_with_additional_fields(vec, after, before, first, last, Box::new(|_| EmptyFields))
        .await
}

pub async fn query_vec_with_additional_fields<Node, EdgeFields>(
    vec: Option<Vec<Node>>,
    after: Option<String>,
    before: Option<String>,
    first: Option<i32>,
    last: Option<i32>,
    additional_fields: Box<dyn Fn(&Node) -> EdgeFields + Send + Sync>,
) -> Result<Connection<Node, EdgeFields>>
where
    Node: Clone + OutputType,
    EdgeFields: ObjectType,
{
    connection::query(
        after,
        before,
        first,
        last,
        |after, before, first, last| async move {
            let vec = match vec {
                Some(vec) => vec,
                None => return Ok(empty_connection()),
            };

            let mut start = 0usize;
            let mut end = vec.len();

            if let Some(after) = after {
                if after >= vec.len() {
                    return Ok(empty_connection());
                }
                start = after + 1;
            }

            if let Some(before) = before {
                if before == 0 {
                    return Ok(empty_connection());
                }
                end = before;
            }

            let mut slice = &vec[start..end];

            if let Some(first) = first {
                slice = &slice[..first.min(slice.len())];
                end -= first.min(slice.len());
            } else if let Some(last) = last {
                slice = &slice[slice.len() - last.min(slice.len())..];
                start = end - last.min(slice.len());
            }

            let mut connection = new_connection(&vec, start > 0, end < vec.len());
            connection
                .edges
                .extend(slice.iter().enumerate().map(|(index, item)| {
                    Edge::with_additional_fields(
                        start + index,
                        item.clone(),
                        (additional_fields)(&item),
                    )
                }));
            Ok::<_, Error>(connection)
        },
    )
    .await
}

pub fn empty_connection<Cursor, Node, EdgeFields>(
) -> BaseConnection<Cursor, Node, ConnectionFields, EdgeFields>
where
    Cursor: CursorType + Send + Sync,
    Node: OutputType,
    EdgeFields: ObjectType,
{
    new_connection(&vec![], false, false)
}

pub fn new_connection<Cursor, Node, EdgeFields>(
    data: &Vec<Node>,
    has_previous_page: bool,
    has_next_page: bool,
) -> BaseConnection<Cursor, Node, ConnectionFields, EdgeFields>
where
    Cursor: CursorType + Send + Sync,
    Node: OutputType,
    EdgeFields: ObjectType,
{
    BaseConnection::<Cursor, Node, ConnectionFields, EdgeFields>::with_additional_fields(
        has_previous_page,
        has_next_page,
        ConnectionFields::new(data.len() as u32),
    )
}

pub fn get_from_filter(filter: &Filter, key: &str) -> Result<String, Error> {
    if let Some(value) = opt_from_filter(filter, key) {
        Ok(value)
    } else {
        Err(PresentationError::Required(format!("filter {}", key)).extend())
    }
}

pub fn opt_from_filter(filter: &Filter, key: &str) -> Option<String> {
    if let Some(filter) = filter {
        filter.get(&key.to_string()).map(|v| v.clone())
    } else {
        None
    }
}

pub struct SortMap<'a, T> {
    map: HashMap<OrderBy, Comparator<T>>,
    vec: &'a mut Option<Vec<T>>,
}

impl<'a, T> SortMap<'a, T>
where
    T: Clone,
{
    pub fn new(vec: &'a mut Option<Vec<T>>) -> Self {
        Self {
            map: HashMap::new(),
            vec,
        }
    }

    pub fn asc(&mut self, field: &str, compare: Comparator<T>) {
        self.add(OrderBy::asc(field), compare)
    }

    pub fn desc(&mut self, field: &str, compare: Comparator<T>) {
        self.add(OrderBy::desc(field), compare)
    }

    pub fn add(&mut self, order_by: OrderBy, compare: Comparator<T>) {
        self.map.insert(order_by, compare);
    }

    pub fn sort(&mut self, sort: &Ordering) {
        let sort = match sort {
            Some(sort) => sort,
            None => return,
        };
        let vec = match self.vec {
            Some(vec) => vec,
            None => return,
        };
        for order_by in sort {
            if let Some(comparator) = self.map.get_mut(order_by) {
                vec.sort_by(comparator);
            }
        }
    }
}

macro_rules! sort {
    ($vec:expr, $sort:expr, $($field:ident),*) => {{
        let mut sort_map = crate::presentation::graphql::queries::utils::SortMap::new(&mut $vec);
        $(
            {
                sort_map.asc(stringify!($field), Box::new(|a, b| a.$field.cmp(&b.$field)));
                sort_map.desc(stringify!($field), Box::new(|a, b| b.$field.cmp(&a.$field)));
            }
        )*
        sort_map.sort(&$sort);
    }};
}

pub(crate) use sort;
