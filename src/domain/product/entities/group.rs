use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Group {
    id: String,
}

impl Group {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
