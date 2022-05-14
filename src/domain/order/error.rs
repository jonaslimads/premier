use thiserror::Error;

#[derive(Clone, Debug, Error)]
pub enum OrderError {
    #[error("Product not found")]
    ProductNotFoundError,

    #[error("Product existent")]
    ProductExistentError,

    #[error("Product variant not found")]
    ProductVariantNotFoundError,

    #[error("Product variant existent")]
    ProductVariantExistentError,

    #[error("{0}")]
    TransitionError(String),
}
