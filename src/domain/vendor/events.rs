use cqrs_es::DomainEvent;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::fmt::Debug;

use crate::domain::{default_platform_id, skip_default_platform_id};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum VendorEvent {
    VendorAdded {
        id: String,
        #[serde(default = "default_platform_id")]
        #[serde(skip_serializing_if = "skip_default_platform_id")]
        platform_id: String,
        name: String,
        attributes: Value,
    },
    VendorArchived {},
    VendorUnarchived {},
    GroupAdded {
        group_id: String,
        name: String,
        slug: String,
        order: u16,
        #[serde(skip_serializing_if = "Option::is_none")]
        parent_group_id: Option<String>,
    },
    ProductGrouped {
        group_id: String,
        product_id: String,
    },
}

impl DomainEvent for VendorEvent {
    fn event_type(&self) -> String {
        (match self {
            VendorEvent::VendorAdded { .. } => "VendorAdded",
            VendorEvent::VendorArchived { .. } => "VendorArchived",
            VendorEvent::VendorUnarchived { .. } => "VendorUnarchived",
            VendorEvent::GroupAdded { .. } => "GroupAdded",
            VendorEvent::ProductGrouped { .. } => "ProductGrouped",
        })
        .to_string()
    }

    fn event_version(&self) -> String {
        "0.1.0".to_string()
    }
}
