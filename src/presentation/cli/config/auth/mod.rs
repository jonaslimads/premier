use std::sync::Arc;

use serde::Deserialize;

pub mod keycloak;

use self::keycloak::AuthKeycloakConfig;
use crate::infrastructure::auth::OidcProvider;

#[derive(Clone, Debug, Default, Deserialize)]
pub struct AuthConfig {
    pub keycloak: Option<AuthKeycloakConfig>,
}

impl AuthConfig {
    pub fn into_keycloak(&self) -> Option<Arc<dyn OidcProvider + Send + Sync>> {
        match &self.keycloak {
            Some(keycloak_config) => Some(keycloak_config.into_provider()),
            None => None,
        }
    }
}
