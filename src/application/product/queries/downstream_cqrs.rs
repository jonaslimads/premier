use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query};

use crate::domain::product::{Product, ProductEvent};
use crate::domain::vendor::Vendor;
use crate::infrastructure::Cqrs;

use crate::application::vendor::commands::{CategorizeProductCommand, VendorCommand};

// #[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct DownstreamCqrs {
    vendor_cqrs: Arc<Cqrs<Vendor>>,
}

impl DownstreamCqrs {
    pub fn new(vendor_cqrs: Arc<Cqrs<Vendor>>) -> Self {
        Self { vendor_cqrs }
    }

    pub async fn categorize_product_on_vendor(
        &self,
        vendor_id: String,
        category_id: String,
        product_id: String,
    ) {
        let vendor_id = vendor_id.clone();
        let command = VendorCommand::CategorizeProduct(CategorizeProductCommand {
            id: vendor_id.clone(),
            category_id: category_id.clone(),
            product_id: product_id.to_string(),
        });
        let _ = self.vendor_cqrs.execute(vendor_id.as_str(), command).await;
    }
}

#[async_trait]
impl Query<Product> for DownstreamCqrs {
    async fn dispatch(&self, aggregate_id: &str, events: &[EventEnvelope<Product>]) {
        for event in events {
            match &event.payload {
                ProductEvent::ProductAdded {
                    vendor_id,
                    category_id,
                    ..
                } => {
                    if let Some(category_id) = category_id.clone() {
                        self.categorize_product_on_vendor(
                            vendor_id.clone(),
                            category_id.clone(),
                            aggregate_id.to_string(),
                        )
                        .await;
                    }
                }
                ProductEvent::ProductCategorized {
                    vendor_id,
                    category_id,
                } => {
                    self.categorize_product_on_vendor(
                        vendor_id.clone(),
                        category_id.clone(),
                        aggregate_id.to_string(),
                    )
                    .await;
                }
                _ => {}
            }
        }
    }
}
