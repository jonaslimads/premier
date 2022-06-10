use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use mysql_es::MysqlViewRepository;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::product::events::ProductEvent;
use crate::domain::product::Product;

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct ProductView {
    pub id: String,
    pub vendor: ProductViewVendor,
    pub category: Option<ProductViewCategory>,
    pub name: String,
    pub description: String,
    pub slug: String,
    pub currency: String,
    pub price: u32,
    pub attachments: Vec<String>,
    pub attributes: Value,
    pub is_archived: bool,
    pub reviews: Vec<ProductViewReview>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct ProductViewVendor {
    id: String,
}

impl ProductViewVendor {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct ProductViewCategory {
    id: String,
}

impl ProductViewCategory {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct ProductViewReview {
    id: String,
}

// impl ProductViewReview {
//     pub fn new(id: String) -> Self {
//         Self { id }
//     }
// }

impl View<Product> for ProductView {
    fn update(&mut self, event: &EventEnvelope<Product>) {
        match &event.payload {
            ProductEvent::ProductAdded {
                id,
                vendor_id,
                category_id,
                name,
                description,
                slug,
                currency,
                attachments,
                attributes,
            } => {
                self.id = id.clone();
                self.vendor = ProductViewVendor::new(vendor_id.clone());
                self.category = category_id.clone().map(|id| ProductViewCategory::new(id));
                self.name = name.clone();
                self.description = description.clone();
                self.slug = slug.clone();
                self.currency = currency.clone();
                self.price = 0;
                self.attachments = attachments.clone();
                self.attributes = attributes.clone();
                self.is_archived = false;
            }
            ProductEvent::ProductArchived {} => {
                self.is_archived = true;
            }
            ProductEvent::ProductUnarchived {} => {
                self.is_archived = false;
            }
            ProductEvent::ProductCategorized {
                vendor_id: _,
                category_id,
            } => {
                self.category = Some(ProductViewCategory::new(category_id.clone()));
            }
            ProductEvent::ProductNameUpdated { name } => {
                self.name = name.clone();
            }
            ProductEvent::ProductSlugUpdated { slug } => {
                self.slug = slug.clone();
            }
            _ => {}
        }
    }
}

pub type ProductQuery =
    GenericQuery<MysqlViewRepository<ProductView, Product>, ProductView, Product>;
