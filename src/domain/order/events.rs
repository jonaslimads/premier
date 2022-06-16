use std::fmt::Debug;

use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::event_enum;

event_enum! {
    version "0.1.0",
    enum OrderEvent {
        OrderAdded {
            id: String,
            buyer_id: String,
        },
        OrderArchived {},
        OrderUnarchived {},
        OrderProductAdded {
            product_id: String,
            vendor_id: String,
            name: String,
            slug: String,
            currency: String,
            attachment: String,
            attributes: Value,
        },
        OrderProductVariantAdded {
            product_id: String,
            variant_id: String,
            sku: String,
            price: u32,
            attachment: String,
            attributes: Value,
        },
    }
}
