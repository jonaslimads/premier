use std::sync::Arc;

use cqrs_es::Query;

use crate::infrastructure::{cqrs, ConnectionPool, Cqrs, ViewRepository};

// use crate::application::order::queries::SimpleLoggingQuery as ProductSimpleLoggingQuery;
use crate::application::order::services::OrderServices;
use crate::domain::order::Order;

use crate::application::product::queries::SimpleLoggingQuery as ProductSimpleLoggingQuery;
use crate::application::product::services::ProductServices;
use crate::domain::product::Product;

use crate::application::vendor::queries::{
    SimpleLoggingQuery, VendorProductsQuery, VendorProductsView,
};
use crate::application::vendor::services::VendorServices;
use crate::domain::vendor::Vendor;
use crate::infrastructure::vendor::services::VendorApi;

pub async fn vendor_cqrs(
    pool: ConnectionPool,
) -> (
    Arc<Cqrs<Vendor>>,
    Arc<ViewRepository<VendorProductsView, Vendor>>,
) {
    let simple_logging_query = SimpleLoggingQuery {};

    let vendor_products_repository =
        Arc::new(ViewRepository::new("vendor_product_view", pool.clone()));
    let mut vendor_products_query = VendorProductsQuery::new(vendor_products_repository.clone());
    // TODO add error handling
    vendor_products_query.use_error_handler(Box::new(|error| log::error!("{}", error)));

    let queries: Vec<Box<dyn Query<Vendor>>> = vec![
        Box::new(simple_logging_query),
        Box::new(vendor_products_query),
    ];
    let services = VendorServices::new(Box::new(VendorApi));

    (
        Arc::new(cqrs(pool, "vendor_event", queries, services).await),
        vendor_products_repository,
    )
}

pub async fn product_cqrs(pool: ConnectionPool) -> (Arc<Cqrs<Product>>,) {
    let simple_logging_query = ProductSimpleLoggingQuery {};

    let queries: Vec<Box<dyn Query<Product>>> = vec![Box::new(simple_logging_query)];
    let services = ProductServices {};

    (Arc::new(
        cqrs(pool, "product_event", queries, services).await,
    ),)
}

pub async fn order_cqrs(pool: ConnectionPool) -> (Arc<Cqrs<Order>>,) {
    // let simple_logging_query = OrderSimpleLoggingQuery {};

    let queries: Vec<Box<dyn Query<Order>>> = vec![];
    let services = OrderServices {};

    (Arc::new(cqrs(pool, "order_event", queries, services).await),)
}
