use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use mysql_es::MysqlViewRepository;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::events::VendorEvent;
use crate::domain::vendor::Vendor;

#[derive(Clone, Debug, Default, Deserialize, Serialize, SimpleObject)]
pub struct VendorProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub groups: Vec<VendorProductsViewGroup>,
    pub ungroupd_products: Vec<VendorProductsViewProduct>,
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
                platform_id,
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
            } => self.group_product(group_id.clone(), product_id.clone()),
        }
    }
}

pub type VendorProductsQuery =
    GenericQuery<MysqlViewRepository<VendorProductsView, Vendor>, VendorProductsView, Vendor>;

impl VendorProductsView {
    pub fn get_all_products(&mut self) -> Vec<VendorProductsViewProduct> {
        let groups = &mut self.groups;
        let mut all_products = VendorProductsViewGroup::get_products(groups);
        all_products.append(&mut self.ungroupd_products);
        all_products
    }

    pub fn add_group(&mut self, group: VendorProductsViewGroup, parent_group_id: Option<String>) {
        let groups = &mut self.groups;
        if let Some(parent_id) = parent_group_id {
            if let Some(parent_group) =
                VendorProductsViewGroup::get_group_mut(&mut self.groups, parent_id)
            {
                VendorProductsViewGroup::add_group(&mut parent_group.children, group);
            }
        } else {
            VendorProductsViewGroup::add_group(groups, group);
        }
    }

    pub fn group_product(&mut self, group_id: String, product_id: String) {
        if let Some(product) = self.remove_product(product_id) {
            if let Some(group) = VendorProductsViewGroup::get_group_mut(&mut self.groups, group_id)
            {
                group.add_product(product);
            }
        }
    }

    pub fn remove_product(&mut self, product_id: String) -> Option<VendorProductsViewProduct> {
        if let Some(product) = VendorProductsViewProduct::remove_product(
            &mut self.ungroupd_products,
            product_id.clone(),
        ) {
            return Some(product);
        }
        for group in &mut self.groups {
            if let Some(product) = group.remove_product(product_id.clone()) {
                return Some(product);
            }
        }
        None
    }

    pub fn get_product_mut(
        &mut self,
        product_id: String,
    ) -> Option<&mut VendorProductsViewProduct> {
        if let Some(product) = VendorProductsViewProduct::get_product_mut(
            &mut self.ungroupd_products,
            product_id.clone(),
        ) {
            return Some(product);
        }
        for group in &mut self.groups {
            if let Some(product) = group.get_product_mut(product_id.clone()) {
                return Some(product);
            }
        }
        None
    }
}

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

    pub fn get_products(groups: &mut Vec<Self>) -> Vec<VendorProductsViewProduct> {
        let mut products: Vec<VendorProductsViewProduct> = Vec::new();
        for group in groups {
            products.append(&mut group.products);
            let mut children_products = Self::get_products(&mut group.children);
            products.append(&mut children_products);
        }
        products
    }

    pub fn add_group(groups: &mut Vec<Self>, group: Self) {
        groups.insert(Self::get_insertion_position(&groups, &group), group)
    }

    pub fn add_product(&mut self, product: VendorProductsViewProduct) {
        self.products.push(product);
    }

    pub fn remove_product(&mut self, product_id: String) -> Option<VendorProductsViewProduct> {
        if let Some(product) =
            VendorProductsViewProduct::remove_product(&mut self.products, product_id.clone())
        {
            return Some(product);
        }
        for group in &mut self.children {
            if let Some(product) = group.remove_product(product_id.clone()) {
                return Some(product);
            }
        }
        None
    }

    fn get_product_mut(&mut self, product_id: String) -> Option<&mut VendorProductsViewProduct> {
        if let Some(product) =
            VendorProductsViewProduct::get_product_mut(&mut self.products, product_id.clone())
        {
            return Some(product);
        }
        for group in &mut self.children {
            if let Some(product) = group.get_product_mut(product_id.clone()) {
                return Some(product);
            }
        }
        None
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
}

impl VendorProductsViewProduct {
    pub fn remove_product(products: &mut Vec<Self>, product_id: String) -> Option<Self> {
        let mut i = 0;
        while i < products.len() {
            if products[i].id == product_id {
                return Some(products.remove(i));
            } else {
                i += 1;
            }
        }
        None
    }

    pub fn get_product_mut(
        products: &mut Vec<VendorProductsViewProduct>,
        product_id: String,
    ) -> Option<&mut VendorProductsViewProduct> {
        for product in products {
            if product_id == product_id {
                return Some(product);
            }
        }
        None
    }
}
