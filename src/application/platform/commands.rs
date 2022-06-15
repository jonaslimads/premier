use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Serialize, Deserialize)]
pub enum PlatformCommand {
    AddPlatform(AddPlatformCommand),
    CategorizeProduct(CategorizeProductCommand),
    UpdatePlatformName(UpdatePlatformNameCommand),
    UpdatePlatformAttributes(UpdatePlatformAttributesCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddPlatformCommand {
    pub id: String,
    pub name: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct CategorizeProductCommand {
    pub id: String,
    pub category_id: String,
    pub product_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdatePlatformNameCommand {
    pub id: String,
    pub name: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdatePlatformAttributesCommand {
    pub id: String,
    pub attributes: Value,
}
