use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{Currency, HasId, HasItems, HasNestedGroups, PlanSubscriptionKind};
use crate::domain::platform::events::{PlatformEvent, PlatformEventPlanAddedSubscription};
use crate::domain::platform::Platform;
use crate::infrastructure::ViewRepository;

impl View<Platform> for PlatformView {
    fn update(&mut self, event: &EventEnvelope<Platform>) {
        match &event.payload {
            PlatformEvent::PlatformAdded {
                id,
                name,
                attributes,
            } => {
                self.id = id.clone();
                self.name = name.clone();
                self.attributes = attributes.clone();
            }
            PlatformEvent::PlatformUpdated { name, attributes } => {
                if let Some(name) = name {
                    self.name = name.clone();
                }
                if let Some(attributes) = attributes {
                    self.attributes = attributes.clone();
                }
            }
            PlatformEvent::PlanSubscriptionUpdated { .. } => {}
            PlatformEvent::PlanAdded {
                name,
                order,
                attributes,
                subscriptions,
            } => self.add_item(PlatformViewPlan::new(
                name.clone(),
                order.clone(),
                attributes.clone(),
                subscriptions
                    .clone()
                    .into_iter()
                    .map(|s| PlatformViewPlanSubscription::from(s))
                    .collect(),
            )),
            PlatformEvent::CategoryAdded {
                category_id,
                name,
                slug,
                order,
                parent_category_id,
            } => self.add_group(
                PlatformViewCategory::new(
                    category_id.clone(),
                    name.clone(),
                    slug.clone(),
                    order.clone(),
                ),
                parent_category_id.clone(),
            ),
            PlatformEvent::ProductCategorized {
                category_id: _,
                product_id: _,
            } => {
                // self.page_product(page_id, product_id)
            }
        }
    }
}

pub type PlatformQuery =
    GenericQuery<ViewRepository<PlatformView, Platform>, PlatformView, Platform>;

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub plans: Vec<PlatformViewPlan>,
    pub categories: Vec<PlatformViewCategory>,
    pub campaigns: Vec<PlatformViewCampaign>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewPlan {
    pub name: String,
    pub order: u16,
    pub attributes: Value,
    pub subscriptions: Vec<PlatformViewPlanSubscription>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewCategory {
    pub id: String,
    pub name: String,
    pub slug: String,
    #[graphql(skip)]
    pub order: u16,
    #[graphql(skip)]
    pub is_archived: bool,
    pub children: Vec<PlatformViewCategory>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewCampaign {
    pub id: String,
}

impl PlatformViewPlan {
    pub fn new(
        name: String,
        order: u16,
        attributes: Value,
        subscriptions: Vec<PlatformViewPlanSubscription>,
    ) -> Self {
        Self {
            name,
            order,
            attributes,
            subscriptions,
        }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewPlanSubscription {
    pub kind: PlanSubscriptionKind,
    pub price: PlatformViewPlanSubscriptionPrice,
    pub expires_in: Option<u16>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewPlanSubscriptionPrice {
    pub currency: Currency,
    pub amount: u32,
}

impl From<PlatformEventPlanAddedSubscription> for PlatformViewPlanSubscription {
    fn from(subscription: PlatformEventPlanAddedSubscription) -> Self {
        Self {
            kind: subscription.kind,
            price: PlatformViewPlanSubscriptionPrice {
                currency: subscription.price.currency,
                amount: subscription.price.amount,
            },
            expires_in: subscription.expires_in,
        }
    }
}

impl PlatformViewCategory {
    pub fn new(id: String, name: String, slug: String, order: u16) -> Self {
        Self {
            id,
            name,
            slug,
            order,
            is_archived: false,
            children: Vec::new(),
        }
    }
}

impl HasId for PlatformView {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasId for PlatformViewPlan {
    fn id(&self) -> String {
        self.name.clone()
    }
}

impl HasItems<PlatformViewPlan> for PlatformView {
    fn get_items_mut(&mut self) -> &mut Vec<PlatformViewPlan> {
        &mut self.plans
    }

    fn get_comparator() -> Option<Box<dyn Fn(&PlatformViewPlan, &PlatformViewPlan) -> bool>> {
        Some(Box::new(|new, current| {
            (new.order < current.order) || (new.order == current.order && new.name < current.name)
        }))
    }
}

impl HasId for PlatformViewCategory {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasNestedGroups<PlatformViewCategory> for PlatformView {
    fn get_groups_mut(&mut self) -> &mut Vec<PlatformViewCategory> {
        &mut self.categories
    }

    fn get_comparator() -> Option<Box<dyn Fn(&PlatformViewCategory, &PlatformViewCategory) -> bool>>
    {
        Some(Box::new(|new, current| {
            (new.order < current.order) || (new.order == current.order && new.name < current.name)
        }))
    }
}

impl HasNestedGroups<PlatformViewCategory> for PlatformViewCategory {
    fn get_groups_mut(&mut self) -> &mut Vec<PlatformViewCategory> {
        &mut self.children
    }
}
