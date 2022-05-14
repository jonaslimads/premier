// use async_trait::async_trait;

pub struct ProductServices {
    // pub services: Box<dyn VendorApi>,
}

impl ProductServices {
    pub fn new() -> Self {
        Self {}
    }
}

// #[async_trait]
// pub trait ProductServices: Sync + Send {
//     // async fn find_id(&self) -> Result<String, CouldNotFindIdError>;
// }

// pub struct CouldNotFindIdError;
