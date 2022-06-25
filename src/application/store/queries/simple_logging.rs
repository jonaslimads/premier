use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query};

use crate::domain::store::Store;

pub struct SimpleLoggingQuery {}

#[async_trait]
impl Query<Store> for SimpleLoggingQuery {
    async fn dispatch(&self, aggregate_id: &str, events: &[EventEnvelope<Store>]) {
        for event in events {
            let payload = serde_json::to_string_pretty(&event.payload).unwrap();
            log::info!("Store[{}]: {}\n{}", event.sequence, aggregate_id, payload);
        }
    }
}
