use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::product::entities::{Category, Page, Store, Variant};
use crate::domain::product::ProductError;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Product {
    pub id: String,
    pub store: Store,
    pub category: Option<Category>,
    pub page: Option<Page>,
    pub name: String,
    pub description: String,
    pub slug: String,
    pub currency: String,
    pub attachments: Vec<String>,
    pub attributes: Value,
    pub is_published: bool,
    pub variants: Vec<Variant>,
}

impl Product {
    pub fn has_variant_with_stock_from_warehouse(
        &self,
        variant_id: String,
        warehouse_id: String,
    ) -> bool {
        for variant in self.variants.iter() {
            if variant.id == variant_id {
                if variant.has_stock_from_warehouse(warehouse_id.clone()) {
                    return true;
                }
            }
        }
        false
    }

    pub fn get_variant_or_error(&self, variant_id: String) -> Result<Variant, ProductError> {
        self.get_variant(variant_id)
            .ok_or(ProductError::VariantNotFound)
    }

    fn get_variant(&self, variant_id: String) -> Option<Variant> {
        for variant in self.variants.iter() {
            if variant.id == variant_id {
                return Some(variant.clone());
            }
        }
        None
    }

    pub fn get_variant_as_mut_ref(&mut self, variant_id: String) -> Option<&mut Variant> {
        for variant in self.variants.iter_mut() {
            if variant.id == variant_id {
                return Some(variant);
            }
        }
        None
    }

    pub fn has_variant(&self, variant_id: String) -> bool {
        self.get_variant_index(variant_id).is_some()
    }

    fn get_variant_index(&self, variant_id: String) -> Option<usize> {
        self.variants
            .iter()
            .position(|variant| variant.id == variant_id)
    }

    pub fn add_variant(
        &mut self,
        variant_id: String,
        sku: String,
        price: u32,
        attachments: Vec<String>,
        attributes: Value,
    ) {
        self.variants.push(Variant::new(
            variant_id,
            sku,
            price,
            attachments,
            attributes,
        ))
    }

    pub fn add_stock(&mut self, variant_id: String, warehouse_id: String, quantity: u32) {
        if let Some(variant) = self.get_variant_as_mut_ref(variant_id) {
            variant.add_stock(warehouse_id, quantity)
        }
    }

    pub fn remove_stock(&mut self, variant_id: String, warehouse_id: String) {
        if let Some(variant) = self.get_variant_as_mut_ref(variant_id) {
            variant.remove_stock(warehouse_id)
        }
    }
}
