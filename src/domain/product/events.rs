use std::fmt::Debug;

use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::{default_platform_id, event_enum, skip_default_platform_id};

event_enum! {
    version "0.1.0",
    enum ProductEvent {
        ProductAdded {
            id: String,
            #[serde(default = "default_platform_id")]
            #[serde(skip_serializing_if = "skip_default_platform_id")]
            platform_id: String,
            store_id: String,
            #[serde(skip_serializing_if = "Option::is_none")]
            category_id: Option<String>,
            #[serde(skip_serializing_if = "Option::is_none")]
            page_id: Option<String>,
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
        ProductPaged {
            store_id: String,
            page_id: String,
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
}
