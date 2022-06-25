use std::sync::Arc;

use cqrs_es::Query;
// use cqrs_es::TrackingEventProcessor;

use crate::infrastructure::{cqrs, ConnectionPool, Cqrs, ViewRepository};

// use crate::application::order::queries::SimpleLoggingQuery as ProductSimpleLoggingQuery;
use crate::application::order::services::OrderServices;
use crate::domain::order::Order;

use crate::application::platform::queries::{
    PlatformQuery, SimpleLoggingQuery as PlatformSimpleLoggingQuery,
};
use crate::application::platform::services::PlatformServices;
use crate::domain::platform::Platform;

use crate::application::product::queries::{
    DownstreamCqrs as ProductDownstreamCqrs, ProductQuery,
    SimpleLoggingQuery as ProductSimpleLoggingQuery, StoreProductsQueryFromProduct,
};
use crate::application::product::services::ProductServices;
use crate::domain::product::Product;
use crate::infrastructure::product::services::ProductLookup;

use crate::application::store::queries::{SimpleLoggingQuery, StoreProductsQuery};
use crate::application::store::services::StoreServices;
use crate::domain::store::Store;
use crate::infrastructure::store::services::StoreApi;

pub type OrderStartup = (Arc<Cqrs<Order>>,);
pub type PlatformStartup = (Arc<Cqrs<Platform>>, Arc<PlatformQuery>);
pub type ProductStartup = (Arc<Cqrs<Product>>, Arc<ProductQuery>);
pub type StoreStartup = (Arc<Cqrs<Store>>, Arc<StoreProductsQuery>);

pub async fn start_cqrs_instances(
    pool: ConnectionPool,
) -> (OrderStartup, PlatformStartup, ProductStartup, StoreStartup) {
    let (order_cqrs,) = order_cqrs(pool.clone()).await;
    let (platform_cqrs, platform_query) = platform_cqrs(pool.clone()).await;
    let (product_cqrs, product_query) = product_cqrs(pool.clone()).await;
    let (store_cqrs, store_products_query) = store_cqrs(pool.clone()).await;

    let product_cqrs = product_cqrs.append_query(Box::new(ProductDownstreamCqrs::new(
        platform_cqrs.clone(),
        store_cqrs.clone(),
    )));

    // let product_cqrs = Arc::new(product_cqrs);
    // let store_cqrs = Arc::new(store_cqrs);

    // let store_products_repository =
    //     Arc::new(ViewRepository::new("store_product_view", pool.clone()));
    // let store_products_query = StoreProductsQuery::for_store(store_products_repository);

    // let store_cqrs = store_cqrs.append_query(Box::new(store_products_query));

    (
        (order_cqrs,),
        (platform_cqrs, platform_query),
        (Arc::new(product_cqrs), product_query),
        (store_cqrs, store_products_query),
    )
}

pub async fn store_cqrs(pool: ConnectionPool) -> StoreStartup {
    let services = Arc::new(StoreServices::new(Box::new(StoreApi)));

    let simple_logging_query = SimpleLoggingQuery {};

    let store_products_repository =
        Arc::new(ViewRepository::new("store_product_view", pool.clone()));
    let store_products_query =
        StoreProductsQuery::new(store_products_repository.clone(), services.clone());
    // let mut store_products_query = StoreProductsQuery::new(store_products_repository.clone());
    // TODO add error handling
    // store_products_query.use_error_handler(Box::new(|error| log::error!("{}", error)));

    let queries: Vec<Box<dyn Query<Store>>> = vec![
        Box::new(simple_logging_query),
        Box::new(store_products_query),
    ];

    // let mut cloned_store_products_query =
    //     StoreProductsQuery::new(store_products_repository.clone());
    // cloned_store_products_query.use_error_handler(Box::new(|error| log::error!("{}", error)));

    let framework = cqrs(
        pool,
        "store_event",
        queries,
        StoreServices::new(Box::new(StoreApi)),
    )
    .await;
    // let framework =
    //     framework.with_tracking_event_processor(TrackingEventProcessor::new(vec![Box::new(
    //         cloned_store_products_query,
    //     )]));

    (
        Arc::new(framework),
        Arc::new(StoreProductsQuery::new(
            store_products_repository,
            services.clone(),
        )),
    )
}

pub async fn platform_cqrs(pool: ConnectionPool) -> PlatformStartup {
    let services = PlatformServices::new();

    let platform_view_repository = Arc::new(ViewRepository::new("platform_view", pool.clone()));

    let queries: Vec<Box<dyn Query<Platform>>> = vec![
        Box::new(PlatformSimpleLoggingQuery {}),
        Box::new(PlatformQuery::new(platform_view_repository.clone()))
        // Box::new(StoreProductsQueryFromProduct::new(
        //     store_products_repository,
        //     services.clone(),
        // )),
        // Box::new(ProductQuery::new(product_repository.clone())),
    ];

    let framework = cqrs(pool, "platform_event", queries, services).await;

    (
        Arc::new(framework),
        Arc::new(PlatformQuery::new(platform_view_repository)),
    )
}

pub async fn product_cqrs(pool: ConnectionPool) -> (Cqrs<Product>, Arc<ProductQuery>) {
    let services = ProductServices::new(ProductLookup::new(pool.clone()));

    let store_products_repository =
        Arc::new(ViewRepository::new("store_product_view", pool.clone()));
    let product_repository = Arc::new(ViewRepository::new("product_view", pool.clone()));

    let queries: Vec<Box<dyn Query<Product>>> = vec![
        Box::new(ProductSimpleLoggingQuery {}),
        Box::new(StoreProductsQueryFromProduct::new(
            store_products_repository,
            services.clone(),
        )),
        Box::new(ProductQuery::new(product_repository.clone())),
    ];

    let framework = cqrs(pool, "product_event", queries, services).await;

    (framework, Arc::new(ProductQuery::new(product_repository)))
}

pub async fn order_cqrs(pool: ConnectionPool) -> OrderStartup {
    // let simple_logging_query = OrderSimpleLoggingQuery {};

    let queries: Vec<Box<dyn Query<Order>>> = vec![];
    let services = OrderServices {};

    let framework = cqrs(pool, "order_event", queries, services).await;

    (Arc::new(framework),)
}
