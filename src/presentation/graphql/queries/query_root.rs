use std::sync::Arc;

use async_graphql::types::connection::{query, Connection, CursorType, Edge};
use async_graphql::{Context, Error, Object, OutputType, Result, SimpleObject};

use crate::application::vendor::queries::vendor_products::{
    VendorProductsQuery, VendorProductsView, VendorProductsViewCategory,
};

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn is_up(&self) -> Result<bool> {
        Ok(true)
    }

    async fn vendor(
        &self,
        context: &Context<'_>,
        id: String,
        with_archived: Option<bool>,
    ) -> Result<Option<VendorProductsView>> {
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        if let Some(mut vendor_products) = query.load(id.as_str()).await.clone() {
            // if with_archived != Some(true) {
            //     vendor_products.remove_archived_products();
            // }
            Ok(Some(vendor_products))
        } else {
            Ok(None)
        }
    }

    async fn categories(
        &self,
        context: &Context<'_>,
        id: String,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<usize, VendorProductsViewCategory, AdditionalFields>> {
        query(
            after,
            before,
            first,
            last,
            |after, before, first, last| async move {
                let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
                let vendor = match query.load(id.as_str()).await.clone() {
                    Some(vendor) => vendor,
                    None => return Ok(empty_connection()),
                };
                let categories = vendor.categories;

                let mut start = 0usize;
                let mut end = categories.len();

                if let Some(after) = after {
                    if after >= categories.len() {
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

                let mut slice = &categories[start..end];

                if let Some(first) = first {
                    slice = &slice[..first.min(slice.len())];
                    end -= first.min(slice.len());
                } else if let Some(last) = last {
                    slice = &slice[slice.len() - last.min(slice.len())..];
                    start = end - last.min(slice.len());
                }

                let mut connection = new_connection(&categories, start > 0, end < 10000);
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
}

#[derive(SimpleObject)]
pub struct AdditionalFields {
    total: u32,
}

impl AdditionalFields {
    pub fn new(total: u32) -> Self {
        Self { total }
    }
}

fn new_connection<Cursor, Node>(
    data: &Vec<Node>,
    has_previous_page: bool,
    has_next_page: bool,
) -> Connection<Cursor, Node, AdditionalFields>
where
    Cursor: CursorType + Send + Sync,
    Node: OutputType,
{
    Connection::<Cursor, Node, AdditionalFields>::with_additional_fields(
        has_previous_page,
        has_next_page,
        AdditionalFields::new(data.len() as u32),
    )
}

fn empty_connection<Cursor, Node>() -> Connection<Cursor, Node, AdditionalFields>
where
    Cursor: CursorType + Send + Sync,
    Node: OutputType,
{
    new_connection(&vec![], false, false)
}
