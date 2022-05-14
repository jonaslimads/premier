use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Warehouse {
    pub id: String,
}

impl Warehouse {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
