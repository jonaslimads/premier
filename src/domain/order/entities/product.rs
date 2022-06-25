use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::order::entities::{Store, Variant};
use crate::domain::order::error::OrderError;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Product {
    pub id: String,
    pub store: Store,
    pub name: String,
    pub slug: String,
    pub currency: String,
    pub attachment: String,
    pub attributes: Value,
    pub variants: Vec<Variant>,
}

impl Product {
    pub fn new(
        id: String,
        store_id: String,
        name: String,
        slug: String,
        currency: String,
        attachment: String,
        attributes: Value,
    ) -> Self {
        Self {
            id,
            store: Store { id: store_id },
            name,
            slug,
            currency,
            attachment,
            attributes,
            variants: vec![],
        }
    }

    pub fn get_variant_or_error(&self, variant_id: String) -> Result<&Variant, OrderError> {
        self.get_variant(variant_id)
            .ok_or(OrderError::ProductVariantNotFound)
    }

    pub fn get_variant(&self, variant_id: String) -> Option<&Variant> {
        for variant in self.variants.iter() {
            if variant.id == variant_id {
                return Some(variant);
            }
        }
        None
    }

    pub fn add_variant(
        &mut self,
        variant_id: String,
        sku: String,
        price: u32,
        attachment: String,
        attributes: Value,
    ) {
        self.variants
            .push(Variant::new(variant_id, sku, price, attachment, attributes))
    }
}
