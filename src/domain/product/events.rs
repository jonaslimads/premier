use std::fmt::Debug;

use cqrs_es::DomainEvent;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::{default_platform_id, skip_default_platform_id};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum ProductEvent {
    ProductAdded {
        id: String,
        #[serde(default = "default_platform_id")]
        #[serde(skip_serializing_if = "skip_default_platform_id")]
        platform_id: String,
        vendor_id: String,
        #[serde(skip_serializing_if = "Option::is_none")]
        category_id: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        group_id: Option<String>,
        name: String,
        description: String,
        slug: String,
        currency: String,
        attachments: Vec<String>,
        attributes: Value,
    },
    ProductArchived {},
    ProductUnarchived {},
    ProductCategorized {
        #[serde(default = "default_platform_id")]
        #[serde(skip_serializing_if = "skip_default_platform_id")]
        platform_id: String,
        category_id: String,
    },
    ProductGrouped {
        vendor_id: String,
        group_id: String,
    },
    ProductNameUpdated {
        name: String,
    },
    ProductDescriptionUpdated {
        description: String,
    },
    ProductSlugUpdated {
        slug: String,
    },
    ProductAttachmentsUpdated {
        attachments: Vec<String>,
    },
    ProductAttributesUpdated {
        attributes: Value,
    },
    ProductVariantAdded {
        variant_id: String,
        sku: String,
        price: u32,
        attachments: Vec<String>,
        attributes: Value,
    },
    ProductVariantStockAdded {
        variant_id: String,
        warehouse_id: String,
        quantity: u32,
    },
    ProductVariantStockRemoved {
        variant_id: String,
        warehouse_id: String,
    },
    ProductVariantStockAllocated {
        variant_id: String,
        warehouse_id: String,
        order_id: String,
        quantity: u32,
    },
    ProductVariantStockReallocated {
        variant_id: String,
        warehouse_id: String,
        order_id: String,
        quantity: u32,
    },
    ProductVariantStockDeallocated {
        variant_id: String,
        warehouse_id: String,
        order_id: String,
    },
}

impl DomainEvent for ProductEvent {
    fn event_type(&self) -> String {
        (match self {
            ProductEvent::ProductAdded { .. } => "ProductAdded",
            ProductEvent::ProductArchived { .. } => "ProductArchived",
            ProductEvent::ProductUnarchived { .. } => "ProductUnarchived",
            ProductEvent::ProductCategorized { .. } => "ProductCategorized",
            ProductEvent::ProductGrouped { .. } => "ProductGrouped",
            ProductEvent::ProductNameUpdated { .. } => "ProductNameUpdated",
            ProductEvent::ProductSlugUpdated { .. } => "ProductSlugUpdated",
            ProductEvent::ProductDescriptionUpdated { .. } => "ProductDescriptionUpdated",
            ProductEvent::ProductAttachmentsUpdated { .. } => "ProductAttachmentsUpdated",
            ProductEvent::ProductAttributesUpdated { .. } => "ProductAttributesUpdated",
            ProductEvent::ProductVariantAdded { .. } => "ProductVariantAdded",
            ProductEvent::ProductVariantStockAdded { .. } => "ProductVariantStockAdded",
            ProductEvent::ProductVariantStockRemoved { .. } => "ProductVariantStockRemoved",
            ProductEvent::ProductVariantStockAllocated { .. } => "ProductVariantStockAllocated",
            ProductEvent::ProductVariantStockReallocated { .. } => "ProductVariantStockReallocated",
            ProductEvent::ProductVariantStockDeallocated { .. } => "ProductVariantStockDeallocated",
        })
        .to_string()
    }

    fn event_version(&self) -> String {
        "0.1.0".to_string()
    }
}
