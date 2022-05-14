use serde::Deserialize;

pub mod keycloak;

use self::keycloak::AuthKeycloakConfig;
use crate::presentation::{PresentationError, Result};

#[derive(Clone, Debug, Default, Deserialize)]
pub struct AuthConfig {
    pub keycloak: Option<AuthKeycloakConfig>,
}

impl AuthConfig {
    pub fn get_keycloak_or_error(&self) -> Result<&AuthKeycloakConfig> {
        match &self.keycloak {
            Some(keycloak) => Ok(keycloak),
            None => Err(PresentationError::ConfigError(
                "No Keycloak config set".to_string(),
            )),
        }
    }
}
