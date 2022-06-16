use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::default_platform_id;

#[derive(Debug, Serialize, Deserialize)]
pub enum PlatformCommand {
    AddPlatform(AddPlatformCommand),
    AddCategory(AddCategoryCommand),
    CategorizeProduct(CategorizeProductCommand),
    UpdatePlatformName(UpdatePlatformNameCommand),
    UpdatePlatformAttributes(UpdatePlatformAttributesCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddPlatformCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub name: String,
    pub attributes: Value,
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
pub struct UpdatePlatformNameCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub name: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdatePlatformAttributesCommand {
    #[graphql(default_with = "default_platform_id()")]
    pub id: String,
    pub attributes: Value,
}
