use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query};

use crate::domain::platform::Platform;
use crate::domain::product::{Product, ProductEvent};
use crate::domain::store::Store;
use crate::infrastructure::Cqrs;

use crate::application::platform::commands::{CategorizeProductCommand, PlatformCommand};
use crate::application::store::commands::{PageProductCommand, StoreCommand};

pub struct DownstreamCqrs {
    platform_cqrs: Arc<Cqrs<Platform>>,
    store_cqrs: Arc<Cqrs<Store>>,
}

impl DownstreamCqrs {
    pub fn new(platform_cqrs: Arc<Cqrs<Platform>>, store_cqrs: Arc<Cqrs<Store>>) -> Self {
        Self {
            platform_cqrs,
            store_cqrs,
        }
    }

    pub async fn page_product(&self, store_id: String, page_id: String, product_id: String) {
        let store_id = store_id.clone();
        let command = StoreCommand::PageProduct(PageProductCommand {
            id: store_id.clone(),
            page_id: page_id.clone(),
            product_id: product_id.to_string(),
        });
        let _ = self.store_cqrs.execute(store_id.as_str(), command).await;
    }

    pub async fn categorize_product(
        &self,
        platform_id: String,
        category_id: String,
        product_id: String,
    ) {
        let platform_id = platform_id.clone();
        let command = PlatformCommand::CategorizeProduct(CategorizeProductCommand {
            id: platform_id.clone(),
            category_id: category_id.clone(),
            product_id: product_id.to_string(),
        });
        let _ = self
            .platform_cqrs
            .execute(platform_id.as_str(), command)
            .await;
    }
}

#[async_trait]
impl Query<Product> for DownstreamCqrs {
    async fn dispatch(&self, aggregate_id: &str, events: &[EventEnvelope<Product>]) {
        for event in events {
            match &event.payload {
                ProductEvent::ProductAdded {
                    platform_id,
                    category_id,
                    store_id,
                    page_id,
                    ..
                } => {
                    if let Some(category_id) = category_id.clone() {
                        self.categorize_product(
                            platform_id.clone(),
                            category_id.clone(),
                            aggregate_id.to_string(),
                        )
                        .await;
                    }
                    if let Some(page_id) = page_id.clone() {
                        self.page_product(
                            store_id.clone(),
                            page_id.clone(),
                            aggregate_id.to_string(),
                        )
                        .await;
                    }
                }
                ProductEvent::ProductCategorized {
                    platform_id,
                    category_id,
                } => {
                    self.categorize_product(
                        platform_id.clone(),
                        category_id.clone(),
                        aggregate_id.to_string(),
                    )
                    .await;
                }
                ProductEvent::ProductPaged { store_id, page_id } => {
                    self.page_product(store_id.clone(), page_id.clone(), aggregate_id.to_string())
                        .await;
                }
                _ => {}
            }
        }
    }
}
