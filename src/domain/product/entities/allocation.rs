use serde::{Deserialize, Serialize};

use crate::domain::product::entities::Order;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Allocation {
    pub order: Order,
    pub quantity: u32,
}
