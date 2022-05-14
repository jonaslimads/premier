use async_trait::async_trait;
use uuid::Uuid;

use crate::application::vendor::services::{CouldNotFindIdError, VendorApi as VendorApiTrait};

pub struct VendorApi;

#[async_trait]
impl VendorApiTrait for VendorApi {
    // TODO fetch from DB
    async fn find_id(&self) -> Result<String, CouldNotFindIdError> {
        Ok(Uuid::new_v4().to_string())
    }
}
