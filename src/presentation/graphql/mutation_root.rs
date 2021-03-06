use std::sync::Arc;

use async_graphql::{Context, ErrorExtensions, Object, Result};
use paste::paste;

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
use crate::domain::order::Order;
use crate::domain::platform::Platform;
use crate::domain::product::Product;
use crate::domain::store::Store;
use crate::infrastructure::{auth, Cqrs};
use crate::presentation::{PresentationError, PresentationService};

type CqrsOrder = Arc<Cqrs<Order>>;
type CqrsPlatform = Arc<Cqrs<Platform>>;
type CqrsProduct = Arc<Cqrs<Product>>;
type CqrsStore = Arc<Cqrs<Store>>;

macro_rules! mutation_base {
    ($context:expr, $command:expr, $aggregate_type:ident, $command_type:ident, $parse_session_method:ident) => {{
        let session_intent = $context.data_unchecked::<auth::SessionIntent>().clone();
        let service = $context.data_unchecked::<Arc<PresentationService>>();
        let session = service
            .$parse_session_method(session_intent)
            .await
            .map_err(|error| error.extend())?;
        log::debug!("Session: {:?}", session);

        let mut command = $command.clone();
        command.id = service
            .prepare_aggregate_id(
                command.id.clone(),
                stringify!($aggregate_type),
                stringify!($command_type),
            )
            .await
            .map_err(|error| error.extend())?;
        let aggregate_id = command.id.clone();
        let command = <paste! { [<$aggregate_type:camel Command>] }>::$command_type(command);

        let cqrs = $context.data_unchecked::<paste! { [<Cqrs $aggregate_type:camel>] }>();
        match cqrs
            .execute_with_metadata(aggregate_id.as_str(), command, session.metadata)
            .await
        {
            Ok(_) => Ok(aggregate_id),
            Err(error) => Err(PresentationError::from(error).extend()),
        }
    }};
}

macro_rules! anonymous_mutation {
    ($context:expr, $command:expr, $aggregate_type:ident, $command_type:ident) => {{
        mutation_base!(
            $context,
            $command,
            $aggregate_type,
            $command_type,
            parse_anonymous_session
        )
    }};
}

// macro_rules! mutation {
//     ($context:expr, $command:expr, $aggregate_type:ident, $command_type:ident) => {{
//         mutation_base!(
//             $context,
//             $command,
//             $aggregate_type,
//             $command_type,
//             parse_session
//         )
//     }};
// }

macro_rules! mutation_root {
    ($($aggregate_type:ident => $command_type:ident),*) => {
        paste! {
            #[Object]
            impl MutationRoot {
                async fn add_order(
                    &self,
                    context: &Context<'_>,
                    command: AddOrderCommand,
                ) -> Result<String> {
                    anonymous_mutation!(context, command, order, AddOrder)
                }

                $(
                    async fn [<$command_type:snake>](
                        &self,
                        context: &Context<'_>,
                        command: [<$command_type Command>],
                    ) -> Result<String> {
                        anonymous_mutation!(context, command, $aggregate_type, $command_type)
                    }
                )*
            }
        }
    };
}

pub struct MutationRoot;

mutation_root!(
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
);
