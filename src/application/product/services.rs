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
    async fn bind_vendor_product(
        &self,
        vendor_id: String,
        product_id: String,
    ) -> Result<(), ApplicationError>;

    async fn get_vendor_id_by_product_id(
        &self,
        product_id: String,
    ) -> Result<String, ApplicationError>;
}

pub mod tests {

    use async_trait::async_trait;

    use crate::application::product::services::ProductLookup;
    use crate::application::ApplicationError;
    pub struct MockProductLookup {
        vendor_id: String,
    }

    impl MockProductLookup {
        pub fn new(vendor_id: String) -> Self {
            Self { vendor_id }
        }
    }

    #[async_trait]
    impl ProductLookup for MockProductLookup {
        async fn bind_vendor_product(
            &self,
            _vendor_id: String,
            _product_id: String,
        ) -> Result<(), ApplicationError> {
            Ok(())
        }

        async fn get_vendor_id_by_product_id(
            &self,
            _product_id: String,
        ) -> Result<String, ApplicationError> {
            Ok(self.vendor_id.clone())
        }
    }
}
