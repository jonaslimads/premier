use serde::{Deserialize, Serialize};

use crate::commons::{HasId, HasItems, HasNestedGroups};
use crate::domain::store::entities::Product;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Page {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub is_published: bool,
    pub children: Vec<Page>,
    pub products: Vec<Product>,
}

impl Page {
    pub fn new(id: String, name: String, slug: String, order: u16) -> Self {
        Self {
            id,
            name,
            slug,
            order,
            is_published: false,
            children: Vec::new(),
            products: Vec::new(),
        }
    }
}

impl HasId for Page {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<Product> for Page {
    fn get_items_mut(&mut self) -> &mut Vec<Product> {
        &mut self.products
    }
}

impl HasNestedGroups<Page> for Page {
    fn get_groups_mut(&mut self) -> &mut Vec<Page> {
        &mut self.children
    }
}
