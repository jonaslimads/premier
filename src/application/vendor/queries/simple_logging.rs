use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query};

use crate::domain::vendor::Vendor;

pub struct SimpleLoggingQuery {}

#[async_trait]
impl Query<Vendor> for SimpleLoggingQuery {
    async fn dispatch(&self, aggregate_id: &str, events: &[EventEnvelope<Vendor>]) {
        for event in events {
            let payload = serde_json::to_string_pretty(&event.payload).unwrap();
            log::info!("Vendor[{}]: {}\n{}", event.sequence, aggregate_id, payload);
        }
    }
}
