use std::sync::Arc;

// use async_graphql::{ComplexObject, Context, ErrorExtensions, Object, Result};
use async_graphql::types::connection::*;
use async_graphql::*;
use async_graphql::{Context, Object, Result};

use crate::application::vendor::queries::{VendorProductsQuery, VendorProductsView};

pub struct QueryRoot;

#[derive(SimpleObject)]
struct Diff {
    diff: i32,
}

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

    async fn numbers(
        &self,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<usize, i32, EmptyFields, Diff>> {
        query(
            after,
            before,
            first,
            last,
            |after, before, first, last| async move {
                let mut start = after.map(|after| after + 1).unwrap_or(0);
                let mut end = before.unwrap_or(10000);
                if let Some(first) = first {
                    end = (start + first).min(end);
                }
                if let Some(last) = last {
                    start = if last > end - start { end } else { end - last };
                }
                let mut connection = Connection::new(start > 0, end < 10000);
                connection.edges.extend((start..end).into_iter().map(|n| {
                    Edge::with_additional_fields(
                        n,
                        n as i32,
                        Diff {
                            diff: (10000 - n) as i32,
                        },
                    )
                }));
                Ok::<_, Error>(connection)
            },
        )
        .await
    }
}
