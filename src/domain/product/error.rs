use thiserror::Error;

#[derive(Clone, Debug, Error)]
pub enum ProductError {
    #[error("Variant found")]
    VariantFound,

    #[error("Variant not found")]
    VariantNotFound,

    // #[error("Warehouse found")]
    // WarehouseFoundError,
    // #[error("Warehouse not found")]
    // WarehouseNotFoundError,
    #[error("Warehouse with enough stock not found")]
    WarehouseWithEnoughStockNotFound,

    #[error("Product already has variant with stock from this warehouse")]
    ProductVariantAlreadyHasStockFromWarehouse,

    #[error("Product does not have variant with stock from this warehouse")]
    ProductDoesNotHaveVariantWithStockFromWarehouse,

    #[error("Order has allocated this variant")]
    OrderHasAllocatedVariant,

    #[error("Order has not allocated this variant")]
    OrderHasNotAllocatedVariant,
}
