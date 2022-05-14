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
}

impl DomainEvent for VendorEvent {
    fn event_type(&self) -> String {
        (match self {
            VendorEvent::VendorAdded { .. } => "VendorAdded",
            VendorEvent::VendorArchived { .. } => "VendorArchived",
            VendorEvent::VendorUnarchived { .. } => "VendorUnarchived",
        })
        .to_string()
    }

    fn event_version(&self) -> String {
        "1.0".to_string()
    }
}
