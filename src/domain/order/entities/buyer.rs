use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Buyer {
    pub id: String,
}

impl Buyer {
    pub fn new(buyer_id: String) -> Self {
        Self { id: buyer_id }
    }
}
