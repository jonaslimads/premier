use async_graphql::InputObject;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Serialize, Deserialize)]
pub enum OrderCommand {
    AddOrder(AddOrderCommand),
    ArchiveOrder(ArchiveOrderCommand),
    UnarchiveOrder(UnarchiveOrderCommand),
    AddOrderProduct(AddOrderProductCommand),
    AddOrderProductVariant(AddOrderProductVariantCommand),
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddOrderCommand {
    pub id: String,
    pub buyer_id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct ArchiveOrderCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct UnarchiveOrderCommand {
    pub id: String,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddOrderProductCommand {
    pub id: String,
    pub product_id: String,
    pub vendor_id: String,
    pub name: String,
    pub slug: String,
    pub currency: String,
    pub attachment: String,
    pub attributes: Value,
}

#[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
pub struct AddOrderProductVariantCommand {
    pub id: String,
    pub product_id: String,
    pub variant_id: String,
    pub sku: String,
    pub price: u32,
    pub quantity: u32,
    pub attachment: String,
    pub attributes: Value,
}

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct UpdateOrderNameCommand {
//     pub id: String,
//     pub name: String,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct UpdateOrderSlugCommand {
//     pub id: String,
//     pub slug: String,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct UpdateOrderDescriptionCommand {
//     pub id: String,
//     pub description: String,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct UpdateOrderAttachmentsCommand {
//     pub id: String,
//     pub attachments: Vec<String>,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct UpdateOrderAttributesCommand {
//     pub id: String,
//     pub attributes: Value,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct AddOrderVariantCommand {
//     pub id: String,
//     pub variant_id: String,
//     pub sku: String,
//     pub price: u32,
//     pub attachments: Vec<String>,
//     pub attributes: Value,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct AddOrderVariantStockCommand {
//     pub id: String,
//     pub variant_id: String,
//     pub warehouse_id: String,
//     pub quantity: u32,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct RemoveOrderVariantStockCommand {
//     pub id: String,
//     pub variant_id: String,
//     pub warehouse_id: String,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct AllocateOrderStockVariantCommand {
//     pub id: String,
//     pub variant_id: String,
//     pub order_id: String,
//     pub quantity: u32,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct ReallocateOrderStockVariantCommand {
//     pub id: String,
//     pub variant_id: String,
//     pub order_id: String,
//     pub warehouse_id: String,
//     pub quantity: u32,
// }

// #[derive(Clone, Debug, Default, Deserialize, InputObject, PartialEq, Serialize)]
// pub struct DeallocateOrderStockVariantCommand {
//     pub id: String,
//     pub variant_id: String,
//     pub order_id: String,
// }
