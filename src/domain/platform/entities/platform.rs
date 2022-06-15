use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Platform {
    pub id: String,
    pub name: String,
    pub attributes: Value,
}
