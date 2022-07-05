use async_graphql::{Enum, InputObject, SimpleObject};
use serde::{Deserialize, Serialize};


#[derive(Clone, Copy, Debug, Default, Deserialize, Enum, Eq, PartialEq, Serialize)]
pub enum SubscriptionPlanKind {
    Free,
    #[default]
    Trial,
    Monthly,
    Annual,
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


#[derive(Clone, Copy, Debug, Default, Deserialize, Enum, Eq, PartialEq, Serialize)]
pub enum Currency {
    AED,
    AUD,
    BRL,
    CAD,
    CHF,
    CNY,
    EUR,
    GBP,
    HKD,
    IDR,
    INR,
    JPY,
    KRW,
    MXN,
    RUB,
    SAR,
    SGD,
    THB,
    TWD,
    #[default]
    USD,
}