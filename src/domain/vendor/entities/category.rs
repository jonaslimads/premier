use serde::{Deserialize, Serialize};

use crate::domain::vendor::entities::Product;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Category {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub order: u16,
    pub is_archived: bool,
    pub children: Vec<Category>,
    pub products: Vec<Product>,
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
            products: Vec::new(),
        }
    }

    pub fn get_category_mut<'a>(
        categories: &'a mut Vec<Self>,
        category_id: String,
    ) -> Option<&'a mut Self> {
        for category in categories {
            if category.id == category_id.clone() {
                return Some(category);
            }
            if let Some(child_category) =
                Self::get_category_mut(&mut category.children, category_id.clone())
            {
                return Some(child_category);
            }
        }
        None
    }

    pub fn add_category(categories: &mut Vec<Self>, category: Self) {
        categories.insert(
            Self::get_insertion_position(&categories, &category),
            category,
        )
    }

    fn get_insertion_position(categories: &Vec<Self>, new_category: &Self) -> usize {
        let mut i = 0_usize;
        for category in categories {
            if (new_category.order < category.order)
                || (new_category.order == category.order && new_category.name < category.name)
            {
                return i;
            }
            i += 1;
        }
        i
    }

    pub fn add_product(&mut self, product_id: String) {
        self.products.push(Product { id: product_id })
    }
}
