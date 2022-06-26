use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::platform::commands::PlatformCommand;
use crate::application::platform::services::PlatformServices;
use crate::commons::{HasItems, HasNestedGroups};
use crate::domain::platform::entities::{Category, Plan, PlanSubscription, Platform};
use crate::domain::platform::events::PlatformEventPlanAddedSubscription;
use crate::domain::platform::{PlatformError, PlatformEvent};

#[async_trait]
impl Aggregate for Platform {
    type Command = PlatformCommand;

    type Event = PlatformEvent;

    type Error = PlatformError;

    type Services = Arc<PlatformServices>;

    fn aggregate_type() -> String {
        "".to_string()
    }

    async fn handle(
        &self,
        command: Self::Command,
        _services: &Self::Services,
    ) -> Result<Vec<Self::Event>, Self::Error> {
        Ok(match command {
            PlatformCommand::AddPlatform(command) => vec![PlatformEvent::PlatformAdded {
                id: command.id,
                name: command.name,
                attributes: command.attributes,
            }],
            PlatformCommand::UpdatePlatform(command) => {
                vec![PlatformEvent::PlatformUpdated {
                    name: command.name,
                    attributes: command.attributes,
                }]
            }
            PlatformCommand::AddPlan(command) => vec![PlatformEvent::PlanAdded {
                name: command.name,
                order: command.order,
                attributes: command.attributes,
                subscriptions: command
                    .subscriptions
                    .into_iter()
                    .map(|s| PlatformEventPlanAddedSubscription::from(s))
                    .collect(),
            }],
            PlatformCommand::AddCategory(command) => vec![PlatformEvent::CategoryAdded {
                category_id: command.category_id,
                name: command.name,
                slug: command.slug,
                order: command.order,
                parent_category_id: command.parent_category_id,
            }],
            PlatformCommand::CategorizeProduct(command) => {
                vec![PlatformEvent::ProductCategorized {
                    category_id: command.category_id,
                    product_id: command.product_id,
                }]
            }
        })
    }

    fn apply(&mut self, event: Self::Event) {
        match event {
            PlatformEvent::PlatformAdded {
                id,
                name,
                attributes,
            } => {
                self.id = id;
                self.name = name;
                self.attributes = attributes;
            }
            PlatformEvent::PlatformUpdated { name, attributes } => {
                if let Some(name) = name {
                    self.name = name.clone();
                }
                if let Some(attributes) = attributes {
                    self.attributes = attributes.clone();
                }
            }
            PlatformEvent::PlanAdded {
                name,
                order,
                attributes,
                subscriptions,
            } => self.add_item(Plan::new(
                name,
                order,
                attributes,
                subscriptions
                    .into_iter()
                    .map(|s| PlanSubscription::from(s))
                    .collect(),
            )),
            PlatformEvent::PlanSubscriptionUpdated {
                plan_name,
                kind,
                price,
                expires_in,
            } => {
                if let Some(plan) = self.get_item_mut(plan_name) {
                    for subscription in plan.subscriptions.iter_mut() {
                        if subscription.kind == kind {
                            subscription.price = price;
                            subscription.expires_in = expires_in;
                        }
                    }
                }
            }
            PlatformEvent::CategoryAdded {
                category_id,
                name,
                slug,
                order,
                parent_category_id,
            } => self.add_group(
                Category::new(category_id, name, slug, order),
                parent_category_id,
            ),
            PlatformEvent::ProductCategorized {
                category_id: _,
                product_id: _,
            } => {
                // self.page_product(category_id, product_id)
            }
        }
    }
}
