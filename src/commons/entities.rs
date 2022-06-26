use async_graphql::{Enum, InputObject, SimpleObject};
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
pub enum SubscriptionPlanKind {
    Free,
    Trial,
    Monthly,
    Annual,
}

impl Default for SubscriptionPlanKind {
    fn default() -> Self {
        Self::Monthly
    }
}

#[derive(Clone, Copy, Debug, Default, Deserialize, Eq, InputObject, PartialEq, Serialize)]
pub struct Price {
    pub currency: Currency,
    pub amount: u32,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct OutputPrice {
    pub currency: Currency,
    pub amount: u32,
}

impl From<Price> for OutputPrice {
    fn from(price: Price) -> Self {
        Self {
            currency: price.currency,
            amount: price.amount,
        }
    }
}
