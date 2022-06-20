use serde::Deserialize;

use crate::infrastructure::ConnectionPool;
use crate::presentation::{PresentationError, Result};

const DEFAULT_MYSQL_MAX_CONNECTIONS: u32 = 5;

#[derive(Clone, Debug, Deserialize)]
pub struct MySqlConfig {
    pub max_connections: Option<u32>,
    pub url: String,
}

impl MySqlConfig {
    pub async fn into_connection_pool(&self) -> Result<ConnectionPool> {
        #[cfg(feature = "mysql")]
        {
            Ok(crate::infrastructure::start_connection_pool(
                self.url.clone(),
                self.get_max_connections(),
            )
            .await)
        }
        #[cfg(not(feature = "mysql"))]
        {
            Err(PresentationError::Release(
                "does not support MySQL. Try another release.".to_string(),
            ))
        }
    }

    #[allow(dead_code)]
    pub fn get_max_connections(&self) -> u32 {
        self.max_connections
            .unwrap_or(DEFAULT_MYSQL_MAX_CONNECTIONS)
    }
}

impl Default for MySqlConfig {
    fn default() -> Self {
        Self {
            max_connections: Some(DEFAULT_MYSQL_MAX_CONNECTIONS),
            url: "".to_string(),
        }
    }
}
