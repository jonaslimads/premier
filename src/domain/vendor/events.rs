use cqrs_es::DomainEvent;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::fmt::Debug;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum VendorEvent {
    VendorAdded {
        id: String,
        name: String,
        attributes: Value,
    },
    VendorArchived {},
    VendorUnarchived {},
    CategoryAdded {
        category_id: String,
        name: String,
        slug: String,
        order: u16,
        parent_category_id: Option<String>,
    },
    ProductCategorized {
        category_id: String,
        product_id: String,
    },
}

impl DomainEvent for VendorEvent {
    fn event_type(&self) -> String {
        (match self {
            VendorEvent::VendorAdded { .. } => "VendorAdded",
            VendorEvent::VendorArchived { .. } => "VendorArchived",
            VendorEvent::VendorUnarchived { .. } => "VendorUnarchived",
            VendorEvent::CategoryAdded { .. } => "CategoryAdded",
            VendorEvent::ProductCategorized { .. } => "ProductCategorized",
        })
        .to_string()
    }

    fn event_version(&self) -> String {
        "0.1.0".to_string()
    }
}
