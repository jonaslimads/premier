use thiserror::Error;

#[derive(Clone, Debug, Error)]
pub enum ApplicationError {
    #[error("Not found: {0}")]
    NotFound(String),

    #[error("Database: {0}")]
    Database(String),

    #[error("Authentication: {0}")]
    Authentication(String),

    #[error("Authorization: {0}")]
    Authorization(String),
}
