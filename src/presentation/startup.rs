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
    SimpleLoggingQuery as ProductSimpleLoggingQuery, VendorProductsQueryFromProduct,
};
use crate::application::product::services::ProductServices;
use crate::domain::product::Product;
use crate::infrastructure::product::services::ProductLookup;

use crate::application::vendor::queries::{SimpleLoggingQuery, VendorProductsQuery};
use crate::application::vendor::services::VendorServices;
use crate::domain::vendor::Vendor;
use crate::infrastructure::vendor::services::VendorApi;

pub type OrderStartup = (Arc<Cqrs<Order>>,);
pub type PlatformStartup = (Arc<Cqrs<Platform>>, Arc<PlatformQuery>);
pub type ProductStartup = (Arc<Cqrs<Product>>, Arc<ProductQuery>);
pub type VendorStartup = (Arc<Cqrs<Vendor>>, Arc<VendorProductsQuery>);

pub async fn start_cqrs_instances(
    pool: ConnectionPool,
) -> (OrderStartup, PlatformStartup, ProductStartup, VendorStartup) {
    let (order_cqrs,) = order_cqrs(pool.clone()).await;
    let (platform_cqrs, platform_query) = platform_cqrs(pool.clone()).await;
    let (product_cqrs, product_query) = product_cqrs(pool.clone()).await;
    let (vendor_cqrs, vendor_products_query) = vendor_cqrs(pool.clone()).await;

    let product_cqrs = product_cqrs.append_query(Box::new(ProductDownstreamCqrs::new(
        platform_cqrs.clone(),
        vendor_cqrs.clone(),
    )));

    // let product_cqrs = Arc::new(product_cqrs);
    // let vendor_cqrs = Arc::new(vendor_cqrs);

    // let vendor_products_repository =
    //     Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    // let vendor_products_query = VendorProductsQuery::for_vendor(vendor_products_repository);

    // let vendor_cqrs = vendor_cqrs.append_query(Box::new(vendor_products_query));

    (
        (order_cqrs,),
        (platform_cqrs, platform_query),
        (Arc::new(product_cqrs), product_query),
        (vendor_cqrs, vendor_products_query),
    )
}

pub async fn vendor_cqrs(pool: ConnectionPool) -> VendorStartup {
    let services = Arc::new(VendorServices::new(Box::new(VendorApi)));

    let simple_logging_query = SimpleLoggingQuery {};

    let vendor_products_repository =
        Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    let vendor_products_query =
        VendorProductsQuery::new(vendor_products_repository.clone(), services.clone());
    // let mut vendor_products_query = VendorProductsQuery::new(vendor_products_repository.clone());
    // TODO add error handling
    // vendor_products_query.use_error_handler(Box::new(|error| log::error!("{}", error)));

    let queries: Vec<Box<dyn Query<Vendor>>> = vec![
        Box::new(simple_logging_query),
        Box::new(vendor_products_query),
    ];

    // let mut cloned_vendor_products_query =
    //     VendorProductsQuery::new(vendor_products_repository.clone());
    // cloned_vendor_products_query.use_error_handler(Box::new(|error| log::error!("{}", error)));

    let framework = cqrs(
        pool,
        "vendor_event",
        queries,
        VendorServices::new(Box::new(VendorApi)),
    )
    .await;
    // let framework =
    //     framework.with_tracking_event_processor(TrackingEventProcessor::new(vec![Box::new(
    //         cloned_vendor_products_query,
    //     )]));

    (
        Arc::new(framework),
        Arc::new(VendorProductsQuery::new(
            vendor_products_repository,
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
        // Box::new(VendorProductsQueryFromProduct::new(
        //     vendor_products_repository,
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

    let vendor_products_repository =
        Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    let product_repository = Arc::new(ViewRepository::new("product_view", pool.clone()));

    let queries: Vec<Box<dyn Query<Product>>> = vec![
        Box::new(ProductSimpleLoggingQuery {}),
        Box::new(VendorProductsQueryFromProduct::new(
            vendor_products_repository,
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
