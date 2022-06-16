use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::platform::commands::PlatformCommand;
use crate::application::platform::services::PlatformServices;
use crate::domain::platform::entities::Platform;
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
            PlatformCommand::UpdatePlatformName(command) => {
                vec![PlatformEvent::PlatformNameUpdated { name: command.name }]
            }
            PlatformCommand::UpdatePlatformAttributes(command) => {
                vec![PlatformEvent::PlatformAttributesUpdated {
                    attributes: command.attributes,
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
            PlatformEvent::CategoryAdded {
                category_id,
                name,
                slug,
                order,
                parent_category_id,
            } => {
                // self.add_group(Group::new(group_id, name, slug, order), parent_group_id)
            }
            PlatformEvent::ProductCategorized {
                category_id,
                product_id,
            } => {
                // self.group_product(group_id, product_id)
            }
            PlatformEvent::PlatformNameUpdated { name } => self.name = name,
            PlatformEvent::PlatformAttributesUpdated { attributes } => self.attributes = attributes,
        }
    }
}
