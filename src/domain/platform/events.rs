use std::fmt::Debug;

use cqrs_es::DomainEvent;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum PlatformEvent {
    PlatformAdded {
        id: String,
        name: String,
        attributes: Value,
    },
    CategoryAdded {
        category_id: String,
        name: String,
        slug: String,
        order: u16,
        #[serde(skip_serializing_if = "Option::is_none")]
        parent_category_id: Option<String>,
    },
    ProductCategorized {
        category_id: String,
        product_id: String,
    },
    PlatformNameUpdated {
        name: String,
    },
    PlatformAttributesUpdated {
        attributes: Value,
    },
}

impl DomainEvent for PlatformEvent {
    fn event_type(&self) -> String {
        (match self {
            PlatformEvent::PlatformAdded { .. } => "PlatformAdded",
            PlatformEvent::CategoryAdded { .. } => "CategoryAdded",
            PlatformEvent::ProductCategorized { .. } => "ProductCategorized",
            PlatformEvent::PlatformNameUpdated { .. } => "PlatformNameUpdated",
            PlatformEvent::PlatformAttributesUpdated { .. } => "PlatformAttributesUpdated",
        })
        .to_string()
    }

    fn event_version(&self) -> String {
        "0.1.0".to_string()
    }
}
