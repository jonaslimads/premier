use serde::Deserialize;

use crate::infrastructure::ConnectionPool;
use crate::presentation::Result;

const DEFAULT_SQLITE_MAX_CONNECTIONS: u32 = 5;

#[derive(Clone, Debug, Deserialize)]
pub struct SqliteConfig {
    pub max_connections: Option<u32>,
    pub url: String,
}

impl SqliteConfig {
    pub async fn into_connection_pool(&self) -> Result<ConnectionPool> {
        #[cfg(feature = "sqlite")]
        {
            Ok(crate::infrastructure::start_connection_pool(
                self.url.clone(),
                self.get_max_connections(),
            )
            .await)
        }
        #[cfg(not(feature = "sqlite"))]
        {
            Err(PresentationError::Release(
                "does not support SQLite. Try another release.".to_string(),
            ))
        }
    }

    #[allow(dead_code)]
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
