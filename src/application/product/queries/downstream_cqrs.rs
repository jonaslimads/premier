use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query};

use crate::domain::platform::Platform;
use crate::domain::product::{Product, ProductEvent};
use crate::domain::vendor::Vendor;
use crate::infrastructure::Cqrs;

use crate::application::platform::commands::{CategorizeProductCommand, PlatformCommand};
use crate::application::vendor::commands::{GroupProductCommand, VendorCommand};

pub struct DownstreamCqrs {
    platform_cqrs: Arc<Cqrs<Platform>>,
    vendor_cqrs: Arc<Cqrs<Vendor>>,
}

impl DownstreamCqrs {
    pub fn new(platform_cqrs: Arc<Cqrs<Platform>>, vendor_cqrs: Arc<Cqrs<Vendor>>) -> Self {
        Self {
            platform_cqrs,
            vendor_cqrs,
        }
    }

    pub async fn group_product_on_vendor(
        &self,
        vendor_id: String,
        group_id: String,
        product_id: String,
    ) {
        let vendor_id = vendor_id.clone();
        let command = VendorCommand::GroupProduct(GroupProductCommand {
            id: vendor_id.clone(),
            group_id: group_id.clone(),
            product_id: product_id.to_string(),
        });
        let _ = self.vendor_cqrs.execute(vendor_id.as_str(), command).await;
    }

    pub async fn categorize_product_on_platform(
        &self,
        vendor_id: String,
        category_id: String,
        product_id: String,
    ) {
        let vendor_id = vendor_id.clone();
        let command = PlatformCommand::CategorizeProduct(CategorizeProductCommand {
            id: vendor_id.clone(),
            category_id: category_id.clone(),
            product_id: product_id.to_string(),
        });
        let _ = self
            .platform_cqrs
            .execute(vendor_id.as_str(), command)
            .await;
    }
}

#[async_trait]
impl Query<Product> for DownstreamCqrs {
    async fn dispatch(&self, aggregate_id: &str, events: &[EventEnvelope<Product>]) {
        for event in events {
            match &event.payload {
                ProductEvent::ProductAdded {
                    vendor_id,
                    group_id,
                    ..
                } => {
                    if let Some(group_id) = group_id.clone() {
                        self.group_product_on_vendor(
                            vendor_id.clone(),
                            group_id.clone(),
                            aggregate_id.to_string(),
                        )
                        .await;
                    }
                }
                ProductEvent::ProductGrouped {
                    vendor_id,
                    group_id,
                } => {
                    self.group_product_on_vendor(
                        vendor_id.clone(),
                        group_id.clone(),
                        aggregate_id.to_string(),
                    )
                    .await;
                }
                _ => {}
            }
        }
    }
}
