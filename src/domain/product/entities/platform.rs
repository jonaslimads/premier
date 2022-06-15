use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Platform {
    pub id: String,
}

impl Platform {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}
