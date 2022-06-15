use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

pub use crate::application::vendor::services::VendorServices;

#[derive(Debug, Serialize, Deserialize)]
pub enum VendorCommand {
    AddVendor(AddVendorCommand),
    ArchiveVendor(ArchiveVendorCommand),
    UnarchiveVendor(UnarchiveVendorCommand),
    AddGroup(AddGroupCommand),
    GroupProduct(GroupProductCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddVendorCommand {
    pub id: String,
    pub platform_id: String,
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
pub struct AddGroupCommand {
    pub id: String,
    pub group_id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub parent_group_id: Option<String>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct GroupProductCommand {
    pub id: String,
    pub group_id: String,
    pub product_id: String,
}
