use std::convert::Infallible;
use std::sync::Arc;

use async_graphql::http::{playground_source, GraphQLPlaygroundConfig};
use async_graphql::{EmptySubscription, Schema};
use async_graphql_warp::{GraphQLBadRequest, GraphQLResponse};
use http::StatusCode;
use warp::{http::Response as HttpResponse, Filter, Rejection, Reply};

pub mod mutation_root;
pub mod queries;

pub use crate::domain::{order::Order, product::Product, vendor::Vendor};
pub use crate::infrastructure::{auth::SessionIntent, ConnectionPool, Cqrs};
use crate::presentation::startup::{OrderStartup, PlatformStartup, ProductStartup, VendorStartup};
use crate::presentation::PresentationService;
pub use mutation_root::MutationRoot;
pub use queries::query_root::QueryRoot;

pub async fn start_graphql_server(
    port: u16,
    presentation_service: Arc<PresentationService>,
    (order_cqrs,): OrderStartup,
    (platform_cqrs, platform_query): PlatformStartup,
    (product_cqrs, product_query): ProductStartup,
    (vendor_cqrs, vendor_product_query): VendorStartup,
) {
    let schema = Schema::build(QueryRoot, MutationRoot, EmptySubscription)
        .data(presentation_service)
        .data(order_cqrs)
        .data(platform_cqrs)
        .data(platform_query)
        .data(product_cqrs)
        .data(product_query)
        .data(vendor_cqrs)
        .data(vendor_product_query)
        .finish();

    let schema_sdl = schema.sdl();
    let warp_data_filter = warp::any().map(move || Arc::new(schema_sdl.clone()));
    let get_schema_sdl_route = warp::path!("schema.graphql")
        .and(warp_data_filter.clone())
        .and_then(get_schema_sdl);

    // TODO reuse and simplify
    let graphql_post = warp::header::optional::<String>("Authorization")
        .and(warp::header::optional::<String>("User-Agent"))
        .and(warp::header::optional::<String>("X-Forwarded-For"))
        .and(async_graphql_warp::graphql(schema.clone()))
        .and_then(
            |authorization,
             user_agent,
             ip,
             (schema, request): (
                Schema<QueryRoot, MutationRoot, EmptySubscription>,
                async_graphql::Request,
            )| async move {
                let mut session_intent = SessionIntent::new(authorization);
                session_intent.insert_to_metadata("ip", ip);
                session_intent.insert_to_metadata("user_agent", user_agent);
                let response = schema.execute(request.data(session_intent)).await;
                Ok::<_, Infallible>(GraphQLResponse::from(response))
            },
        );

    let graphql_playground = warp::path!("playground").and(warp::get()).map(|| {
        HttpResponse::builder()
            .header("content-type", "text/html")
            .body(playground_source(GraphQLPlaygroundConfig::new("/")))
    });

    let cors = warp::cors()
        .allow_any_origin()
        .allow_methods(vec!["GET", "POST"])
        .allow_headers(vec!["Content-Type"]);

    let routes = get_schema_sdl_route
        .or(graphql_playground)
        .or(graphql_post)
        .recover(|err: Rejection| async move {
            if let Some(GraphQLBadRequest(err)) = err.find() {
                return Ok::<_, Infallible>(warp::reply::with_status(
                    err.to_string(),
                    StatusCode::BAD_REQUEST,
                ));
            }

            Ok(warp::reply::with_status(
                "INTERNAL_SERVER_ERROR".to_string(),
                StatusCode::INTERNAL_SERVER_ERROR,
            ))
        })
        .with(cors);

    log::info!("Playground: http://0.0.0.0:{}/playground", port);

    warp::serve(routes).run(([0, 0, 0, 0], port)).await;
}

async fn get_schema_sdl(schema_sdl: Arc<String>) -> Result<impl Reply, Rejection> {
    Ok(warp::reply::with_status(
        schema_sdl.as_ref().clone(),
        StatusCode::OK,
    ))
}
