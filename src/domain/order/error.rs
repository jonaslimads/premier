use thiserror::Error;

#[derive(Clone, Debug, Error)]
pub enum OrderError {
    #[error("Product not found")]
    ProductNotFound,

    #[error("Product existent")]
    ProductExistent,

    #[error("Product variant not found")]
    ProductVariantNotFound,

    #[error("Product variant existent")]
    ProductVariantExistent,

    #[error("{0}")]
    Transition(String),
}
