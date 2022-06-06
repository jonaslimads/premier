use std::sync::Arc;

use async_graphql::{Context, Object, Result};

use crate::application::vendor::queries::vendor_products::{
    VendorProductsQuery, VendorProductsView, VendorProductsViewCategory,
};
use crate::presentation::graphql::queries::utils::{
    get_from_filter, query_vec, Connection, Filter, Ordering, SortMap,
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
        // with_archived: Option<bool>,
    ) -> Result<Option<VendorProductsView>> {
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        if let Some(vendor_products) = query.load(id.as_str()).await.clone() {
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
        filter: Filter,
        order_by: Ordering,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<VendorProductsViewCategory>> {
        let vendor_id = get_from_filter(&filter, "vendor_id")?;
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut categories = vendor.map(|v| v.categories);
        SortMap::<VendorProductsViewCategory>::new()
            .asc("name", Box::new(|a, b| a.name.cmp(&b.name)))
            .desc("name", Box::new(|a, b| b.name.cmp(&a.name)))
            .sort_by(&order_by, &mut categories);
        query_vec(categories, after, before, first, last).await
    }
}
