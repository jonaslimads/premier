use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use mysql_es::MysqlViewRepository;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::events::VendorEvent;
use crate::domain::vendor::Vendor;

use crate::commons::{HasId, HasItems, HasNestedGroups, HasNestedGroupsWithItems};

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub groups: Vec<VendorProductsViewGroup>,
    pub ungrouped_products: Vec<VendorProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsViewGroup {
    pub id: String,
    pub name: String,
    pub slug: String,
    #[graphql(skip)]
    pub order: u16,
    #[graphql(skip)]
    pub is_archived: bool,
    pub children: Vec<VendorProductsViewGroup>,
    pub products: Vec<VendorProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsViewProduct {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub currency: String,
    pub price: u32,
    pub attachments: Vec<String>,
    pub attributes: Value,
    pub is_archived: bool,
}

impl View<Vendor> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Vendor>) {
        match &event.payload {
            VendorEvent::VendorAdded {
                id,
                platform_id: _,
                name,
                attributes,
            } => {
                self.id = id.clone();
                self.name = name.clone();
                self.attributes = attributes.clone();
                self.is_archived = false;
            }
            VendorEvent::VendorArchived {} => self.is_archived = true,
            VendorEvent::VendorUnarchived {} => self.is_archived = false,
            VendorEvent::GroupAdded {
                group_id,
                name,
                slug,
                order,
                parent_group_id,
            } => self.add_group(
                VendorProductsViewGroup::new(group_id.clone(), name.clone(), slug.clone(), *order),
                parent_group_id.clone(),
            ),
            VendorEvent::ProductGrouped {
                group_id,
                product_id,
            } => self.group(group_id.clone(), product_id.clone()),
        }
    }
}

pub type VendorProductsQuery =
    GenericQuery<MysqlViewRepository<VendorProductsView, Vendor>, VendorProductsView, Vendor>;

impl VendorProductsViewGroup {
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

impl HasId for VendorProductsViewGroup {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasId for VendorProductsViewProduct {
    fn id(&self) -> String {
        self.id.clone()
    }
}

impl HasItems<VendorProductsViewProduct> for VendorProductsView {
    fn get_items_mut(&mut self) -> &mut Vec<VendorProductsViewProduct> {
        &mut self.ungrouped_products
    }
}

impl HasItems<VendorProductsViewProduct> for VendorProductsViewGroup {
    fn get_items_mut(&mut self) -> &mut Vec<VendorProductsViewProduct> {
        &mut self.products
    }
}

impl HasNestedGroups<VendorProductsViewGroup> for VendorProductsView {
    fn get_groups_mut(&mut self) -> &mut Vec<VendorProductsViewGroup> {
        &mut self.groups
    }
}

impl HasNestedGroups<VendorProductsViewGroup> for VendorProductsViewGroup {
    fn get_groups_mut(&mut self) -> &mut Vec<VendorProductsViewGroup> {
        &mut self.children
    }

    fn find_insertion_position(
        groups: &Vec<VendorProductsViewGroup>,
        new_group: &VendorProductsViewGroup,
    ) -> Option<usize> {
        let mut position = 0_usize;
        for group in groups {
            if (new_group.order < group.order)
                || (new_group.order == group.order && new_group.name < group.name)
            {
                return Some(position);
            }
            position += 1;
        }
        Some(position)
    }
}

impl<'a> HasNestedGroupsWithItems<'a, VendorProductsViewGroup, VendorProductsViewProduct>
    for VendorProductsView
{
}
