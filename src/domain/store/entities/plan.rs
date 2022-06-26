use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{PlanSubscriptionKind, Price};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Plan {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub subscription: PlanSubscription,
}

impl Plan {
    pub fn new(
        id: String,
        name: String,
        attributes: Value,
        subscription: PlanSubscription,
    ) -> Self {
        Self {
            id,
            attributes,
            name,
            subscription,
        }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct PlanSubscription {
    pub id: String,
    pub kind: PlanSubscriptionKind,
    pub price: Price,
    pub expires_on: Option<DateTime<Utc>>,
}
