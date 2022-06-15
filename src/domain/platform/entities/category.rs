use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Category {
    id: String,
}

impl Category {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
