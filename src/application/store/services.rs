use async_trait::async_trait;

pub struct StoreServices {
    pub services: Box<dyn StoreApi>,
}

impl StoreServices {
    pub fn new(services: Box<dyn StoreApi>) -> Self {
        Self { services }
    }
}

#[async_trait]
pub trait StoreApi: Send + Sync {
    async fn find_id(&self) -> Result<String, CouldNotFindIdError>;
}

#[derive(Clone, Debug)]
pub struct CouldNotFindIdError;
