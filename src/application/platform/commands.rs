use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{Price, SubscriptionPlanKind};
use crate::domain::default_platform_id;
use crate::domain::platform::events::PlatformEventPlanAddedSubscription;

#[derive(Debug, Serialize, Deserialize)]
pub enum PlatformCommand {
    AddPlatform(AddPlatformCommand),
    UpdatePlatform(UpdatePlatformCommand),
    AddPlan(AddPlanCommand),
    AddCategory(AddCategoryCommand),
    CategorizeProduct(CategorizeProductCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddPlatformCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub name: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdatePlatformCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub name: Option<String>,
    pub attributes: Option<Value>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddPlanCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub name: String,
    pub order: u16,
    pub attributes: Value,
    pub subscriptions: Vec<AddPlanCommandSubscription>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddCategoryCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub category_id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub parent_category_id: Option<String>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct CategorizeProductCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub category_id: String,
    pub product_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddPlanCommandSubscription {
    pub kind: SubscriptionPlanKind,
    pub price: Price,
    pub expires_in: Option<u16>,
}

impl From<AddPlanCommandSubscription> for PlatformEventPlanAddedSubscription {
    fn from(command: AddPlanCommandSubscription) -> Self {
        Self {
            kind: command.kind,
            price: command.price,
            expires_in: command.expires_in,
        }
    }
}
