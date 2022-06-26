use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Seller {
    pub name: String,
    pub attributes: Value,
}

impl Seller {
    pub fn new(name: String, attributes: Value) -> Self {
        Self { name, attributes }
    }
}
