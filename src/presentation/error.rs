use std::string::FromUtf8Error;
use std::sync::Arc;

use cqrs_es::AggregateError;
use thiserror::Error;

use crate::domain::order::error::OrderError;
use crate::domain::platform::error::PlatformError;
use crate::domain::product::error::ProductError;
use crate::domain::vendor::error::VendorError;
use crate::infrastructure::InfrastructureError;

pub type Result<T> = std::result::Result<T, PresentationError>;

#[derive(Clone, Debug, Error)]
pub enum PresentationError {
    #[error("Order error: {0}")]
    Order(Arc<AggregateError<OrderError>>),

    #[error("Platform error: {0}")]
    Platform(Arc<AggregateError<PlatformError>>),

    #[error("Product error: {0}")]
    Product(Arc<AggregateError<ProductError>>),

    #[error("Vendor error: {0}")]
    Vendor(Arc<AggregateError<VendorError>>),

    #[error("Infrastructure: {0}")]
    Infrastructure(InfrastructureError),

    #[error("Config error: {0}")]
    Config(String),

    #[error("Serde Error: {0}")]
    Serde(String),

    #[error("SQL: {0}")]
    Sql(Arc<sqlx::Error>),

    #[error("Conversion error: {0}")]
    FromUtf8(#[from] FromUtf8Error),

    #[error("Empty aggregate id")]
    EmptyAggregateId,

    #[error("Not found aggregate with id {0}")]
    NotFoundAggregate(String),

    #[error("Required {0}")]
    Required(String),

    #[error("Release {0}")]
    Release(String),
}

impl From<AggregateError<OrderError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<OrderError>) -> Self {
        Self::Order(Arc::new(error))
    }
}

impl From<AggregateError<PlatformError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<PlatformError>) -> Self {
        Self::Platform(Arc::new(error))
    }
}

impl From<AggregateError<ProductError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<ProductError>) -> Self {
        Self::Product(Arc::new(error))
    }
}

impl From<AggregateError<VendorError>> for PresentationError {
    #[inline]
    fn from(error: AggregateError<VendorError>) -> Self {
        Self::Vendor(Arc::new(error))
    }
}

impl From<InfrastructureError> for PresentationError {
    #[inline]
    fn from(error: InfrastructureError) -> Self {
        Self::Infrastructure(error)
    }
}

impl From<serde_json::Error> for PresentationError {
    #[inline]
    fn from(error: serde_json::Error) -> Self {
        Self::Serde(error.to_string())
    }
}

impl From<sqlx::Error> for PresentationError {
    #[inline]
    fn from(error: sqlx::Error) -> Self {
        Self::Sql(Arc::new(error))
    }
}

impl async_graphql::ErrorExtensions for PresentationError {
    fn extend(&self) -> async_graphql::Error {
        log::error!("{:?}", self);
        self.extend_with(|err, e| match err {
            // Self::AuthenticationError(_) => e.set("code", "UNAUTHENTICATED"),
            // Self::AuthorizationError(_) => e.set("code", "FORBIDDEN"),
            Self::NotFoundAggregate(_) => e.set("code", "NOT_FOUND"),
            Self::Required(_) => e.set("code", "BAD_REQUEST"),
            // Self::SqlError(_) => e.set("code", "SQL_ERROR"),
            _ => e.set("code", "INTERNAL_SERVER_ERROR"),
        })
    }
}
