use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Store {
    id: String,
}

impl Store {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
