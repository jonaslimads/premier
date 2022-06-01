use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::product::commands::ProductCommand;
use crate::application::product::services::ProductServices;
use crate::domain::product::entities::{Product, Vendor};
use crate::domain::product::{ProductError, ProductEvent};

#[async_trait]
impl Aggregate for Product {
    type Command = ProductCommand;

    type Event = ProductEvent;

    type Error = ProductError;

    type Services = Arc<ProductServices>;

    fn aggregate_type() -> String {
        "".to_string()
    }

    async fn handle(
        &self,
        command: Self::Command,
        _services: &Self::Services,
    ) -> Result<Vec<Self::Event>, Self::Error> {
        Ok(match command {
            ProductCommand::AddProduct(command) => vec![ProductEvent::ProductAdded {
                id: command.id,
                vendor_id: command.vendor_id,
                name: command.name,
                description: command.description,
                slug: command.slug,
                currency: command.currency,
                attachments: command.attachments,
                attributes: command.attributes,
            }],
            ProductCommand::ArchiveProduct(_) => vec![ProductEvent::ProductArchived {}],
            ProductCommand::UnarchiveProduct(_) => vec![ProductEvent::ProductUnarchived {}],
            ProductCommand::UpdateProductName(command) => {
                vec![ProductEvent::ProductNameUpdated { name: command.name }]
            }
            ProductCommand::UpdateProductSlug(command) => {
                vec![ProductEvent::ProductSlugUpdated { slug: command.slug }]
            }
            ProductCommand::UpdateProductDescription(command) => {
                vec![ProductEvent::ProductDescriptionUpdated {
                    description: command.description,
                }]
            }
            ProductCommand::UpdateProductAttachments(command) => {
                vec![ProductEvent::ProductAttachmentsUpdated {
                    attachments: command.attachments,
                }]
            }
            ProductCommand::UpdateProductAttributes(command) => {
                vec![ProductEvent::ProductAttributesUpdated {
                    attributes: command.attributes,
                }]
            }
            ProductCommand::AddProductVariant(command) => {
                if self.has_variant(command.variant_id.clone()) {
                    Err(ProductError::VariantFound)?
                }
                vec![ProductEvent::ProductVariantAdded {
                    variant_id: command.variant_id,
                    sku: command.sku,
                    price: command.price,
                    attachments: command.attachments,
                    attributes: command.attributes,
                }]
            }
            ProductCommand::AddProductVariantStock(command) => {
                if self.has_variant_with_stock_from_warehouse(
                    command.variant_id.clone(),
                    command.warehouse_id.clone(),
                ) {
                    Err(Self::Error::ProductVariantAlreadyHasStockFromWarehouse)?
                } else {
                    vec![ProductEvent::ProductVariantStockAdded {
                        variant_id: command.variant_id,
                        warehouse_id: command.warehouse_id,
                        quantity: command.quantity,
                    }]
                }
            }
            ProductCommand::RemoveProductVariantStock(command) => {
                if !self.has_variant_with_stock_from_warehouse(
                    command.variant_id.clone(),
                    command.warehouse_id.clone(),
                ) {
                    Err(Self::Error::ProductDoesNotHaveVariantWithStockFromWarehouse)?
                } else {
                    vec![ProductEvent::ProductVariantStockRemoved {
                        variant_id: command.variant_id,
                        warehouse_id: command.warehouse_id,
                    }]
                }
            }
            ProductCommand::AllocateProductStockVariant(command) => {
                let variant = self.get_variant_or_error(command.variant_id.clone())?;
                if variant.has_allocation_by_order_id(command.order_id.clone()) {
                    Err(ProductError::OrderHasAllocatedVariant)?;
                }
                let stock = variant.get_available_stock_or_error(command.quantity)?;
                vec![ProductEvent::ProductVariantStockAllocated {
                    variant_id: command.variant_id,
                    warehouse_id: stock.warehouse.id.to_string(),
                    order_id: command.order_id,
                    quantity: command.quantity,
                }]
            }
            // TODO improve this
            ProductCommand::ReallocateProductStockVariant(command) => {
                let variant = self.get_variant_or_error(command.variant_id.clone())?;
                let previous_allocated_quantity =
                    variant.get_allocated_quantity_by_order_id(command.order_id.clone());
                if previous_allocated_quantity == 0 {
                    Err(ProductError::OrderHasNotAllocatedVariant)?;
                }
                let stock = variant
                    .get_available_stock_or_error(command.quantity - previous_allocated_quantity)?;
                vec![ProductEvent::ProductVariantStockReallocated {
                    variant_id: command.variant_id,
                    warehouse_id: stock.warehouse.id.to_string(),
                    order_id: command.order_id,
                    quantity: command.quantity,
                }]
            }
            ProductCommand::DeallocateProductStockVariant(command) => {
                match self
                    .get_variant_or_error(command.variant_id.clone())?
                    .get_stock_allocation_by_order_id(command.order_id.clone())
                {
                    None => Err(ProductError::OrderHasNotAllocatedVariant)?,
                    Some((stock, _)) => {
                        vec![ProductEvent::ProductVariantStockDeallocated {
                            variant_id: command.variant_id,
                            warehouse_id: stock.warehouse.id.clone(),
                            order_id: command.order_id,
                        }]
                    }
                }
            }
        })
    }

    fn apply(&mut self, event: Self::Event) {
        match event {
            ProductEvent::ProductAdded {
                id,
                vendor_id,
                name,
                description,
                slug,
                currency,
                attachments,
                attributes,
            } => {
                self.id = id;
                self.vendor = Vendor { id: vendor_id };
                self.name = name;
                self.description = description;
                self.slug = slug;
                self.currency = currency;
                self.attachments = attachments;
                self.attributes = attributes;
                self.is_archived = true;
            }
            ProductEvent::ProductArchived {} => self.is_archived = true,
            ProductEvent::ProductUnarchived {} => self.is_archived = false,
            ProductEvent::ProductNameUpdated { name } => self.name = name,
            ProductEvent::ProductSlugUpdated { slug } => self.slug = slug,
            ProductEvent::ProductDescriptionUpdated { description } => {
                self.description = description
            }
            ProductEvent::ProductAttachmentsUpdated { attachments } => {
                self.attachments = attachments
            }
            ProductEvent::ProductAttributesUpdated { attributes } => self.attributes = attributes,
            ProductEvent::ProductVariantAdded {
                variant_id,
                sku,
                price,
                attachments,
                attributes,
            } => self.add_variant(variant_id, sku, price, attachments, attributes),
            ProductEvent::ProductVariantStockAdded {
                variant_id,
                warehouse_id,
                quantity,
            } => self.add_stock(variant_id, warehouse_id, quantity),
            ProductEvent::ProductVariantStockRemoved {
                variant_id,
                warehouse_id,
            } => self.remove_stock(variant_id, warehouse_id),
            ProductEvent::ProductVariantStockAllocated {
                variant_id,
                warehouse_id,
                order_id,
                quantity,
            } => {
                if let Some(variant) = self.get_variant_as_mut_ref(variant_id.clone()) {
                    if let Some(stock) = variant.get_stock_by_warehouse_id_as_mut_ref(warehouse_id)
                    {
                        stock.allocate_quantity(order_id, quantity);
                    }
                }
            }
            ProductEvent::ProductVariantStockReallocated {
                variant_id,
                warehouse_id,
                order_id,
                quantity,
            } => {
                if let Some(variant) = self.get_variant_as_mut_ref(variant_id.clone()) {
                    variant.remove_allocation_by_order_id(order_id.clone());
                    if let Some(stock) = variant.get_stock_by_warehouse_id_as_mut_ref(warehouse_id)
                    {
                        stock.allocate_quantity(order_id, quantity);
                    }
                }
            }
            ProductEvent::ProductVariantStockDeallocated {
                variant_id,
                warehouse_id: _,
                order_id,
            } => {
                if let Some(variant) = self.get_variant_as_mut_ref(variant_id.clone()) {
                    variant.remove_allocation_by_order_id(order_id.clone());
                }
            }
        }
    }
}

#[cfg(test)]
mod aggregate_tests {
    // use std::sync::Mutex;

    // use async_trait::async_trait;
    use cqrs_es::test::TestFramework;
    use serde_json::json;

    use crate::application::product::commands::*;
    use crate::application::product::services::tests::MockProductLookup;
    use crate::application::product::services::ProductServices;
    use crate::domain::product::{Product, ProductEvent};

    type ProductTestFramework = TestFramework<Product>;

    const PRODUCT_ID: &str = "product_id";
    const VARIANT_ID: &str = "variant_id";
    const WAREHOUSE_ID: &str = "warehouse_id";
    const VENDOR_ID: &str = "vendor_id";
    const ORDER_ID: &str = "order_id";
    const CURRENCY: &str = "USD";
    const SKU: &str = "SKU";
    const PRICE: u32 = 100;
    const QUANTITY: u32 = 5;

    #[test]
    fn add_duplicated_variant_is_not_possible() {
        let previous_events = vec![product_added(), product_variant_added()];
        let command = ProductCommand::AddProductVariant(AddProductVariantCommand {
            id: PRODUCT_ID.to_string(),
            variant_id: VARIANT_ID.to_string(),
            sku: SKU.to_string(),
            price: PRICE,
            attachments: vec![],
            attributes: json!({}),
        });

        framework()
            .given(previous_events)
            .when(command)
            .then_expect_error_message("Variant found");
    }

    #[test]
    fn add_variant_stock_after_removing_it() {
        let previous_events = vec![
            product_added(),
            product_variant_added(),
            product_variant_stock_added(),
            product_variant_stock_removed(),
        ];
        let expected = product_variant_stock_added();
        let command = ProductCommand::AddProductVariantStock(AddProductVariantStockCommand {
            id: PRODUCT_ID.to_string(),
            variant_id: VARIANT_ID.to_string(),
            warehouse_id: WAREHOUSE_ID.to_string(),
            quantity: QUANTITY,
        });

        framework()
            .given(previous_events)
            .when(command)
            .then_expect_events(vec![expected]);
    }

    #[test]
    fn add_duplicated_variant_stock_is_not_possible() {
        let previous_events = vec![
            product_added(),
            product_variant_added(),
            product_variant_stock_added(),
        ];
        let command = ProductCommand::AddProductVariantStock(AddProductVariantStockCommand {
            id: PRODUCT_ID.to_string(),
            variant_id: VARIANT_ID.to_string(),
            warehouse_id: WAREHOUSE_ID.to_string(),
            quantity: QUANTITY,
        });

        framework()
            .given(previous_events)
            .when(command)
            .then_expect_error_message(
                "Product already has variant with stock from this warehouse",
            );
    }

    #[test]
    fn allocate_without_enough_stock_is_not_possible() {
        let previous_events = vec![
            product_added(),
            product_variant_added(),
            product_variant_stock_added(),
        ];
        let command =
            ProductCommand::AllocateProductStockVariant(AllocateProductStockVariantCommand {
                id: PRODUCT_ID.to_string(),
                variant_id: VARIANT_ID.to_string(),
                order_id: ORDER_ID.to_string(),
                quantity: 10,
            });

        framework()
            .given(previous_events)
            .when(command)
            .then_expect_error_message("Warehouse with enough stock not found");
    }

    #[test]
    fn reallocate_old_allocation_is_ok_with_enough_stock() {
        let previous_events = vec![
            product_added(),
            product_variant_added(),
            product_variant_stock_added(),
            ProductEvent::ProductVariantStockAllocated {
                variant_id: VARIANT_ID.to_string(),
                warehouse_id: WAREHOUSE_ID.to_string(),
                order_id: ORDER_ID.to_string(),
                quantity: 3,
            },
        ];
        let expected = ProductEvent::ProductVariantStockReallocated {
            variant_id: VARIANT_ID.to_string(),
            warehouse_id: WAREHOUSE_ID.to_string(),
            order_id: ORDER_ID.to_string(),
            quantity: 4,
        };
        let command =
            ProductCommand::ReallocateProductStockVariant(ReallocateProductStockVariantCommand {
                id: PRODUCT_ID.to_string(),
                variant_id: VARIANT_ID.to_string(),
                order_id: ORDER_ID.to_string(),
                warehouse_id: WAREHOUSE_ID.to_string(),
                quantity: 4,
            });

        framework()
            .given(previous_events)
            .when(command)
            .then_expect_events(vec![expected]);
    }

    #[test]
    fn deallocate_inexist_order_is_not_possible() {
        let previous_events = vec![
            product_added(),
            product_variant_added(),
            product_variant_stock_added(),
        ];
        let command =
            ProductCommand::DeallocateProductStockVariant(DeallocateProductStockVariantCommand {
                id: PRODUCT_ID.to_string(),
                variant_id: VARIANT_ID.to_string(),
                order_id: ORDER_ID.to_string(),
            });

        framework()
            .given(previous_events)
            .when(command)
            .then_expect_error_message("Order has not allocated this variant");
    }

    fn product_added() -> ProductEvent {
        ProductEvent::ProductAdded {
            id: PRODUCT_ID.to_string(),
            vendor_id: VENDOR_ID.to_string(),
            name: "".to_string(),
            description: "".to_string(),
            slug: "".to_string(),
            currency: CURRENCY.to_string(),
            attachments: vec![],
            attributes: json!({}),
        }
    }

    fn product_variant_added() -> ProductEvent {
        ProductEvent::ProductVariantAdded {
            variant_id: VARIANT_ID.to_string(),
            sku: SKU.to_string(),
            price: PRICE,
            attachments: vec![],
            attributes: json!({}),
        }
    }

    fn product_variant_stock_added() -> ProductEvent {
        ProductEvent::ProductVariantStockAdded {
            variant_id: VARIANT_ID.to_string(),
            warehouse_id: WAREHOUSE_ID.to_string(),
            quantity: QUANTITY,
        }
    }

    fn product_variant_stock_removed() -> ProductEvent {
        ProductEvent::ProductVariantStockRemoved {
            variant_id: VARIANT_ID.to_string(),
            warehouse_id: WAREHOUSE_ID.to_string(),
        }
    }

    fn framework() -> ProductTestFramework {
        ProductTestFramework::with(ProductServices::new(Box::new(MockProductLookup::new(
            "".to_string(),
        ))))
    }
}
