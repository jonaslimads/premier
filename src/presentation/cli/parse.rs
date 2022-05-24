use clap::Parser;
use paste::paste;
use serde::Serialize;
use serde_json::{json, ser::PrettyFormatter, Serializer as JsonSerializer, Value};

use crate::application::order::commands::*;
use crate::application::product::commands::*;
use crate::application::vendor::commands::*;
use crate::presentation::cli::{Cli, Mode};
use crate::presentation::graphql::start_graphql_server;
use crate::presentation::service::PresentationService;
use crate::presentation::{startup, Result};

macro_rules! match_commands {
    (
        $presentation_service:expr,
        $order_cqrs:expr,
        $product_cqrs:expr,
        $vendor_cqrs:expr,
        $command:expr,
        $payload:expr,
        $($aggregate_type:ident => $command_type:ident),*
    ) => {{
        let order_cqrs = $order_cqrs;
        let product_cqrs = $product_cqrs;
        let vendor_cqrs = $vendor_cqrs;
        match $command.as_str() {
            $(stringify!($command_type) => {
                paste! {
                    let payload = $payload.to_string();
                    let mut command: [<$command_type Command>] = serde_json::from_str(&payload)?;
                    command.id = $presentation_service.prepare_aggregate_id(command.id.clone(), stringify!($aggregate_type), stringify!($command_type)).await?;
                    let aggregate_id = command.id.clone();
                    let cqrs = [<$aggregate_type _cqrs>];
                    let command = <[<$aggregate_type:camel Command>]>::$command_type(command);
                    cqrs.execute(aggregate_id.as_str(), command).await?;
                    Result::Ok(aggregate_id)
                }
            }),*
            _ => panic!("Cannot handle {} {:?}", $command, $payload),
        }}
    };
}

pub async fn parse() -> Result<Option<String>> {
    let cli = Cli::parse();
    let config = cli.parse_config();
    // log::trace!("{:?}", config);

    let pool = config
        .get_database_or_error()?
        .get_mysql_or_error()?
        .into_connection_pool()
        .await;
    let keycloak = config
        .get_auth_or_error()?
        .get_keycloak_or_error()?
        .into_provider();
    let presentation_service = PresentationService::new(pool.clone(), keycloak);

    let (order_cqrs,) = startup::order_cqrs(pool.clone()).await;
    let (product_cqrs,) = startup::product_cqrs(pool.clone()).await;
    let (vendor_cqrs, _vendor_products_query, queries) = startup::vendor_cqrs(pool.clone()).await;

    match &cli.mode {
        Mode::Serve => {
            start_graphql_server(
                config.get_port(),
                presentation_service,
                order_cqrs.clone(),
                product_cqrs.clone(),
                vendor_cqrs.clone(),
            )
            .await;
        }
        Mode::Replay { aggregate } => {
            log::info!("Replay {} events", aggregate);
        }
        Mode::Command { command, payload } => {
            log::info!("command {}, payload {:?}", command, payload);
            let aggregate_id = match_commands! {
                presentation_service,
                order_cqrs,
                product_cqrs,
                vendor_cqrs,
                command,
                payload,
                order => AddOrder,
                order => ArchiveOrder,
                order => UnarchiveOrder,
                order => AddOrderProduct,
                order => AddOrderProductVariant,
                product => AddProduct,
                product => ArchiveProduct,
                product => UnarchiveProduct,
                product => UpdateProductName,
                product => UpdateProductSlug,
                product => UpdateProductDescription,
                product => UpdateProductAttachments,
                product => UpdateProductAttributes,
                product => AddProductVariant,
                product => AddProductVariantStock,
                product => RemoveProductVariantStock,
                product => AllocateProductStockVariant,
                product => ReallocateProductStockVariant,
                product => DeallocateProductStockVariant,
                vendor => AddVendor,
                vendor => ArchiveVendor,
                vendor => UnarchiveVendor
            }?;

            return pretty_print_json(json!({ "aggregate_id": aggregate_id }));
        }
        Mode::Query { query, id } => {
            log::info!("query {}:{}", query, id);
        }
    };
    Ok(None)
}

fn pretty_print_json(value: Value) -> Result<Option<String>> {
    let buffer = Vec::new();
    let formatter = PrettyFormatter::with_indent(b"  ");
    let mut ser = JsonSerializer::with_formatter(buffer, formatter);
    value.serialize(&mut ser).unwrap();
    Ok(Some(String::from_utf8(ser.into_inner())?))
}
