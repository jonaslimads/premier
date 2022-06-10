use std::sync::Arc;

use async_graphql::{Context, Object, Result, SimpleObject};

use crate::application::product::queries::product::{ProductQuery, ProductView, ProductViewReview};
use crate::application::vendor::queries::vendor_products::{
    VendorProductsQuery, VendorProductsView, VendorProductsViewCategory, VendorProductsViewProduct,
};
use crate::presentation::graphql::queries::utils::{
    empty_connection, get_from_filter, query_vec, query_vec_with_additional_fields, sort,
    Connection, Filter, Ordering,
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
        let vendor_id = get_from_filter(&filter, "vendorId")?;
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut categories = vendor.map(|v| v.categories);
        sort!(categories, sort, name);
        query_vec(categories, after, before, first, last).await
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
        let vendor_id = get_from_filter(&filter, "vendorId")?;
        let category_id = get_from_filter(&filter, "categoryId")?;
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
        sort!(products, sort, id, name);
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

    async fn reviews(
        &self,
        context: &Context<'_>,
        filter: Filter,
        sort: Ordering,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<ProductViewReview>> {
        let product_id = get_from_filter(&filter, "productId")?;
        let query = context.data_unchecked::<Arc<ProductQuery>>().clone();
        let product = query.load(product_id.as_str()).await.clone();
        let mut reviews = product.map(|v| v.reviews);
        sort!(reviews, sort, id);
        query_vec(reviews, after, before, first, last).await
    }

    async fn category(
        &self,
        context: &Context<'_>,
        id: String,
        filter: Filter,
    ) -> Result<Option<VendorProductsViewCategory>> {
        let vendor_id = get_from_filter(&filter, "vendorId")?;
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

    async fn product(&self, context: &Context<'_>, id: String) -> Result<Option<ProductView>> {
        let query = context.data_unchecked::<Arc<ProductQuery>>().clone();
        Ok(query.load(id.as_str()).await.clone())
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
