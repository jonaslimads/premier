use std::string::FromUtf8Error;
use std::sync::Arc;

use cqrs_es::AggregateError;
use thiserror::Error;

use crate::domain::order::error::OrderError;
use crate::domain::product::error::ProductError;
use crate::domain::vendor::error::VendorError;
use crate::infrastructure::InfrastructureError;

pub type Result<T> = std::result::Result<T, PresentationError>;

#[derive(Clone, Debug, Error)]
pub enum PresentationError {
    #[error("Order error: {0}")]
    OrderError(Arc<AggregateError<OrderError>>),

    #[error("Product error: {0}")]
    ProductError(Arc<AggregateError<ProductError>>),

    #[error("Vendor error: {0}")]
    VendorError(Arc<AggregateError<VendorError>>),

    #[error("Infrastructure: {0}")]
    InfrastructureError(InfrastructureError),

    #[error("Config error: {0}")]
    ConfigError(String),

    #[error("Serde Error: {0}")]
    SerdeError(String),

    #[error("SQL: {0}")]
    SqlError(Arc<sqlx::Error>),

    #[error("Conversion error: {0}")]
    FromUtf8Error(#[from] FromUtf8Error),

    #[error("Empty aggregate id")]
    EmptyAggregateIdError,

    #[error("Not found aggregate with id {0}")]
    NotFoundAggregateError(String),
}

impl From<AggregateError<OrderError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<OrderError>) -> Self {
        Self::OrderError(Arc::new(error))
    }
}

impl From<AggregateError<ProductError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<ProductError>) -> Self {
        Self::ProductError(Arc::new(error))
    }
}

impl From<AggregateError<VendorError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<VendorError>) -> Self {
        Self::VendorError(Arc::new(error))
    }
}

impl From<InfrastructureError> for PresentationError {
    #[inline]
    fn from(error: InfrastructureError) -> Self {
        Self::InfrastructureError(error)
    }
}

impl From<serde_json::Error> for PresentationError {
    #[inline]
    fn from(error: serde_json::Error) -> Self {
        Self::SerdeError(error.to_string())
    }
}

impl From<sqlx::Error> for PresentationError {
    #[inline]
    fn from(error: sqlx::Error) -> Self {
        Self::SqlError(Arc::new(error))
    }
}

impl async_graphql::ErrorExtensions for PresentationError {
    fn extend(&self) -> async_graphql::Error {
        log::error!("{:?}", self);
        self.extend_with(|err, e| match err {
            // Self::AuthenticationError(_) => e.set("code", "UNAUTHENTICATED"),
            // Self::AuthorizationError(_) => e.set("code", "FORBIDDEN"),
            Self::NotFoundAggregateError(_) => e.set("code", "NOT_FOUND"),
            // Self::SqlError(_) => e.set("code", "SQL_ERROR"),
            _ => e.set("code", "INTERNAL_SERVER_ERROR"),
        })
    }
}
