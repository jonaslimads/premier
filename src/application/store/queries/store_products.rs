use async_graphql::SimpleObject;
use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query, View};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::application::store::services::StoreServices;
use crate::application::BaseQuery;
use crate::commons::{
    Filter, HasFilter, HasId, HasItems, HasNestedGroups, HasNestedGroupsWithItems,
};
use crate::domain::store::events::StoreEvent;
use crate::domain::store::Store;
use crate::infrastructure::ViewRepository;

impl View<Store> for StoreProductsView {
    fn update(&mut self, event: &EventEnvelope<Store>) {
        match &event.payload {
            StoreEvent::StoreAdded {
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
            StoreEvent::SellerUpdated { name, attributes } => {
                self.seller = StoreProductsViewSeller {
                    name: name.clone(),
                    attributes: attributes.clone(),
                }
            }
            StoreEvent::StoreArchived {} => self.is_archived = true,
            StoreEvent::StoreUnarchived {} => self.is_archived = false,
            StoreEvent::PageAdded {
                page_id,
                name,
                slug,
                order,
                parent_page_id,
            } => self.add_group(
                StoreProductsViewPage::new(page_id.clone(), name.clone(), slug.clone(), *order),
                parent_page_id.clone(),
            ),
            StoreEvent::ProductPaged {
                page_id,
                product_id,
            } => {
                self.group(page_id.clone(), product_id.clone());
            }
        }
    }
}

pub type StoreProductsQuery =
    BaseQuery<ViewRepository<StoreProductsView, Store>, StoreProductsView, Store, StoreServices>;

#[async_trait]
impl Query<Store> for StoreProductsQuery {
    async fn dispatch(&self, view_id: &str, events: &[EventEnvelope<Store>]) {
        match self.apply_events(view_id, events).await {
            Ok(_) => {}
            Err(err) => self.handle_error(err),
        };
    }
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct StoreProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub seller: StoreProductsViewSeller,
    pub pages: Vec<StoreProductsViewPage>,
    pub unpaged_products: Vec<StoreProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct StoreProductsViewSeller {
    pub name: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct StoreProductsViewPage {
    pub id: String,
    pub name: String,
    pub slug: String,
    #[graphql(skip)]
    pub order: u16,
    #[graphql(skip)]
    pub is_archived: bool,
    pub children: Vec<StoreProductsViewPage>,
    pub products: Vec<StoreProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct StoreProductsViewProduct {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub currency: String,
    pub price: u32,
    pub attachments: Vec<String>,
    pub attributes: Value,
    pub is_archived: bool,
}

impl StoreProductsViewPage {
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

impl HasId for StoreProductsViewPage {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasId for StoreProductsViewProduct {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<StoreProductsViewProduct> for StoreProductsView {
    fn get_items_mut(&mut self) -> &mut Vec<StoreProductsViewProduct> {
        &mut self.unpaged_products
    }
}

impl HasItems<StoreProductsViewProduct> for StoreProductsViewPage {
    fn get_items_mut(&mut self) -> &mut Vec<StoreProductsViewProduct> {
        &mut self.products
    }
}

impl HasNestedGroups<StoreProductsViewPage> for StoreProductsView {
    fn get_groups_mut(&mut self) -> &mut Vec<StoreProductsViewPage> {
        &mut self.pages
    }
}

impl HasNestedGroups<StoreProductsViewPage> for StoreProductsViewPage {
    fn get_groups_mut(&mut self) -> &mut Vec<StoreProductsViewPage> {
        &mut self.children
    }

    fn get_comparator(
    ) -> Option<Box<dyn Fn(&StoreProductsViewPage, &StoreProductsViewPage) -> bool>> {
        Some(Box::new(|new, current| {
            (new.order < current.order) || (new.order == current.order && new.name < current.name)
        }))
    }
}

impl<'a> HasNestedGroupsWithItems<'a, StoreProductsViewPage, StoreProductsViewProduct>
    for StoreProductsView
{
}

impl HasFilter for StoreProductsView {
    fn predicate(filter: &Filter) -> Box<dyn FnMut(&Self) -> bool> {
        if let Some(search) = Self::get_opt_string_from_filter(filter, "q") {
            return Box::new(move |e| {
                Self::contains(&e.name, &search)
                    || Self::contains(&e.seller.name, &search)
                    || Self::json_contains(&e.seller.attributes, "email", &search)
            });
        }
        Box::new(|_| true)
    }
}
