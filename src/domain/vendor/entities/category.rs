use serde::{Deserialize, Serialize};

use crate::domain::vendor::entities::Product;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Category {
    pub id: String,
    pub name: String,
    pub slug: String,
    pub is_archived: bool,
    pub children: Vec<Category>,
    pub products: Vec<Product>,
}
