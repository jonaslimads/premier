use serde::{Deserialize, Serialize};

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

    pub fn get_group_mut<'a>(groups: &'a mut Vec<Self>, group_id: String) -> Option<&'a mut Self> {
        for group in groups {
            if group.id == group_id.clone() {
                return Some(group);
            }
            if let Some(child_group) = Self::get_group_mut(&mut group.children, group_id.clone()) {
                return Some(child_group);
            }
        }
        None
    }

    pub fn add_group(groups: &mut Vec<Self>, group: Self) {
        groups.insert(Self::get_insertion_position(&groups, &group), group)
    }

    fn get_insertion_position(groups: &Vec<Self>, new_group: &Self) -> usize {
        let mut i = 0_usize;
        for group in groups {
            if (new_group.order < group.order)
                || (new_group.order == group.order && new_group.name < group.name)
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
