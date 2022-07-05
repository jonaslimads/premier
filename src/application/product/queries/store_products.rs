use async_trait::async_trait;
use cqrs_es::{EventEnvelope, Query, View};

use crate::application::product::services::ProductServices;
use crate::application::store::queries::store_products::{
    StoreProductsView, StoreProductsViewProduct,
};
use crate::commons::{HasNestedGroupsWithItems, BaseQuery};
use crate::domain::product::events::ProductEvent;
use crate::domain::product::Product;
use crate::infrastructure::ViewRepository;

impl View<Product> for StoreProductsView {
    fn update(&mut self, event: &EventEnvelope<Product>) {
        match &event.payload {
            ProductEvent::ProductAdded {
                id,
                platform_id: _,
                store_id: _,
                category_id: _,
                page_id: _,
                name,
                description: _,
                slug,
                currency,
                attachments,
                attributes,
            } => self.unpaged_products.push(StoreProductsViewProduct {
                id: id.clone(),
                name: name.clone(),
                slug: slug.clone(),
                currency: currency.clone(),
                price: 0,
                attachments: attachments.clone(),
                attributes: attributes.clone(),
                is_published: false,
            }),
            ProductEvent::ProductPublished {} => {
                self.mutate_item(event.aggregate_id.clone(), &mut |product| {
                    product.is_published = true;
                });
            }
            ProductEvent::ProductUnpublished {} => {
                self.mutate_item(event.aggregate_id.clone(), &mut |product| {
                    product.is_published = false;
                });
            }
            ProductEvent::ProductNameUpdated { name } => {
                self.mutate_item(event.aggregate_id.clone(), &mut |product| {
                    product.name = name.clone();
                });
            }
            ProductEvent::ProductSlugUpdated { slug } => {
                self.mutate_item(event.aggregate_id.clone(), &mut |product| {
                    product.slug = slug.clone();
                });
            }
            _ => {}
        }
    }
}

pub type StoreProductsQueryFromProduct = BaseQuery<
    ViewRepository<StoreProductsView, Product>,
    StoreProductsView,
    Product,
    ProductServices,
>;

#[async_trait]
impl Query<Product> for StoreProductsQueryFromProduct {
    async fn dispatch(&self, view_id: &str, events: &[EventEnvelope<Product>]) {
        for event in events {
            if let ProductEvent::ProductAdded { store_id, .. } = &event.payload {
                self.services
                    .lookup
                    .bind_store_product(store_id.clone(), view_id.to_string())
                    .await
                    .unwrap();
            }
        }

        let store_id = match self
            .services
            .lookup
            .get_store_id_by_product_id(view_id.to_string())
            .await
        {
            Ok(store_id) => store_id,
            Err(error) => {
                log::error!("{:?}", error);
                return;
            }
        };
        log::info!("Got store_id {}", store_id);
        // log::info!("{} {:?} {}", _view_id, events, secondary_id.unwrap());
        match self.apply_events(store_id.as_str(), events).await {
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
