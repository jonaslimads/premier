use serde::Deserialize;

pub mod mysql;
pub mod sqlite;

use crate::infrastructure::ConnectionPool;
use crate::presentation::{PresentationError, Result};
use mysql::MySqlConfig;
use sqlite::SqliteConfig;

#[derive(Clone, Debug, Default, Deserialize)]
pub struct DatabaseConfig {
    pub mysql: Option<MySqlConfig>,
    pub sqlite: Option<SqliteConfig>,
}

impl DatabaseConfig {
    pub async fn into_connection_pool(&self) -> Result<ConnectionPool> {
        if let Some(mysql) = &self.mysql {
            mysql.into_connection_pool().await
        } else if let Some(sqlite) = &self.sqlite {
            sqlite.into_connection_pool().await
        } else {
            Err(PresentationError::Config(
                "No database config set".to_string(),
            ))
        }
    }
}
