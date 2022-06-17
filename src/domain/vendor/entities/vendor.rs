use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::commons::{HasId, HasItems, HasNestedGroups, HasNestedGroupsWithItems};
use crate::domain::vendor::entities::{Group, Platform, Product};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Vendor {
    pub id: String,
    pub platform: Platform,
    pub name: String,
    pub slug: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub groups: Vec<Group>,
    pub ungrouped_products: Vec<Product>,
}

impl HasId for Vendor {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<Product> for Vendor {
    fn get_items_mut(&mut self) -> &mut Vec<Product> {
        &mut self.ungrouped_products
    }
}

impl HasNestedGroups<Group> for Vendor {
    fn get_groups_mut(&mut self) -> &mut Vec<Group> {
        &mut self.groups
    }
}

impl<'a> HasNestedGroupsWithItems<'a, Group, Product> for Vendor {}
