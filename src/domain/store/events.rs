use std::fmt::Debug;

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{Price, SubscriptionPlanKind};
use crate::domain::{default_platform_id, event_enum, skip_default_platform_id};

event_enum! {
    version "0.1.0",
    enum StoreEvent {
        StoreAdded {
            id: String,
            #[serde(default = "default_platform_id")]
            #[serde(skip_serializing_if = "skip_default_platform_id")]
            platform_id: String,
            name: String,
            attributes: Value,
        },
        SellerUpdated {
            name: String,
            attributes: Value,
        },
        StoreArchived {},
        StoreUnarchived {},
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
        PlanSubscribed {
            name: String,
            attributes: Value,
            kind: SubscriptionPlanKind,
            price: Price,
            expires_on: Option<DateTime<Utc>>,
        },
    }
}
