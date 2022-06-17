use serde::{Deserialize, Serialize};

use crate::commons::{HasId, HasNestedGroups};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Category {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub is_archived: bool,
    pub children: Vec<Category>,
}

impl Category {
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

impl HasId for Category {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasNestedGroups<Category> for Category {
    fn get_groups_mut(&mut self) -> &mut Vec<Category> {
        &mut self.children
    }
}
