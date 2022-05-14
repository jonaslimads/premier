use std::sync::Arc;

use jsonwebtoken::errors::Error as JsonWebTokenError;
use thiserror::Error;

pub type Result<T> = std::result::Result<T, InfrastructureError>;

#[derive(Clone, Debug, Error)]
pub enum InfrastructureError {
    #[error("Unauthenticated: {0}")]
    AuthenticationError(Arc<JsonWebTokenError>),

    #[error("Unauthorized: {0}")]
    AuthorizationError(String),

    #[error("Keycloak: {0}")]
    KeycloakError(String),
}

impl From<JsonWebTokenError> for InfrastructureError {
    #[inline]
    fn from(err: JsonWebTokenError) -> Self {
        Self::AuthenticationError(Arc::new(err))
    }
}

impl From<keycloak::KeycloakError> for InfrastructureError {
    #[inline]
    fn from(err: keycloak::KeycloakError) -> Self {
        Self::KeycloakError(err.to_string())
    }
}
