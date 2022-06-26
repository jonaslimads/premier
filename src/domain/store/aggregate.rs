use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::store::commands::StoreCommand;
use crate::application::store::services::StoreServices;
use crate::commons::{HasNestedGroups, HasNestedGroupsWithItems};
use crate::domain::store::entities::{Page, Plan, Platform, Seller, Store};
use crate::domain::store::{StoreError, StoreEvent};

#[async_trait]
impl Aggregate for Store {
    type Command = StoreCommand;

    type Event = StoreEvent;

    type Error = StoreError;

    type Services = StoreServices;

    fn aggregate_type() -> String {
        "".to_string()
    }

    async fn handle(
        &self,
        command: Self::Command,
        _services: &Self::Services,
    ) -> Result<Vec<Self::Event>, Self::Error> {
        Ok(match command {
            StoreCommand::AddStore(command) => vec![
                StoreEvent::StoreAdded {
                    id: command.id,
                    platform_id: command.platform_id,
                    name: command.name,
                    attributes: command.attributes,
                },
                StoreEvent::SellerUpdated {
                    name: command.seller.name,
                    attributes: command.seller.attributes,
                },
            ],
            StoreCommand::ArchiveStore(_) => vec![StoreEvent::StoreArchived {}],
            StoreCommand::UnarchiveStore(_) => vec![StoreEvent::StoreUnarchived {}],
            StoreCommand::AddPage(command) => vec![StoreEvent::PageAdded {
                page_id: command.page_id,
                name: command.name,
                slug: command.slug,
                order: command.order,
                parent_page_id: command.parent_page_id,
            }],
            StoreCommand::PageProduct(command) => vec![StoreEvent::ProductPaged {
                page_id: command.page_id,
                product_id: command.product_id,
            }],
            StoreCommand::SubscribeToPlan(command) => vec![StoreEvent::PlanSubscribed {
                name: command.name,
                attributes: command.attributes,
                kind: command.kind,
                price: command.price,
                expires_on: command.expires_on,
            }],
        })
    }

    fn apply(&mut self, event: Self::Event) {
        match event {
            StoreEvent::StoreAdded {
                id,
                platform_id,
                name,
                attributes,
            } => {
                self.id = id;
                self.platform = Platform::new(platform_id);
                self.name = name;
                self.attributes = attributes;
                self.is_archived = false;
            }
            StoreEvent::SellerUpdated { name, attributes } => {
                self.seller = Seller::new(name, attributes)
            }
            StoreEvent::StoreArchived {} => self.is_archived = true,
            StoreEvent::StoreUnarchived {} => self.is_archived = false,
            StoreEvent::PageAdded {
                page_id,
                name,
                slug,
                order,
                parent_page_id,
            } => self.add_group(Page::new(page_id, name, slug, order), parent_page_id),
            StoreEvent::ProductPaged {
                page_id,
                product_id,
            } => {
                self.group(page_id, product_id);
            }
            StoreEvent::PlanSubscribed {
                name,
                attributes,
                kind,
                price,
                expires_on,
            } => {
                self.plan = Plan::new(name, attributes, kind, price, expires_on);
            }
        }
    }
}

// https://github.com/serverlesstechnology/cqrs-demo/blob/master/src/domain/aggregate.rs
#[cfg(test)]
mod aggregate_tests {
    use std::sync::Mutex;

    use async_trait::async_trait;
    use cqrs_es::test::TestFramework;
    use serde_json::json;

    use crate::application::store::commands::{
        AddStoreCommand, AddStoreCommandSeller, StoreCommand,
    };
    use crate::application::store::services::{CouldNotFindIdError, StoreApi, StoreServices};
    use crate::domain::store::{Store, StoreEvent};

    type StoreTestFramework = TestFramework<Store>;

    #[test]
    fn test_a() {
        let expected = StoreEvent::StoreAdded {
            id: "".to_string(),
            platform_id: "".to_string(),
            name: "".to_string(),
            attributes: json!({}),
        };
        let command = StoreCommand::AddStore(AddStoreCommand {
            id: "".to_string(),
            platform_id: "".to_string(),
            name: "".to_string(),
            attributes: json!({}),
            seller: AddStoreCommandSeller {
                name: "".to_string(),
                attributes: json!({}),
            },
        });

        let services = StoreServices::new(Box::new(MockStoreServices::default()));
        StoreTestFramework::with(services)
            .given_no_previous_events()
            .when(command)
            .then_expect_events(vec![expected]);
    }

    pub struct MockStoreServices {
        test: Mutex<Option<Result<String, CouldNotFindIdError>>>,
    }

    impl Default for MockStoreServices {
        fn default() -> Self {
            Self {
                test: Mutex::new(None),
            }
        }
    }

    impl MockStoreServices {
        // fn set_test(&self, response: Result<String, CouldNotFindIdError>) {
        //     *self.test.lock().unwrap() = Some(response);
        // }
    }

    #[async_trait]
    impl StoreApi for MockStoreServices {
        async fn find_id(&self) -> Result<String, CouldNotFindIdError> {
            self.test.lock().unwrap().take().unwrap()
        }
    }
}
