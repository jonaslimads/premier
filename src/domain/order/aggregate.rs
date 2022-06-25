use async_trait::async_trait;
use cqrs_es::Aggregate;

use crate::application::order::commands::OrderCommand;
use crate::application::order::services::OrderServices;
use crate::domain::order::{OrderError, OrderEvent};

use crate::domain::order::entities::{Buyer, Order};

#[async_trait]
impl Aggregate for Order {
    type Command = OrderCommand;

    type Event = OrderEvent;

    type Error = OrderError;

    type Services = OrderServices;

    fn aggregate_type() -> String {
        "".to_string()
    }

    async fn handle(
        &self,
        command: Self::Command,
        _services: &Self::Services,
    ) -> Result<Vec<Self::Event>, Self::Error> {
        Ok(match command {
            OrderCommand::AddOrder(command) => vec![OrderEvent::OrderAdded {
                id: command.id,
                buyer_id: command.buyer_id,
            }],
            OrderCommand::ArchiveOrder(_) => vec![OrderEvent::OrderArchived {}],
            OrderCommand::UnarchiveOrder(_) => vec![OrderEvent::OrderUnarchived {}],
            OrderCommand::AddOrderProduct(command) => {
                if self.get_product(command.product_id.clone()).is_some() {
                    Err(OrderError::ProductExistent)?;
                }
                vec![OrderEvent::OrderProductAdded {
                    product_id: command.product_id,
                    store_id: command.store_id,
                    name: command.name,
                    slug: command.slug,
                    currency: command.currency,
                    attachment: command.attachment,
                    attributes: command.attributes,
                }]
            }
            OrderCommand::AddOrderProductVariant(command) => {
                if self
                    .get_product_or_error(command.product_id.clone())?
                    .get_variant(command.variant_id.clone())
                    .is_some()
                {
                    Err(OrderError::ProductVariantExistent)?;
                }
                vec![OrderEvent::OrderProductVariantAdded {
                    product_id: command.product_id,
                    variant_id: command.variant_id,
                    sku: command.sku,
                    price: command.price,
                    attachment: command.attachment,
                    attributes: command.attributes,
                }]
            }
        })
    }

    fn apply(&mut self, event: Self::Event) {
        match event {
            OrderEvent::OrderAdded { id, buyer_id } => {
                self.id = id;
                self.buyer = Buyer::new(buyer_id);
            }
            OrderEvent::OrderArchived {} => self.is_archived = true,
            OrderEvent::OrderUnarchived {} => self.is_archived = false,
            OrderEvent::OrderProductAdded {
                product_id,
                store_id,
                name,
                slug,
                currency,
                attachment,
                attributes,
            } => self.add_product(
                product_id, store_id, name, slug, currency, attachment, attributes,
            ),
            OrderEvent::OrderProductVariantAdded {
                product_id,
                variant_id,
                sku,
                price,
                attachment,
                attributes,
            } => {
                if let Some(product) = self.get_product_as_mut(product_id) {
                    product.add_variant(variant_id, sku, price, attachment, attributes)
                }
            }
        }
    }
}
