use std::sync::Arc;

use serde::Deserialize;

use crate::infrastructure::auth::oidc_providers::keycloak::{Keycloak, Signature};

#[derive(Clone, Debug, Default, Deserialize)]
pub struct AuthKeycloakConfig {
    pub url: String,
    pub realm: String,
    pub admin_username: String,
    pub admin_password: String,
    pub signature: AuthKeycloakSignatureConfig,
}

#[derive(Clone, Debug, Default, Deserialize)]
pub struct AuthKeycloakSignatureConfig {
    pub algorithm: String,
    pub modulus: String,
    pub exponent: String,
}

impl AuthKeycloakConfig {
    pub fn into_provider(&self) -> Arc<Keycloak> {
        Keycloak::new(
            self.url.clone(),
            self.realm.clone(),
            self.admin_username.clone(),
            self.admin_password.clone(),
            self.signature.into_signature(),
        )
    }
}

impl AuthKeycloakSignatureConfig {
    fn into_signature(&self) -> Signature {
        Signature::new(
            self.algorithm.clone(),
            self.modulus.clone(),
            self.exponent.clone(),
        )
    }
}
