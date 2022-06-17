use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::vendor::commands::VendorCommand;
use crate::application::vendor::services::VendorServices;
use crate::commons::{HasNestedGroups, HasNestedGroupsWithItems};
use crate::domain::vendor::entities::{Group, Platform, Vendor};
use crate::domain::vendor::{VendorError, VendorEvent};

#[async_trait]
impl Aggregate for Vendor {
    type Command = VendorCommand;

    type Event = VendorEvent;

    type Error = VendorError;

    type Services = VendorServices;

    fn aggregate_type() -> String {
        "".to_string()
    }

    async fn handle(
        &self,
        command: Self::Command,
        _services: &Self::Services,
    ) -> Result<Vec<Self::Event>, Self::Error> {
        Ok(match command {
            VendorCommand::AddVendor(command) => vec![VendorEvent::VendorAdded {
                id: command.id,
                platform_id: command.platform_id,
                name: command.name,
                attributes: command.attributes,
            }],
            VendorCommand::ArchiveVendor(_) => vec![VendorEvent::VendorArchived {}],
            VendorCommand::UnarchiveVendor(_) => vec![VendorEvent::VendorUnarchived {}],
            VendorCommand::AddGroup(command) => vec![VendorEvent::GroupAdded {
                group_id: command.group_id,
                name: command.name,
                slug: command.slug,
                order: command.order,
                parent_group_id: command.parent_group_id,
            }],
            VendorCommand::GroupProduct(command) => vec![VendorEvent::ProductGrouped {
                group_id: command.group_id,
                product_id: command.product_id,
            }],
        })
    }

    fn apply(&mut self, event: Self::Event) {
        match event {
            VendorEvent::VendorAdded {
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
            VendorEvent::VendorArchived {} => self.is_archived = true,
            VendorEvent::VendorUnarchived {} => self.is_archived = false,
            VendorEvent::GroupAdded {
                group_id,
                name,
                slug,
                order,
                parent_group_id,
            } => self.add_group(Group::new(group_id, name, slug, order), parent_group_id),
            VendorEvent::ProductGrouped {
                group_id,
                product_id,
            } => self.group(group_id, product_id),
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

    use crate::application::vendor::commands::{AddVendorCommand, VendorCommand};
    use crate::application::vendor::services::{CouldNotFindIdError, VendorApi, VendorServices};
    use crate::domain::vendor::{Vendor, VendorEvent};

    type VendorTestFramework = TestFramework<Vendor>;

    #[test]
    fn test_a() {
        let expected = VendorEvent::VendorAdded {
            id: "".to_string(),
            platform_id: "".to_string(),
            name: "".to_string(),
            attributes: json!({}),
        };
        let command = VendorCommand::AddVendor(AddVendorCommand {
            id: "".to_string(),
            platform_id: "".to_string(),
            name: "".to_string(),
            attributes: json!({}),
        });

        let services = VendorServices::new(Box::new(MockVendorServices::default()));
        VendorTestFramework::with(services)
            .given_no_previous_events()
            .when(command)
            .then_expect_events(vec![expected]);
    }

    pub struct MockVendorServices {
        test: Mutex<Option<Result<String, CouldNotFindIdError>>>,
    }

    impl Default for MockVendorServices {
        fn default() -> Self {
            Self {
                test: Mutex::new(None),
            }
        }
    }

    impl MockVendorServices {
        // fn set_test(&self, response: Result<String, CouldNotFindIdError>) {
        //     *self.test.lock().unwrap() = Some(response);
        // }
    }

    #[async_trait]
    impl VendorApi for MockVendorServices {
        async fn find_id(&self) -> Result<String, CouldNotFindIdError> {
            self.test.lock().unwrap().take().unwrap()
        }
    }
}
