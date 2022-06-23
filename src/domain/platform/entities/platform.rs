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

    fn get_comparator() -> Option<Box<dyn Fn(&Category, &Category) -> bool>> {
        Some(Box::new(|new, current| {
            (new.order < current.order) || (new.order == current.order && new.name < current.name)
        }))
    }
}
