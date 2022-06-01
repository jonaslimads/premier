use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

pub use crate::application::vendor::services::VendorServices;

#[derive(Debug, Serialize, Deserialize)]
pub enum VendorCommand {
    AddVendor(AddVendorCommand),
    ArchiveVendor(ArchiveVendorCommand),
    UnarchiveVendor(UnarchiveVendorCommand),
    AddCategory(AddCategoryCommand),
    CategorizeProduct(CategorizeProductCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddVendorCommand {
    pub id: String,
    pub name: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct ArchiveVendorCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UnarchiveVendorCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddCategoryCommand {
    pub id: String,
    pub category_id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub parent_category_id: Option<String>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct CategorizeProductCommand {
    pub id: String,
    pub category_id: String,
    pub product_id: String,
}
