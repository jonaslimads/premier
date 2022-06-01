use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use mysql_es::MysqlViewRepository;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::events::VendorEvent;
use crate::domain::vendor::Vendor;

#[derive(Debug, Default, Serialize, Deserialize, SimpleObject)]
pub struct VendorProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub products: Vec<VendorProductsViewProduct>,
}

#[derive(Debug, Default, Serialize, Deserialize, SimpleObject)]
pub struct VendorProductsViewProduct {
    pub id: String,
    pub name: String,
    pub description: String,
    pub slug: String,
    pub currency: String,
    pub is_archived: bool,
}

impl VendorProductsView {
    pub fn get_product_mut(
        &mut self,
        product_id: String,
    ) -> Option<&mut VendorProductsViewProduct> {
        for product in &mut self.products {
            if product.id == product_id {
                return Some(product);
            }
        }
        None
    }
}

impl View<Vendor> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Vendor>) {
        match &event.payload {
            VendorEvent::VendorAdded {
                id,
                name,
                attributes,
            } => {
                self.id = id.clone();
                self.name = name.clone();
                self.attributes = attributes.clone();
                self.is_archived = true;
            }
            VendorEvent::VendorArchived {} => self.is_archived = true,
            VendorEvent::VendorUnarchived {} => self.is_archived = false,
        }
    }
}

pub type VendorProductsQuery =
    GenericQuery<MysqlViewRepository<VendorProductsView, Vendor>, VendorProductsView, Vendor>;
