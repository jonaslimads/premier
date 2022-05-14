use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::order::entities::PaymentOption;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Variant {
    pub id: String,
    pub sku: String,
    pub price: u32,
    pub quantity: u32,
    pub attachment: String,
    pub attributes: Value,
    pub payment_option: PaymentOption,
}

impl Variant {
    pub fn new(id: String, sku: String, price: u32, attachment: String, attributes: Value) -> Self {
        Self {
            id,
            sku,
            price,
            attachment,
            attributes,
            ..Default::default()
        }
    }
}
