use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use serde::Deserialize;

pub mod auth;
pub mod database;
pub mod graphql;

use crate::presentation::{PresentationError, Result};
use auth::AuthConfig;
use database::DatabaseConfig;
use graphql::GraphqlConfig;

#[derive(Clone, Debug, Deserialize)]
pub struct Config {
    pub graphql: GraphqlConfig,
    pub database: Option<DatabaseConfig>,
    pub auth: Option<AuthConfig>,
}

impl Default for Config {
    fn default() -> Self {
        let config = Self {
            graphql: GraphqlConfig::default(),
            database: Some(DatabaseConfig::default()),
            auth: None,
        };
        log::info!("Started with default {:?}", config);
        config
    }
}

impl Config {
    pub fn get_database_or_error(&self) -> Result<&DatabaseConfig> {
        match &self.database {
            Some(database) => Ok(database),
            None => Err(PresentationError::Config(
                "No Database config set".to_string(),
            )),
        }
    }

    // pub fn get_auth_or_error(&self) -> Result<&AuthConfig> {
    //     match &self.auth {
    //         Some(auth) => Ok(auth),
    //         None => Err(PresentationError::Config("No Auth config set".to_string())),
    //     }
    // }

    pub fn parse(path: Option<String>) -> Self {
        let path = match path {
            Some(path) => path,
            None => return Config::default(),
        };
        let path = Path::new(path.as_str());
        let display = path.display();

        let mut file = match File::open(&path) {
            Err(error) => {
                log::error!("Couldn't open {}: {}", display, error);
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
