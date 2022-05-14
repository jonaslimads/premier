use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use serde::Deserialize;

pub mod auth;
pub mod database;

use crate::presentation::{PresentationError, Result};
use auth::AuthConfig;
use database::DatabaseConfig;

const DEFAULT_PORT: u16 = 10001;
const DEFAULT_DATABASE_URI: &str = "sqlite://database.db";

#[derive(Clone, Debug, Deserialize)]
pub struct Config {
    pub port: Option<u16>,
    pub database: Option<DatabaseConfig>,
    pub auth: Option<AuthConfig>,
}

impl Config {
    pub fn get_port(&self) -> u16 {
        self.port.unwrap_or(DEFAULT_PORT)
    }

    pub fn get_database_or_error(&self) -> Result<&DatabaseConfig> {
        match &self.database {
            Some(database) => Ok(database),
            None => Err(PresentationError::ConfigError(
                "No Database config set".to_string(),
            )),
        }
    }

    pub fn get_auth_or_error(&self) -> Result<&AuthConfig> {
        match &self.auth {
            Some(auth) => Ok(auth),
            None => Err(PresentationError::ConfigError(
                "No Auth config set".to_string(),
            )),
        }
    }

    // pub async fn into_connection_pool(&self) -> ConnectionPool {
    //     let mysql = match self.mysql.clone() {
    //         Some(mysql) => mysql,
    //         None => MySqlConfig::default(),
    //     };
    //     start_connection_pool(mysql.url.as_str(), mysql.get_max_connections()).await
    // }

    pub fn parse(path: String) -> Self {
        let path = Path::new(path.as_str());
        let display = path.display();

        let mut file = match File::open(&path) {
            Err(error) => {
                println!(
                    "Couldn't open {}: {}\n\nStarting with default connection {}...",
                    display, error, DEFAULT_DATABASE_URI
                );
                return Config::default();
            }
            Ok(file) => file,
        };

        let mut file_content = String::new();
        match file.read_to_string(&mut file_content) {
            Err(error) => panic!("Couldn't read {}: {}", display, error),
            Ok(_) => {}
        }

        toml::from_str(file_content.as_str()).unwrap()
    }
}

impl Default for Config {
    fn default() -> Self {
        Self {
            port: Some(DEFAULT_PORT),
            database: None,
            auth: None,
        }
    }
}
