use async_trait::async_trait;

pub struct VendorServices {
    pub services: Box<dyn VendorApi>,
}

impl VendorServices {
    pub fn new(services: Box<dyn VendorApi>) -> Self {
        Self { services }
    }
}

#[async_trait]
pub trait VendorApi: Sync + Send {
    async fn find_id(&self) -> Result<String, CouldNotFindIdError>;
}

#[derive(Clone, Debug)]
pub struct CouldNotFindIdError;
