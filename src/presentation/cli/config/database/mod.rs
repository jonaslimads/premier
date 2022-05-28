use serde::Deserialize;

pub mod mysql;

use crate::presentation::{PresentationError, Result};
use mysql::MySqlConfig;

#[derive(Clone, Debug, Default, Deserialize)]
pub struct DatabaseConfig {
    pub mysql: Option<MySqlConfig>,
}

impl DatabaseConfig {
    pub fn get_mysql_or_error(&self) -> Result<&MySqlConfig> {
        match &self.mysql {
            Some(mysql) => Ok(mysql),
            None => Err(PresentationError::Config("No MySql config set".to_string())),
        }
    }
}
