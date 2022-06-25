use std::sync::Arc;

use async_trait::async_trait;

use crate::application::ApplicationError;

pub struct ProductServices {
    pub lookup: Box<dyn ProductLookup>,
}

impl ProductServices {
    pub fn new(lookup: Box<dyn ProductLookup>) -> Arc<Self> {
        Arc::new(Self { lookup })
    }
}

#[async_trait]
pub trait ProductLookup: Send + Sync {
    async fn bind_store_product(
        &self,
        store_id: String,
        product_id: String,
    ) -> Result<(), ApplicationError>;

    async fn get_store_id_by_product_id(
        &self,
        product_id: String,
    ) -> Result<String, ApplicationError>;
}

pub mod tests {

    use async_trait::async_trait;

    use crate::application::product::services::ProductLookup;
    use crate::application::ApplicationError;
    pub struct MockProductLookup {
        store_id: String,
    }

    impl MockProductLookup {
        pub fn new(store_id: String) -> Self {
            Self { store_id }
        }
    }

    #[async_trait]
    impl ProductLookup for MockProductLookup {
        async fn bind_store_product(
            &self,
            _store_id: String,
            _product_id: String,
        ) -> Result<(), ApplicationError> {
            Ok(())
        }

        async fn get_store_id_by_product_id(
            &self,
            _product_id: String,
        ) -> Result<String, ApplicationError> {
            Ok(self.store_id.clone())
        }
    }
}
