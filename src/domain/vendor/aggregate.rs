use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::vendor::commands::VendorCommand;
use crate::application::vendor::services::VendorServices;
use crate::domain::vendor::{Vendor, VendorError, VendorEvent};

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
                name: command.name,
                attributes: command.attributes,
            }],
            VendorCommand::ArchiveVendor(_) => vec![VendorEvent::VendorArchived {}],
            VendorCommand::UnarchiveVendor(_) => vec![VendorEvent::VendorUnarchived {}],
        })
    }

    fn apply(&mut self, event: Self::Event) {
        match event {
            VendorEvent::VendorAdded {
                id,
                name,
                attributes,
            } => {
                self.id = id;
                self.name = name;
                self.attributes = attributes;
            }
            VendorEvent::VendorArchived {} => self.is_archived = true,
            VendorEvent::VendorUnarchived {} => self.is_archived = false,
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
            name: "".to_string(),
            attributes: json!({}),
        };
        let command = VendorCommand::AddVendor(AddVendorCommand {
            id: "".to_string(),
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
