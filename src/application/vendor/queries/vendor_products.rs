use async_graphql::SimpleObject;
use cqrs_es::persist::GenericQuery;
use cqrs_es::{EventEnvelope, View};
use mysql_es::MysqlViewRepository;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::vendor::events::VendorEvent;
use crate::domain::vendor::Vendor;

#[derive(Clone, Debug, Default, Serialize, Deserialize, SimpleObject)]
pub struct VendorProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub categories: Vec<VendorProductsViewCategory>,
    pub uncategorized_products: Vec<VendorProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Serialize, Deserialize, SimpleObject)]
pub struct VendorProductsViewCategory {
    pub id: String,
    pub name: String,
    pub slug: String,
    #[graphql(skip)]
    pub order: u16,
    #[graphql(skip)]
    pub is_archived: bool,
    pub children: Vec<VendorProductsViewCategory>,
    pub products: Vec<VendorProductsViewProduct>,
}

#[derive(Clone, Debug, Default, Serialize, Deserialize, SimpleObject)]
pub struct VendorProductsViewProduct {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub currency: String,
    pub price: u32,
    pub is_archived: bool,
}

impl View<Vendor> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Vendor>) {
        match &event.payload {
            VendorEvent::VendorAdded {
                id,
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
            VendorEvent::CategoryAdded {
                category_id,
                name,
                slug,
                order,
                parent_category_id,
            } => self.add_category(
                VendorProductsViewCategory::new(
                    category_id.clone(),
                    name.clone(),
                    slug.clone(),
                    *order,
                ),
                parent_category_id.clone(),
            ),
            VendorEvent::ProductCategorized {
                category_id,
                product_id,
            } => self.categorize_product(category_id.clone(), product_id.clone()),
        }
    }
}

pub type VendorProductsQuery =
    GenericQuery<MysqlViewRepository<VendorProductsView, Vendor>, VendorProductsView, Vendor>;

impl VendorProductsView {
    pub fn add_category(
        &mut self,
        category: VendorProductsViewCategory,
        parent_category_id: Option<String>,
    ) {
        let categories = &mut self.categories;
        if let Some(parent_id) = parent_category_id {
            if let Some(parent_category) =
                VendorProductsViewCategory::get_category_mut(&mut self.categories, parent_id)
            {
                VendorProductsViewCategory::add_category(&mut parent_category.children, category);
            }
        } else {
            VendorProductsViewCategory::add_category(categories, category);
        }
    }

    pub fn categorize_product(&mut self, category_id: String, product_id: String) {
        if let Some(product) = self.remove_product(product_id) {
            if let Some(category) =
                VendorProductsViewCategory::get_category_mut(&mut self.categories, category_id)
            {
                category.add_product(product);
            }
        }
    }

    pub fn remove_product(&mut self, product_id: String) -> Option<VendorProductsViewProduct> {
        if let Some(product) = VendorProductsViewProduct::remove_product(
            &mut self.uncategorized_products,
            product_id.clone(),
        ) {
            return Some(product);
        }
        for category in &mut self.categories {
            if let Some(product) = category.remove_product(product_id.clone()) {
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
            &mut self.uncategorized_products,
            product_id.clone(),
        ) {
            return Some(product);
        }
        for category in &mut self.categories {
            if let Some(product) = category.get_product_mut(product_id.clone()) {
                return Some(product);
            }
        }
        None
    }
}

impl VendorProductsViewCategory {
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

    pub fn add_product(&mut self, product: VendorProductsViewProduct) {
        self.products.push(product);
    }

    pub fn remove_product(&mut self, product_id: String) -> Option<VendorProductsViewProduct> {
        if let Some(product) =
            VendorProductsViewProduct::remove_product(&mut self.products, product_id.clone())
        {
            return Some(product);
        }
        for category in &mut self.children {
            if let Some(product) = category.remove_product(product_id.clone()) {
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
        for category in &mut self.children {
            if let Some(product) = category.get_product_mut(product_id.clone()) {
                return Some(product);
            }
        }
        None
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
