use thiserror::Error;

#[derive(Clone, Debug, Error)]
pub enum ProductError {
    #[error("Variant found")]
    VariantFoundError,

    #[error("Variant not found")]
    VariantNotFoundError,

    // #[error("Warehouse found")]
    // WarehouseFoundError,
    // #[error("Warehouse not found")]
    // WarehouseNotFoundError,
    #[error("Warehouse with enough stock not found")]
    WarehouseWithEnoughStockNotFoundError,

    #[error("Product already has variant with stock from this warehouse")]
    ProductVariantAlreadyHasStockFromWarehouseError,

    #[error("Product does not have variant with stock from this warehouse")]
    ProductDoesNotHaveVariantWithStockFromWarehouseError,

    #[error("Order has allocated this variant")]
    OrderHasAllocatedVariantError,

    #[error("Order has not allocated this variant")]
    OrderHasNotAllocatedVariantError,
}
