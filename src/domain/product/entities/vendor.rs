use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Vendor {
    id: String,
}

impl Vendor {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
