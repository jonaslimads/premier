use serde::{Deserialize, Serialize};

use crate::commons::HasId;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Product {
    pub id: String,
}

impl HasId for Product {
    fn id(&self) -> String {
        self.id.clone()
    }
}
