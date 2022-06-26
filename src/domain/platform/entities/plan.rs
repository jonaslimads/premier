use serde::{Deserialize, Serialize};
use serde_json::Value;

use super::super::events::PlatformEventPlanAddedSubscription;
use crate::commons::{HasId, Price, SubscriptionPlanKind};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Plan {
    pub name: String,
    pub order: u16,
    pub attributes: Value,
    pub subscriptions: Vec<SubscriptionPlan>,
}

impl Plan {
    pub fn new(
        name: String,
        order: u16,
        attributes: Value,
        subscriptions: Vec<SubscriptionPlan>,
    ) -> Self {
        Self {
            name,
            order,
            attributes,
            subscriptions,
        }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct SubscriptionPlan {
    pub kind: SubscriptionPlanKind,
    pub price: Price,
    pub expires_in: Option<u16>,
}

impl From<PlatformEventPlanAddedSubscription> for SubscriptionPlan {
    fn from(event: PlatformEventPlanAddedSubscription) -> Self {
        Self {
            kind: event.kind,
            price: event.price,
            expires_in: event.expires_in,
        }
    }
}

impl HasId for Plan {
    fn id(&self) -> String {
        self.name.clone()
    }
}
