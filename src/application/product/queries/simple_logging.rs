use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query};

use crate::domain::product::Product;

pub struct SimpleLoggingQuery {}

#[async_trait]
impl Query<Product> for SimpleLoggingQuery {
    async fn dispatch(
        &self,
        aggregate_id: &str,
        events: &[EventEnvelope<Product>],
        _secondary_id: Option<&str>,
    ) {
        for event in events {
            let payload = serde_json::to_string_pretty(&event.payload).unwrap();
            log::info!("Product[{}]: {}\n{}", event.sequence, aggregate_id, payload);
        }
    }
}
