use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{HasId, HasNestedGroups};
use crate::domain::platform::events::PlatformEvent;
use crate::domain::platform::Platform;
use crate::infrastructure::ViewRepository;

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub categories: Vec<PlatformViewCategory>,
    pub campaigns: Vec<PlatformViewCampaign>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewCategory {
    pub id: String,
    pub name: String,
    pub slug: String,
    #[graphql(skip)]
    pub order: u16,
    #[graphql(skip)]
    pub is_archived: bool,
    pub children: Vec<PlatformViewCategory>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct PlatformViewCampaign {
    pub id: String,
}

impl View<Platform> for PlatformView {
    fn update(&mut self, event: &EventEnvelope<Platform>) {
        match &event.payload {
            PlatformEvent::PlatformAdded {
                id,
                name,
                attributes,
            } => {
                self.id = id.clone();
                self.name = name.clone();
                self.attributes = attributes.clone();
            }
            PlatformEvent::CategoryAdded {
                category_id,
                name,
                slug,
                order,
                parent_category_id,
            } => self.add_group(
                PlatformViewCategory::new(
                    category_id.clone(),
                    name.clone(),
                    slug.clone(),
                    order.clone(),
                ),
                parent_category_id.clone(),
            ),
            PlatformEvent::ProductCategorized {
                category_id: _,
                product_id: _,
            } => {
                // self.group_product(group_id, product_id)
            }
            PlatformEvent::PlatformNameUpdated { name } => self.name = name.clone(),
            PlatformEvent::PlatformAttributesUpdated { attributes } => {
                self.attributes = attributes.clone()
            }
        }
    }
}

pub type PlatformQuery =
    GenericQuery<ViewRepository<PlatformView, Platform>, PlatformView, Platform>;

impl PlatformViewCategory {
    pub fn new(id: String, name: String, slug: String, order: u16) -> Self {
        Self {
            id,
            name,
            slug,
            order,
            is_archived: false,
            children: Vec::new(),
        }
    }
}

impl HasId for PlatformView {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasId for PlatformViewCategory {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasNestedGroups<PlatformViewCategory> for PlatformView {
    fn get_groups_mut(&mut self) -> &mut Vec<PlatformViewCategory> {
        &mut self.categories
    }

    fn find_insertion_position(
        categories: &Vec<PlatformViewCategory>,
        new_category: &PlatformViewCategory,
    ) -> Option<usize> {
        let mut position = 0_usize;
        for category in categories {
            if (new_category.order < category.order)
                || (new_category.order == category.order && new_category.name < category.name)
            {
                return Some(position);
            }
            position += 1;
        }
        Some(position)
    }
}

impl HasNestedGroups<PlatformViewCategory> for PlatformViewCategory {
    fn get_groups_mut(&mut self) -> &mut Vec<PlatformViewCategory> {
        &mut self.children
    }
}
