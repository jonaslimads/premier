use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::entities::Category;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Vendor {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub categories: Vec<Category>,
}

impl Vendor {
    pub fn add_category(&mut self, category: Category, parent_category_id: Option<String>) {
        let categories = &mut self.categories;
        if let Some(parent_id) = parent_category_id {
            if let Some(parent_category) = self.get_category_mut(parent_id) {
                Category::add_category(&mut parent_category.children, category);
            }
        } else {
            Category::add_category(categories, category);
        }
    }

    pub fn categorize_product(&mut self, category_id: String, product_id: String) {
        if let Some(category) = self.get_category_mut(category_id) {
            category.add_product(product_id);
        }
    }

    fn get_category_mut<'a>(&'a mut self, category_id: String) -> Option<&'a mut Category> {
        Category::get_category_mut(&mut self.categories, category_id)
    }
}
