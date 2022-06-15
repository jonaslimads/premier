use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::entities::{Group, Platform};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Vendor {
    pub id: String,
    pub platform: Platform,
    pub name: String,
    pub slug: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub groups: Vec<Group>,
}

impl Vendor {
    pub fn add_group(&mut self, group: Group, parent_group_id: Option<String>) {
        let groups = &mut self.groups;
        if let Some(parent_id) = parent_group_id {
            if let Some(parent_group) = self.get_group_mut(parent_id) {
                Group::add_group(&mut parent_group.children, group);
            }
        } else {
            Group::add_group(groups, group);
        }
    }

    pub fn group_product(&mut self, group_id: String, product_id: String) {
        if let Some(group) = self.get_group_mut(group_id) {
            group.add_product(product_id);
        }
    }

    fn get_group_mut<'a>(&'a mut self, group_id: String) -> Option<&'a mut Group> {
        Group::get_group_mut(&mut self.groups, group_id)
    }
}
