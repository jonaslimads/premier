use std::fmt::Debug;

use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{Price, SubscriptionPlanKind};
use crate::domain::event_enum;

event_enum! {
    version "0.1.0",
    enum PlatformEvent {
        PlatformAdded {
            id: String,
            name: String,
            attributes: Value,
        },
        PlatformUpdated {
            #[serde(skip_serializing_if = "Option::is_none")]
            name: Option<String>,
            #[serde(skip_serializing_if = "Option::is_none")]
            attributes: Option<Value>,
        },
        PlanAdded {
            name: String,
            order: u16,
            attributes: Value,
            subscriptions: Vec<PlatformEventPlanAddedSubscription>,
        },
        SubscriptionPlanUpdated {
            plan_name: String,
            kind: SubscriptionPlanKind,
            price: Price,
            expires_in: Option<u16>,
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
    }
}

#[derive(Clone, Debug, Deserialize, PartialEq, Serialize)]
pub struct PlatformEventPlanAddedSubscription {
    pub kind: SubscriptionPlanKind,
    pub price: Price,
    pub expires_in: Option<u16>,
}
