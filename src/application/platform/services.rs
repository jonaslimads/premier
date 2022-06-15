use std::sync::Arc;

use async_trait::async_trait;

use crate::application::ApplicationError;

pub struct PlatformServices {}

impl PlatformServices {
    pub fn new() -> Arc<Self> {
        Arc::new(Self {})
    }
}
