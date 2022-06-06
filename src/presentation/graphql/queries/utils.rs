use std::collections::HashMap;

use async_graphql::types::connection::{self, Connection as BaseConnection, CursorType, Edge};
use async_graphql::{Enum, Error, ErrorExtensions, InputObject, OutputType, Result, SimpleObject};
use serde::{Deserialize, Serialize};

use crate::presentation::PresentationError;

pub type Connection<T> = BaseConnection<usize, T, AdditionalFields>;

pub type Filter = Option<HashMap<String, String>>;

pub type Ordering = Option<Vec<OrderBy>>;

pub struct SortMap<T>(HashMap<OrderBy, Comparator<T>>);

#[derive(Clone, Debug, Deserialize, Eq, Hash, InputObject, PartialEq, Serialize, SimpleObject)]
pub struct OrderBy {
    field: String,
    order: Order,
}

#[derive(Clone, Copy, Debug, Deserialize, Enum, Eq, Hash, PartialEq, Serialize)]
enum Order {
    Asc,
    Desc,
}

type Comparator<T> = Box<dyn FnMut(&T, &T) -> std::cmp::Ordering + Send + Sync>;

#[derive(SimpleObject)]
pub struct AdditionalFields {
    total: u32,
}

impl AdditionalFields {
    pub fn new(total: u32) -> Self {
        Self { total }
    }
}

pub async fn query_vec<T>(
    vec: Option<Vec<T>>,
    after: Option<String>,
    before: Option<String>,
    first: Option<i32>,
    last: Option<i32>,
) -> Result<Connection<T>>
where
    T: Clone + OutputType,
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
            connection.edges.extend(
                slice
                    .iter()
                    .enumerate()
                    .map(|(index, item)| Edge::new(start + index, item.clone())),
            );
            Ok::<_, Error>(connection)
        },
    )
    .await
}

pub fn empty_connection<Cursor, Node>() -> BaseConnection<Cursor, Node, AdditionalFields>
where
    Cursor: CursorType + Send + Sync,
    Node: OutputType,
{
    new_connection(&vec![], false, false)
}

pub fn new_connection<Cursor, Node>(
    data: &Vec<Node>,
    has_previous_page: bool,
    has_next_page: bool,
) -> BaseConnection<Cursor, Node, AdditionalFields>
where
    Cursor: CursorType + Send + Sync,
    Node: OutputType,
{
    BaseConnection::<Cursor, Node, AdditionalFields>::with_additional_fields(
        has_previous_page,
        has_next_page,
        AdditionalFields::new(data.len() as u32),
    )
}

pub fn get_from_filter(filter: &Filter, key: &str) -> Result<String, Error> {
    if let Some(filter) = filter {
        if let Some(vendor_id) = filter.get(&key.to_string()) {
            Ok(vendor_id.clone())
        } else {
            Err(PresentationError::Required(format!("filter {}", key)).extend())
        }
    } else {
        Err(PresentationError::Required("filter".to_string()).extend())
    }
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

impl<T> SortMap<T>
where
    T: Clone,
{
    pub fn new() -> Self {
        Self(HashMap::new())
    }

    pub fn asc(self, field: &str, compare: Comparator<T>) -> Self {
        self.add(OrderBy::asc(field), compare)
    }

    pub fn desc(self, field: &str, compare: Comparator<T>) -> Self {
        self.add(OrderBy::desc(field), compare)
    }

    pub fn add(mut self, order_by: OrderBy, compare: Comparator<T>) -> Self {
        self.0.insert(order_by, compare);
        self
    }

    pub fn sort_by(&mut self, order_by: &Ordering, vec: &mut Option<Vec<T>>) {
        let order_by = match order_by {
            Some(order_by) => order_by,
            None => return,
        };
        let vec = match vec {
            Some(vec) => vec,
            None => return,
        };
        for single_order_by in order_by {
            self.sort_by_single(single_order_by, vec);
        }
    }

    fn sort_by_single(&mut self, order_by: &OrderBy, vec: &mut Vec<T>) {
        let comparator = match self.0.get_mut(order_by) {
            Some(comparator) => comparator,
            None => return,
        };
        vec.sort_by(comparator);
    }
}
