use std::sync::Arc;

use serde::Deserialize;

use crate::infrastructure::auth::oidc_providers::keycloak::{Certificate, Keycloak};

#[derive(Clone, Debug, Default, Deserialize)]
pub struct AuthKeycloakConfig {
    pub url: String,
    pub realm: String,
    pub admin_username: String,
    pub admin_password: String,
    pub certificate: AuthKeycloakCertificateConfig,
}

#[derive(Clone, Debug, Default, Deserialize)]
pub struct AuthKeycloakCertificateConfig {
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
            self.certificate.into_certificate(),
        )
    }
}

impl AuthKeycloakCertificateConfig {
    fn into_certificate(&self) -> Certificate {
        Certificate::new(
            self.algorithm.clone(),
            self.modulus.clone(),
            self.exponent.clone(),
        )
    }
}
