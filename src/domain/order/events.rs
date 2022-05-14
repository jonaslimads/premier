use std::fmt::Debug;

use cqrs_es::DomainEvent;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum OrderEvent {
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

impl DomainEvent for OrderEvent {
    fn event_type(&self) -> String {
        (match self {
            OrderEvent::OrderAdded { .. } => "OrderAdded",
            OrderEvent::OrderArchived { .. } => "OrderArchived",
            OrderEvent::OrderUnarchived { .. } => "OrderUnarchived",
            OrderEvent::OrderProductAdded { .. } => "OrderProductAdded",
            OrderEvent::OrderProductVariantAdded { .. } => "OrderProductVariantAdded",
        })
        .to_string()
    }

    fn event_version(&self) -> String {
        "1.0".to_string()
    }
}
