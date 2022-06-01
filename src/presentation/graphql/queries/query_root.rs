use std::sync::Arc;

// use async_graphql::{ComplexObject, Context, ErrorExtensions, Object, Result};
use async_graphql::{Context, Object, Result};

use crate::application::vendor::queries::{VendorProductsQuery, VendorProductsView};

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
    ) -> Result<Option<VendorProductsView>> {
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        Ok(query.load(id.as_str()).await)
    }
}
