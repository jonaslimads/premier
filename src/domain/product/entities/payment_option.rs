use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct PaymentOption {
    pub id: String,
    pub method: String,
    pub amount: u32,
    pub discount: u8,
    pub installments: Option<u8>,
    pub is_published: bool,
}
