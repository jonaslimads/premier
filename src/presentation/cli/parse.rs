use clap::Parser;
use paste::paste;
use serde::Serialize;
use serde_json::{json, ser::PrettyFormatter, Serializer as JsonSerializer, Value};

use crate::application::order::commands::{
    AddOrderCommand, AddOrderProductCommand, AddOrderProductVariantCommand, OrderCommand,
    PublishOrderCommand, UnpublishOrderCommand,
};
use crate::application::platform::commands::{
    AddCategoryCommand, AddPlanCommand, AddPlatformCommand, PlatformCommand, UpdatePlatformCommand,
};
use crate::application::product::commands::{
    AddProductCommand, AddProductVariantCommand, AddProductVariantStockCommand,
    AllocateProductStockVariantCommand, CategorizeProductCommand,
    DeallocateProductStockVariantCommand, PageProductCommand, ProductCommand,
    PublishProductCommand, ReallocateProductStockVariantCommand, RemoveProductVariantStockCommand,
    UnpublishProductCommand, UpdateProductAttachmentsCommand, UpdateProductAttributesCommand,
    UpdateProductDescriptionCommand, UpdateProductNameCommand, UpdateProductSlugCommand,
};
use crate::application::store::commands::{
    AddPageCommand, AddStoreCommand, PublishStoreCommand, StoreCommand, UnpublishStoreCommand,
};
use crate::presentation::cli::{Cli, Mode};
use crate::presentation::graphql::start_graphql_server;
use crate::presentation::service::PresentationService;
use crate::presentation::{startup, Result};

macro_rules! match_commands {
    (
        $presentation_service:expr,
        $order_cqrs:expr,
        $platform_cqrs:expr,
        $product_cqrs:expr,
        $store_cqrs:expr,
        $command:expr,
        $payload:expr,
        $($aggregate_type:ident => $command_type:ident),*
    ) => {{
        let order_cqrs = $order_cqrs;
        let platform_cqrs = $platform_cqrs;
        let product_cqrs = $product_cqrs;
        let store_cqrs = $store_cqrs;
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
        .into_connection_pool()
        .await?;
    let keycloak = match &config.auth {
        Some(auth) => auth.into_keycloak(),
        None => None,
    };
    let presentation_service = PresentationService::new(pool.clone(), keycloak);

    let (order_startup, platform_startup, product_startup, store_startup) =
        startup::start_cqrs_instances(pool.clone()).await;
    let (order_cqrs,) = order_startup;
    let (platform_cqrs, platform_query) = platform_startup;
    let (product_cqrs, product_query) = product_startup;
    let (store_cqrs, store_product_query) = store_startup;

    match &cli.mode {
        Mode::Serve => {
            start_graphql_server(
                &config.graphql,
                presentation_service,
                (order_cqrs.clone(),),
                (platform_cqrs.clone(), platform_query.clone()),
                (product_cqrs.clone(), product_query.clone()),
                (store_cqrs.clone(), store_product_query.clone()),
            )
            .await;
        }
        Mode::Replay { aggregate } => {
            if aggregate == "store" {
                log::info!("Replay {} events", aggregate);
                // store_cqrs.replay().await?;
            } else {
                log::error!("Aggregate {} does not support replay", aggregate);
            }
        }
        Mode::Command { command, payload } => {
            log::info!("command {}, payload {:?}", command, payload);
            let aggregate_id = match_commands! {
                presentation_service,
                order_cqrs,
                platform_cqrs,
                product_cqrs,
                store_cqrs,
                command,
                payload,
                order => AddOrder,
                order => PublishOrder,
                order => UnpublishOrder,
                order => AddOrderProduct,
                order => AddOrderProductVariant,
                platform => AddPlatform,
                platform => UpdatePlatform,
                platform => AddPlan,
                platform => AddCategory,
                product => AddProduct,
                product => PublishProduct,
                product => UnpublishProduct,
                product => CategorizeProduct,
                product => PageProduct,
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
                store => AddStore,
                store => PublishStore,
                store => UnpublishStore,
                store => AddPage
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
