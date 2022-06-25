use async_trait::async_trait;
use uuid::Uuid;

use crate::application::store::services::{CouldNotFindIdError, StoreApi as StoreApiTrait};

pub struct StoreApi;

#[async_trait]
impl StoreApiTrait for StoreApi {
    // TODO fetch from DB
    async fn find_id(&self) -> Result<String, CouldNotFindIdError> {
        Ok(Uuid::new_v4().to_string())
    }
}
