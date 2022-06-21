use std::sync::Arc;

use async_graphql::{Context, Object, Result, SimpleObject};

use crate::application::platform::queries::platform::{
    PlatformQuery, PlatformView, PlatformViewCategory,
};
use crate::application::product::queries::product::{ProductQuery, ProductView, ProductViewReview};
use crate::application::vendor::queries::vendor_products::{
    VendorProductsQuery, VendorProductsView, VendorProductsViewPage, VendorProductsViewProduct,
};
use crate::commons::{HasNestedGroups, HasNestedGroupsWithItems};
use crate::presentation::graphql::queries::utils::{
    empty_connection, get_from_filter, opt_from_filter, query_vec,
    query_vec_with_additional_fields, sort, Connection, Filter, Ordering,
};

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn is_up(&self) -> Result<bool> {
        Ok(true)
    }

    async fn platform(&self, context: &Context<'_>) -> Result<Option<PlatformView>> {
        let query = context.data_unchecked::<Arc<PlatformQuery>>().clone();
        Ok(query.load("0").await.clone())
    }

    async fn categories(
        &self,
        context: &Context<'_>,
        _filter: Filter,
        sort: Ordering,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<PlatformViewCategory>> {
        let query = context.data_unchecked::<Arc<PlatformQuery>>().clone();
        let platform = query.load("0").await.clone();
        let mut categories = platform.map(|v| v.categories);
        sort!(categories, sort, name);
        query_vec(categories, after, before, first, last).await
    }

    async fn category(
        &self,
        context: &Context<'_>,
        id: String,
        _filter: Filter,
    ) -> Result<Option<PlatformViewCategory>> {
        let query = context.data_unchecked::<Arc<PlatformQuery>>().clone();
        let platform = query.load("0").await.clone();
        let mut categories = match platform.map(|v| v.categories) {
            Some(categories) => categories,
            None => return Ok(None),
        };
        match PlatformViewCategory::get_group_mut(&mut categories, id) {
            Some(category) => Ok(Some(category.clone())),
            None => return Ok(None),
        }
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

    async fn pages(
        &self,
        context: &Context<'_>,
        filter: Filter,
        sort: Ordering,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<VendorProductsViewPage>> {
        let vendor_id = get_from_filter(&filter, "vendorId")?;
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut pages = vendor.map(|v| v.pages);
        sort!(pages, sort, name);
        query_vec(pages, after, before, first, last).await
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
        let page_id = opt_from_filter(&filter, "pageId");
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut vendor = match vendor {
            Some(vendor) => vendor,
            None => return Ok(empty_connection()),
        };

        let (mut products, page_id) = if let Some(page_id) = page_id {
            let mut pages = vendor.pages;
            let page = match VendorProductsView::get_group_mut(&mut pages, page_id.clone()) {
                Some(page) => page,
                None => return Ok(empty_connection()),
            };
            (Some(page.products.clone()), page_id.clone())
        } else {
            (Some(vendor.get_all_items()), "".to_string())
        };

        sort!(products, sort, id, name);
        query_vec_with_additional_fields(
            products,
            after,
            before,
            first,
            last,
            Box::new(move |_| ProductAdditionalFields::new(page_id.clone())),
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

    async fn page(
        &self,
        context: &Context<'_>,
        id: String,
        filter: Filter,
    ) -> Result<Option<VendorProductsViewPage>> {
        let vendor_id = get_from_filter(&filter, "vendorId")?;
        let query = context.data_unchecked::<Arc<VendorProductsQuery>>().clone();
        let vendor = query.load(vendor_id.as_str()).await.clone();
        let mut pages = match vendor.map(|v| v.pages) {
            Some(pages) => pages,
            None => return Ok(None),
        };
        match VendorProductsView::get_group_mut(&mut pages, id) {
            Some(page) => Ok(Some(page.clone())),
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
    page_id: String,
}

impl ProductAdditionalFields {
    fn new(page_id: String) -> Self {
        Self { page_id }
    }
}
