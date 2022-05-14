use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::entities::Category;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Vendor {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub categories: Vec<Category>,
}
