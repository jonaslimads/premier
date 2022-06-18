use serde::Deserialize;

pub mod mysql;
pub mod sqlite;

use crate::presentation::{PresentationError, Result};
use mysql::MySqlConfig;
use sqlite::SqliteConfig;

#[derive(Clone, Debug, Default, Deserialize)]
pub struct DatabaseConfig {
    pub mysql: Option<MySqlConfig>,
    pub sqlite: Option<SqliteConfig>,
}

impl DatabaseConfig {
    pub fn get_mysql_or_error(&self) -> Result<&MySqlConfig> {
        match &self.mysql {
            Some(mysql) => Ok(mysql),
            None => Err(PresentationError::Config("No MySQL config set".to_string())),
        }
    }

    pub fn get_sqlite_or_error(&self) -> Result<&SqliteConfig> {
        match &self.sqlite {
            Some(sqlite) => Ok(sqlite),
            None => Err(PresentationError::Config("No SQLite config set".to_string())),
        }
    }
}
