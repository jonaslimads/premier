use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Page {
    id: String,
}

impl Page {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
