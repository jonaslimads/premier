use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Order {
    pub id: String,
}

impl Order {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
