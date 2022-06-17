use serde::{Deserialize, Serialize};

use crate::commons::{HasId, HasItems, HasNestedGroups};
use crate::domain::vendor::entities::Product;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Group {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub is_archived: bool,
    pub children: Vec<Group>,
    pub products: Vec<Product>,
}

impl Group {
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

impl HasId for Group {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<Product> for Group {
    fn get_items_mut(&mut self) -> &mut Vec<Product> {
        &mut self.products
    }
}

impl HasNestedGroups<Group> for Group {
    fn get_groups_mut(&mut self) -> &mut Vec<Group> {
        &mut self.children
    }
}
