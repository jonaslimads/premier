use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{HasId, HasItems, HasNestedGroups, HasNestedGroupsWithItems};
use crate::domain::vendor::entities::{Page, Platform, Product};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Vendor {
    pub id: String,
    pub platform: Platform,
    pub name: String,
    pub slug: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub pages: Vec<Page>,
    pub unpaged_products: Vec<Product>,
}

impl HasId for Vendor {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<Product> for Vendor {
    fn get_items_mut(&mut self) -> &mut Vec<Product> {
        &mut self.unpaged_products
    }
}

impl HasNestedGroups<Page> for Vendor {
    fn get_groups_mut(&mut self) -> &mut Vec<Page> {
        &mut self.pages
    }

    fn find_insertion_position(pages: &Vec<Page>, new_page: &Page) -> Option<usize> {
        let mut position = 0_usize;
        for page in pages {
            if (new_page.order < page.order)
                || (new_page.order == page.order && new_page.name < page.name)
            {
                return Some(position);
            }
            position += 1;
        }
        Some(position)
    }
}

impl<'a> HasNestedGroupsWithItems<'a, Page, Product> for Vendor {}
