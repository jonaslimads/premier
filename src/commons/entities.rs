use async_graphql::{Enum, InputObject};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, Debug, Deserialize, Enum, Eq, PartialEq, Serialize)]
pub enum Currency {
    BRL,
    USD,
}

impl Default for Currency {
    fn default() -> Self {
        Self::USD
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Enum, Eq, PartialEq, Serialize)]
pub enum PlanSubscriptionKind {
    Free,
    Trial,
    Monthly,
    Annual,
}

impl Default for PlanSubscriptionKind {
    fn default() -> Self {
        Self::Monthly
    }
}

#[derive(Clone, Copy, Debug, Default, Deserialize, Eq, InputObject, PartialEq, Serialize)]
pub struct Price {
    pub currency: Currency,
    pub amount: u32,
}
