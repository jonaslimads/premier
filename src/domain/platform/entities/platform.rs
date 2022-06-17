use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{HasId, HasNestedGroups};
use crate::domain::platform::entities::Category;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]

pub struct Platform {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub categories: Vec<Category>,
}

impl HasId for Platform {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasNestedGroups<Category> for Platform {
    fn get_groups_mut(&mut self) -> &mut Vec<Category> {
        &mut self.categories
    }

    fn find_insertion_position(
        categories: &Vec<Category>,
        new_category: &Category,
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
