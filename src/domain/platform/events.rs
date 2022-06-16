use std::fmt::Debug;

use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::event_enum;

event_enum! {
    version "0.1.0",
    enum PlatformEvent {
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
}
