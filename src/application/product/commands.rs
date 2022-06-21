use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::default_platform_id;

#[derive(Debug, Serialize, Deserialize)]
pub enum ProductCommand {
    AddProduct(AddProductCommand),
    ArchiveProduct(ArchiveProductCommand),
    UnarchiveProduct(UnarchiveProductCommand),
    CategorizeProduct(CategorizeProductCommand),
    PageProduct(PageProductCommand),
    UpdateProductName(UpdateProductNameCommand),
    UpdateProductSlug(UpdateProductSlugCommand),
    UpdateProductDescription(UpdateProductDescriptionCommand),
    UpdateProductAttachments(UpdateProductAttachmentsCommand),
    UpdateProductAttributes(UpdateProductAttributesCommand),
    AddProductVariant(AddProductVariantCommand),
    AddProductVariantStock(AddProductVariantStockCommand),
    RemoveProductVariantStock(RemoveProductVariantStockCommand),
    AllocateProductStockVariant(AllocateProductStockVariantCommand),
    ReallocateProductStockVariant(ReallocateProductStockVariantCommand),
    DeallocateProductStockVariant(DeallocateProductStockVariantCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddProductCommand {
    pub id: String,
    #[graphql(default_with = "default_platform_id()")]
    pub platform_id: String,
    pub vendor_id: String,
    pub category_id: Option<String>,
    pub page_id: Option<String>,
    pub name: String,
    pub description: String,
    pub slug: String,
    pub currency: String,
    pub attachments: Vec<String>,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct ArchiveProductCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UnarchiveProductCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct CategorizeProductCommand {
    pub id: String,
    #[graphql(default_with = "default_platform_id()")]
    pub platform_id: String,
    pub category_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct PageProductCommand {
    pub id: String,
    pub vendor_id: String,
    pub page_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdateProductNameCommand {
    pub id: String,
    pub name: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdateProductSlugCommand {
    pub id: String,
    pub slug: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdateProductDescriptionCommand {
    pub id: String,
    pub description: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdateProductAttachmentsCommand {
    pub id: String,
    pub attachments: Vec<String>,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UpdateProductAttributesCommand {
    pub id: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddProductVariantCommand {
    pub id: String,
    pub variant_id: String,
    pub sku: String,
    pub price: u32,
    pub attachments: Vec<String>,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddProductVariantStockCommand {
    pub id: String,
    pub variant_id: String,
    pub warehouse_id: String,
    pub quantity: u32,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct RemoveProductVariantStockCommand {
    pub id: String,
    pub variant_id: String,
    pub warehouse_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AllocateProductStockVariantCommand {
    pub id: String,
    pub variant_id: String,
    pub order_id: String,
    pub quantity: u32,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct ReallocateProductStockVariantCommand {
    pub id: String,
    pub variant_id: String,
    pub order_id: String,
    pub warehouse_id: String,
    pub quantity: u32,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct DeallocateProductStockVariantCommand {
    pub id: String,
    pub variant_id: String,
    pub order_id: String,
}
