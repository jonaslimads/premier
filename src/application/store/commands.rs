use async_graphql::InputObject;
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;

pub use crate::application::store::services::StoreServices;
use crate::commons::{Price, SubscriptionPlanKind};
use crate::domain::default_platform_id;

#[derive(Debug, Serialize, Deserialize)]
pub enum StoreCommand {
    AddStore(AddStoreCommand),
    PublishStore(PublishStoreCommand),
    UnpublishStore(UnpublishStoreCommand),
    AddPage(AddPageCommand),
    PageProduct(PageProductCommand),
    SubscribeToPlan(SubscribeToPlanCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddStoreCommand {
    pub id: String,
    #[graphql(default_with = "default_platform_id()")]
    pub platform_id: String,
    pub name: String,
    pub attributes: Value,
    pub seller: AddStoreCommandSeller,
    pub plan: AddStoreCommandPlan,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct PublishStoreCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UnpublishStoreCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddPageCommand {
    pub id: String,
    pub page_id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub parent_page_id: Option<String>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct PageProductCommand {
    pub id: String,
    pub page_id: String,
    pub product_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct SubscribeToPlanCommand {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub kind: SubscriptionPlanKind,
    pub price: Price,
    pub expires_on: Option<DateTime<Utc>>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddStoreCommandSeller {
    pub name: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddStoreCommandPlan {
    pub name: String,
    pub attributes: Value,
    pub kind: SubscriptionPlanKind,
    pub price: Price,
    pub expires_on: Option<DateTime<Utc>>,
}
