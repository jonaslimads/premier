use std::sync::Arc;

use async_graphql::{Context, Object, Result, SimpleObject};

use crate::application::vendor::queries::vendor_products::{
    VendorProductsQuery, VendorProductsView, VendorProductsViewCategory, VendorProductsViewProduct,
};
use crate::presentation::graphql::queries::utils::{
    empty_connection, get_from_filter, query_vec, query_vec_with_additional_fields, Connection,
    Filter, Ordering, SortMap,
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
        sort: Ordering,
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
            .sort(&mut categories, &sort);
        query_vec(categories, after, before, first, last).await
    }

    async fn category(
        &self,
        context: &Context<'_>,
        id: String,
        filter: Filter,
    ) -> Result<Option<VendorProductsViewCategory>> {
        let vendor_id = get_from_filter(&filter, "vendor_id")?;
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut categories = match vendor.map(|v| v.categories) {
            Some(categories) => categories,
            None => return Ok(None),
        };
        match VendorProductsViewCategory::get_category_mut(&mut categories, id) {
            Some(category) => Ok(Some(category.clone())),
            None => return Ok(None),
        }
    }

    async fn products(
        &self,
        context: &Context<'_>,
        filter: Filter,
        sort: Ordering,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<VendorProductsViewProduct, ProductAdditionalFields>> {
        let vendor_id = get_from_filter(&filter, "vendor_id")?;
        let category_id = get_from_filter(&filter, "category_id")?;
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut categories = match vendor.map(|v| v.categories) {
            Some(categories) => categories,
            None => return Ok(empty_connection()),
        };
        let category = match VendorProductsViewCategory::get_category_mut(
            &mut categories,
            category_id.clone(),
        ) {
            Some(category) => category,
            None => return Ok(empty_connection()),
        };
        let mut products = Some(category.products.clone());
        SortMap::<VendorProductsViewProduct>::new()
            .asc("id", Box::new(|a, b| a.id.cmp(&b.id)))
            .desc("id", Box::new(|a, b| b.id.cmp(&a.id)))
            .asc("name", Box::new(|a, b| a.name.cmp(&b.name)))
            .desc("name", Box::new(|a, b| b.name.cmp(&a.name)))
            .sort(&mut products, &sort);
        query_vec_with_additional_fields(
            products,
            after,
            before,
            first,
            last,
            Box::new(move |_| ProductAdditionalFields::new(category_id.clone())),
        )
        .await
    }
}

#[derive(SimpleObject)]
struct ProductAdditionalFields {
    category_id: String,
}

impl ProductAdditionalFields {
    fn new(category_id: String) -> Self {
        Self { category_id }
    }
}
