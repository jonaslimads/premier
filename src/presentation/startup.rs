use std::sync::Arc;

use cqrs_es::Query;
// TrackingEventProcessor

use crate::infrastructure::{cqrs, ConnectionPool, Cqrs, ViewRepository};

// use crate::application::order::queries::SimpleLoggingQuery as ProductSimpleLoggingQuery;
use crate::application::order::services::OrderServices;
use crate::domain::order::Order;

use crate::application::product::queries::SimpleLoggingQuery as ProductSimpleLoggingQuery;
use crate::application::product::queries::VendorProductsQueryFromProduct;
use crate::application::product::services::ProductServices;
use crate::domain::product::Product;
use crate::infrastructure::product::services::ProductLookup;

use crate::application::vendor::queries::{SimpleLoggingQuery, VendorProductsQuery};
use crate::application::vendor::services::VendorServices;
use crate::domain::vendor::Vendor;
use crate::infrastructure::vendor::services::VendorApi;

pub type OrderStartup = (Arc<Cqrs<Order>>,);
pub type ProductStartup = (Arc<Cqrs<Product>>,);
pub type VendorStartup = (Arc<Cqrs<Vendor>>, Arc<VendorProductsQuery>);

pub async fn start_cqrs_instances(
    pool: ConnectionPool,
) -> (OrderStartup, ProductStartup, VendorStartup) {
    let order_cqrs = order_cqrs(pool.clone()).await;
    let product_cqrs = product_cqrs(pool.clone()).await;
    let vendor_cqrs = vendor_cqrs(pool.clone()).await;

    // let product_cqrs = Arc::new(product_cqrs);
    // let vendor_cqrs = Arc::new(vendor_cqrs);

    // let vendor_products_repository =
    //     Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    // let vendor_products_query = VendorProductsQuery::for_vendor(vendor_products_repository);

    // let vendor_cqrs = vendor_cqrs.append_query(Box::new(vendor_products_query));

    (order_cqrs, product_cqrs, vendor_cqrs)
}

pub async fn vendor_cqrs(pool: ConnectionPool) -> VendorStartup {
    let services = VendorServices::new(Box::new(VendorApi));

    let simple_logging_query = SimpleLoggingQuery {};

    let vendor_products_repository =
        Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    let vendor_products_query = VendorProductsQuery::new(vendor_products_repository.clone());
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

    let framework = cqrs(pool, "vendor_event", queries, services).await;
    // let framework =
    //     framework.with_tracking_event_processor(TrackingEventProcessor::new(vec![Box::new(
    //         cloned_vendor_products_query,
    //     )]));

    (
        Arc::new(framework),
        Arc::new(VendorProductsQuery::new(vendor_products_repository)),
    )
}

pub async fn product_cqrs(pool: ConnectionPool) -> ProductStartup {
    let services = ProductServices::new(ProductLookup::new(pool.clone()));

    let simple_logging_query = ProductSimpleLoggingQuery {};

    let vendor_products_repository =
        Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    let vendor_products_query =
        VendorProductsQueryFromProduct::new(vendor_products_repository, services.clone());

    let queries: Vec<Box<dyn Query<Product>>> = vec![
        Box::new(simple_logging_query),
        Box::new(vendor_products_query),
    ];

    let framework = cqrs(pool, "product_event", queries, services).await;

    (Arc::new(framework),)
}

pub async fn order_cqrs(pool: ConnectionPool) -> OrderStartup {
    // let simple_logging_query = OrderSimpleLoggingQuery {};

    let queries: Vec<Box<dyn Query<Order>>> = vec![];
    let services = OrderServices {};

    let framework = cqrs(pool, "order_event", queries, services).await;

    (Arc::new(framework),)
}
