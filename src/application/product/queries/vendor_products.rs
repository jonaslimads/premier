use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query, View};
use mysql_es::MysqlViewRepository;

use crate::application::product::services::ProductServices;
use crate::application::vendor::queries::vendor_products::{
    VendorProductsView, VendorProductsViewProduct,
};
use crate::application::BaseQuery;
use crate::domain::product::events::ProductEvent;
use crate::domain::product::Product;

impl View<Product> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Product>) {
        match &event.payload {
            ProductEvent::ProductAdded {
                id,
                vendor_id: _,
                category_id: _,
                name,
                description: _,
                slug,
                currency,
                attachments,
                attributes,
            } => self.uncategorized_products.push(VendorProductsViewProduct {
                id: id.clone(),
                name: name.clone(),
                slug: slug.clone(),
                currency: currency.clone(),
                price: 0,
                attachments: attachments.clone(),
                attributes: attributes.clone(),
                is_archived: false,
            }),
            ProductEvent::ProductArchived {} => {
                if let Some(product) = self.get_product_mut(event.aggregate_id.clone()) {
                    product.is_archived = true;
                }
            }
            ProductEvent::ProductUnarchived {} => {
                if let Some(product) = self.get_product_mut(event.aggregate_id.clone()) {
                    product.is_archived = false;
                }
            }
            ProductEvent::ProductNameUpdated { name } => {
                if let Some(product) = self.get_product_mut(event.aggregate_id.clone()) {
                    product.name = name.clone();
                }
            }
            ProductEvent::ProductSlugUpdated { slug } => {
                if let Some(product) = self.get_product_mut(event.aggregate_id.clone()) {
                    product.slug = slug.clone();
                }
            }
            _ => {}
        }
    }
}

pub type VendorProductsQueryFromProduct = BaseQuery<
    MysqlViewRepository<VendorProductsView, Product>,
    VendorProductsView,
    Product,
    ProductServices,
>;

#[async_trait]
impl Query<Product> for VendorProductsQueryFromProduct {
    async fn dispatch(&self, view_id: &str, events: &[EventEnvelope<Product>]) {
        for event in events {
            if let ProductEvent::ProductAdded { vendor_id, .. } = &event.payload {
                self.services
                    .lookup
                    .bind_vendor_product(vendor_id.clone(), view_id.to_string())
                    .await
                    .unwrap();
            }
        }

        let vendor_id = match self
            .services
            .lookup
            .get_vendor_id_by_product_id(view_id.to_string())
            .await
        {
            Ok(vendor_id) => vendor_id,
            Err(error) => {
                log::error!("{:?}", error);
                return;
            }
        };
        log::info!("Got vendor_id {}", vendor_id);
        // log::info!("{} {:?} {}", _view_id, events, secondary_id.unwrap());
        match self.apply_events(vendor_id.as_str(), events).await {
            Ok(_) => {}
            Err(err) => self.handle_error(err),
        };
    }
}

// #[async_trait]
// impl<R, V, A> ReplayableQuery<A> for GenericQuery<R, V, A>
// where
//     R: ViewRepository<V, A>,
//     V: View<A>,
//     A: Aggregate,
// {
//     async fn replay(&self, view_id: &str, events: &[EventEnvelope<A>]) {
//         match self.replay_events(view_id, events).await {
//             Ok(_) => {}
//             Err(err) => self.handle_error(err),
//         };
//     }
// }
