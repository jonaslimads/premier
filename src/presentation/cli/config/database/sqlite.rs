use crate::infrastructure::{start_connection_pool, ConnectionPool};
use serde::Deserialize;

const DEFAULT_SQLITE_MAX_CONNECTIONS: u32 = 5;

#[derive(Clone, Debug, Deserialize)]
pub struct SqliteConfig {
    pub max_connections: Option<u32>,
    pub url: String,
}

impl SqliteConfig {
    pub async fn into_connection_pool(&self) -> ConnectionPool {
        start_connection_pool(self.url.as_str(), self.get_max_connections()).await
    }

    pub fn get_max_connections(&self) -> u32 {
        self.max_connections
            .unwrap_or(DEFAULT_SQLITE_MAX_CONNECTIONS)
    }
}

impl Default for SqliteConfig {
    fn default() -> Self {
        Self {
            max_connections: Some(DEFAULT_SQLITE_MAX_CONNECTIONS),
            url: "".to_string(),
        }
    }
}
