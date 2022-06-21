use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::product::events::ProductEvent;
use crate::domain::product::Product;
use crate::infrastructure::ViewRepository;

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct ProductView {
    pub id: String,
    pub vendor: ProductViewVendor,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub page: Option<ProductViewPage>,
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
pub struct ProductViewPage {
    id: String,
}

impl ProductViewPage {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct ProductViewReview {
    pub id: String,
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
                platform_id,
                vendor_id,
                category_id: _,
                page_id,
                name,
                description,
                slug,
                currency,
                attachments,
                attributes,
            } => {
                self.id = id.clone();
                self.vendor = ProductViewVendor::new(vendor_id.clone());
                self.page = page_id.clone().map(|id| ProductViewPage::new(id));
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
            ProductEvent::ProductPaged {
                vendor_id: _,
                page_id,
            } => {
                self.page = Some(ProductViewPage::new(page_id.clone()));
            }
            ProductEvent::ProductNameUpdated { name } => {
                self.name = name.clone();
            }
            ProductEvent::ProductDescriptionUpdated { description } => {
                self.description = description.clone();
            }
            ProductEvent::ProductSlugUpdated { slug } => {
                self.slug = slug.clone();
            }
            _ => {}
        }
    }
}

pub type ProductQuery = GenericQuery<ViewRepository<ProductView, Product>, ProductView, Product>;
