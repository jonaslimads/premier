use std::sync::Arc;

use async_graphql::{Context, ErrorExtensions, Object, Result, SimpleObject};

use crate::application::platform::queries::platform::{
    PlatformQuery, PlatformView, PlatformViewCategory, PlatformViewPlan,
};
use crate::application::product::queries::product::{ProductQuery, ProductView, ProductViewReview};
use crate::application::store::queries::store_products::{
    StoreProductsQuery, StoreProductsView, StoreProductsViewPage, StoreProductsViewProduct,
};
use crate::commons::{HasNestedGroups, HasNestedGroupsWithItems};
use crate::presentation::graphql::queries::utils::{
    empty_connection, get_opt_string_from_filter, get_opt_vec_from_filter, get_string_from_filter,
    query_vec, query_vec_with_additional_fields, sort, Connection, Filter, Ordering,
};
use crate::presentation::PresentationError;

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn is_up(&self) -> Result<bool> {
        Ok(true)
    }

    async fn platform(&self, context: &Context<'_>) -> Result<Option<PlatformView>> {
        Ok(query::<PlatformQuery>(context).load("0").await.clone())
    }

    async fn plans(&self, context: &Context<'_>) -> Result<Connection<PlatformViewPlan>> {
        let platform = self.platform(context).await?;
        let plans = platform.map(|p| p.plans);
        query_vec(plans, None, None, None, None).await
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
        let platform = self.platform(context).await?;
        let mut categories = platform.map(|p| p.categories);
        sort!(categories, sort, name);
        query_vec(categories, after, before, first, last).await
    }

    async fn category(
        &self,
        context: &Context<'_>,
        id: String,
        _filter: Filter,
    ) -> Result<Option<PlatformViewCategory>> {
        let query = context.data_unchecked::<Arc<PlatformQuery>>();
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

    async fn stores(
        &self,
        context: &Context<'_>,
        filter: Filter,
        sort: Ordering,
        after: Option<String>,
        before: Option<String>,
        first: Option<i32>,
        last: Option<i32>,
    ) -> Result<Connection<StoreProductsView>> {
        let query = query::<StoreProductsQuery>(context);
        let stores = match get_opt_vec_from_filter(&filter, "storeIds")? {
            Some(store_ids) => query.load_many(store_ids).await,
            None => query.load_all().await,
        }
        .map_err(|error| PresentationError::from(error).extend())?;
        let mut stores = Some(stores);
        sort!(stores, sort, name);
        query_vec(stores, after, before, first, last).await
    }

    async fn store(&self, context: &Context<'_>, id: String) -> Result<Option<StoreProductsView>> {
        Ok(query::<StoreProductsQuery>(context).load(id.as_str()).await)
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
    ) -> Result<Connection<StoreProductsViewPage>> {
        let store_id = get_string_from_filter(&filter, "storeId")?;
        let query = context.data_unchecked::<Arc<StoreProductsQuery>>();
        let store = query.load(store_id.as_str()).await.clone();
        let mut pages = store.map(|v| v.pages);
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
    ) -> Result<Connection<StoreProductsViewProduct, ProductAdditionalFields>> {
        let store_id = get_string_from_filter(&filter, "storeId")?;
        let page_id = get_opt_string_from_filter(&filter, "pageId");
        let query = context.data_unchecked::<Arc<StoreProductsQuery>>();
        let store = query.load(store_id.as_str()).await.clone();
        let mut store = match store {
            Some(store) => store,
            None => return Ok(empty_connection()),
        };

        let (mut products, page_id) = if let Some(page_id) = page_id {
            let mut pages = store.pages;
            let page = match StoreProductsView::get_group_mut(&mut pages, page_id.clone()) {
                Some(page) => page,
                None => return Ok(empty_connection()),
            };
            (Some(page.products.clone()), page_id.clone())
        } else {
            (Some(store.get_all_items()), "".to_string())
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
        let product_id = get_string_from_filter(&filter, "productId")?;
        let query = context.data_unchecked::<Arc<ProductQuery>>();
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
    ) -> Result<Option<StoreProductsViewPage>> {
        let store_id = get_string_from_filter(&filter, "storeId")?;
        let query = context.data_unchecked::<Arc<StoreProductsQuery>>();
        let store = query.load(store_id.as_str()).await.clone();
        let mut pages = match store.map(|v| v.pages) {
            Some(pages) => pages,
            None => return Ok(None),
        };
        match StoreProductsView::get_group_mut(&mut pages, id) {
            Some(page) => Ok(Some(page.clone())),
            None => return Ok(None),
        }
    }

    async fn product(&self, context: &Context<'_>, id: String) -> Result<Option<ProductView>> {
        let query = context.data_unchecked::<Arc<ProductQuery>>();
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

fn query<'a, T: 'a + 'static + Send + Sync>(context: &Context<'a>) -> &'a Arc<T> {
    context.data_unchecked::<Arc<T>>()
}
