use std::sync::Arc;

use jsonwebtoken::errors::Error as JsonWebTokenError;
use thiserror::Error;

use crate::application::ApplicationError;

pub type Result<T> = std::result::Result<T, InfrastructureError>;

#[derive(Clone, Debug, Error)]
pub enum InfrastructureError {
    #[error("Not found: {0}")]
    NotFound(String),

    #[error("Unauthenticated: {0}")]
    Authentication(Arc<JsonWebTokenError>),

    #[error("Unauthorized: {0}")]
    Authorization(String),

    #[error("Keycloak: {0}")]
    KeycloakError(String),

    #[error("SQL: {0}")]
    Sql(Arc<sqlx::Error>),
}

impl From<JsonWebTokenError> for InfrastructureError {
    #[inline]
    fn from(err: JsonWebTokenError) -> Self {
        Self::Authentication(Arc::new(err))
    }
}

impl From<keycloak::KeycloakError> for InfrastructureError {
    #[inline]
    fn from(err: keycloak::KeycloakError) -> Self {
        Self::KeycloakError(err.to_string())
    }
}

impl From<sqlx::Error> for InfrastructureError {
    #[inline]
    fn from(error: sqlx::Error) -> Self {
        match error {
            sqlx::Error::RowNotFound => InfrastructureError::NotFound("".to_string()),
            error => Self::Sql(Arc::new(error)),
        }
    }
}

impl From<InfrastructureError> for ApplicationError {
    #[inline]
    fn from(error: InfrastructureError) -> Self {
        match error {
            InfrastructureError::NotFound(error) => ApplicationError::NotFound(error),
            InfrastructureError::Authentication(error) => {
                ApplicationError::Authentication(error.to_string())
            }
            InfrastructureError::Authorization(error) => ApplicationError::Authorization(error),
            InfrastructureError::KeycloakError(error) => ApplicationError::Authentication(error),
            InfrastructureError::Sql(error) => ApplicationError::Database(error.to_string()),
        }
    }
}
