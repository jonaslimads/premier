use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{HasId, HasItems, HasNestedGroups, HasNestedGroupsWithItems};
use crate::domain::vendor::events::VendorEvent;
use crate::domain::vendor::Vendor;
use crate::infrastructure::ViewRepository;

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub pages: Vec<VendorProductsViewPage>,
    pub unpaged_products: Vec<VendorProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsViewPage {
    pub id: String,
    pub name: String,
    pub slug: String,
    #[graphql(skip)]
    pub order: u16,
    #[graphql(skip)]
    pub is_archived: bool,
    pub children: Vec<VendorProductsViewPage>,
    pub products: Vec<VendorProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsViewProduct {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub currency: String,
    pub price: u32,
    pub attachments: Vec<String>,
    pub attributes: Value,
    pub is_archived: bool,
}

impl View<Vendor> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Vendor>) {
        match &event.payload {
            VendorEvent::VendorAdded {
                id,
                platform_id: _,
                name,
                attributes,
            } => {
                self.id = id.clone();
                self.name = name.clone();
                self.attributes = attributes.clone();
                self.is_archived = false;
            }
            VendorEvent::VendorArchived {} => self.is_archived = true,
            VendorEvent::VendorUnarchived {} => self.is_archived = false,
            VendorEvent::PageAdded {
                page_id,
                name,
                slug,
                order,
                parent_page_id,
            } => self.add_group(
                VendorProductsViewPage::new(page_id.clone(), name.clone(), slug.clone(), *order),
                parent_page_id.clone(),
            ),
            VendorEvent::ProductPaged {
                page_id,
                product_id,
            } => {
                self.group(page_id.clone(), product_id.clone());
            }
        }
    }
}

pub type VendorProductsQuery =
    GenericQuery<ViewRepository<VendorProductsView, Vendor>, VendorProductsView, Vendor>;

impl VendorProductsViewPage {
    pub fn new(id: String, name: String, slug: String, order: u16) -> Self {
        Self {
            id,
            name,
            slug,
            order,
            is_archived: false,
            children: Vec::new(),
            products: Vec::new(),
        }
    }
}

impl HasId for VendorProductsViewPage {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasId for VendorProductsViewProduct {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<VendorProductsViewProduct> for VendorProductsView {
    fn get_items_mut(&mut self) -> &mut Vec<VendorProductsViewProduct> {
        &mut self.unpaged_products
    }
}

impl HasItems<VendorProductsViewProduct> for VendorProductsViewPage {
    fn get_items_mut(&mut self) -> &mut Vec<VendorProductsViewProduct> {
        &mut self.products
    }
}

impl HasNestedGroups<VendorProductsViewPage> for VendorProductsView {
    fn get_groups_mut(&mut self) -> &mut Vec<VendorProductsViewPage> {
        &mut self.pages
    }
}

impl HasNestedGroups<VendorProductsViewPage> for VendorProductsViewPage {
    fn get_groups_mut(&mut self) -> &mut Vec<VendorProductsViewPage> {
        &mut self.children
    }

    fn get_comparator(
    ) -> Option<Box<dyn Fn(&VendorProductsViewPage, &VendorProductsViewPage) -> bool>> {
        Some(Box::new(|new, current| {
            (new.order < current.order) || (new.order == current.order && new.name < current.name)
        }))
    }
}

impl<'a> HasNestedGroupsWithItems<'a, VendorProductsViewPage, VendorProductsViewProduct>
    for VendorProductsView
{
}
