use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{Price, SubscriptionPlanKind};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Plan {
    pub name: String,
    pub attributes: Value,
    pub subscription: SubscriptionPlan,
}

impl Plan {
    pub fn new(
        name: String,
        attributes: Value,
        kind: SubscriptionPlanKind,
        price: Price,
        expires_on: Option<DateTime<Utc>>,
    ) -> Self {
        Self {
            attributes,
            name,
            subscription: SubscriptionPlan {
                kind,
                price,
                expires_on,
            },
        }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct SubscriptionPlan {
    pub kind: SubscriptionPlanKind,
    pub price: Price,
    pub expires_on: Option<DateTime<Utc>>,
}
