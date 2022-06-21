use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::fmt::Debug;

use crate::domain::{default_platform_id, event_enum, skip_default_platform_id};

event_enum! {
    version "0.1.0",
    enum VendorEvent {
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
        PageAdded {
            page_id: String,
            name: String,
            slug: String,
            order: u16,
            #[serde(skip_serializing_if = "Option::is_none")]
            parent_page_id: Option<String>,
        },
        ProductPaged {
            page_id: String,
            product_id: String,
        },
    }
}
