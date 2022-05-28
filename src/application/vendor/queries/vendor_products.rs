use std::sync::Arc;

use async_trait::async_trait;
use cqrs_es::persist::{PersistenceError, ViewContext, ViewRepository};
use cqrs_es::{Aggregate, EventEnvelope, Query, ReplayableQuery, View};
use mysql_es::MysqlViewRepository;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::application::product::services::ProductServices;
use crate::domain::product::events::ProductEvent;
use crate::domain::product::Product;
use crate::domain::vendor::events::VendorEvent;
use crate::domain::vendor::Vendor;

#[derive(Debug, Default, Serialize, Deserialize)]
pub struct VendorProductsView {
    pub id: String,
    pub name: String,
    pub attributes: Value,
    pub is_archived: bool,
    pub products: Vec<VendorProductsViewProduct>,
}

#[derive(Debug, Default, Serialize, Deserialize)]
pub struct VendorProductsViewProduct {
    pub id: String,
    pub name: String,
    pub description: String,
    pub slug: String,
    pub currency: String,
}

impl View<Vendor> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Vendor>) {
        match &event.payload {
            VendorEvent::VendorAdded {
                id,
                name,
                attributes,
            } => {
                self.id = id.clone();
                self.name = name.clone();
                self.attributes = attributes.clone();
            }
            VendorEvent::VendorArchived {} => self.is_archived = true,
            VendorEvent::VendorUnarchived {} => self.is_archived = false,
        }
    }
}

impl View<Product> for VendorProductsView {
    fn update(&mut self, event: &EventEnvelope<Product>) {
        match &event.payload {
            ProductEvent::ProductAdded {
                id,
                vendor_id: _,
                name,
                description,
                slug,
                currency,
                attachments: _,
                attributes: _,
            } => self.products.push(VendorProductsViewProduct {
                id: id.clone(),
                name: name.clone(),
                description: description.clone(),
                slug: slug.clone(),
                currency: currency.clone(),
            }),
            _ => {}
        }
    }
}

type VendorViewRepository = Arc<MysqlViewRepository<VendorProductsView, Vendor>>;

type ProductViewRepository = Arc<MysqlViewRepository<VendorProductsView, Product>>;

type ErrorHandler = dyn Fn(PersistenceError) + Send + Sync + 'static;

pub struct VendorProductsQuery {
    vendor_view_repository: Option<VendorViewRepository>,
    product_view_repository: Option<ProductViewRepository>,
    product_services: Option<Arc<ProductServices>>,
    error_handler: Option<Box<ErrorHandler>>,
}

#[async_trait]
impl Query<Vendor> for VendorProductsQuery {
    async fn dispatch(&self, view_id: &str, events: &[EventEnvelope<Vendor>]) {
        match self.apply_vendor_events(view_id, events).await {
            Ok(_) => {}
            Err(err) => self.handle_error(err),
        };
    }
}

#[async_trait]
impl Query<Product> for VendorProductsQuery {
    async fn dispatch(&self, view_id: &str, events: &[EventEnvelope<Product>]) {
        let services = self.get_product_services();

        for event in events {
            if let ProductEvent::ProductAdded { vendor_id, .. } = &event.payload {
                services
                    .lookup
                    .bind_vendor_product(vendor_id.clone(), view_id.to_string())
                    .await
                    .unwrap();
            }
        }

        let vendor_id = match services
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
        match self.apply_product_events(vendor_id.as_str(), events).await {
            Ok(_) => {}
            Err(err) => self.handle_error(err),
        };
    }
}

impl VendorProductsQuery {
    pub fn for_vendor(vendor_view_repository: VendorViewRepository) -> Self {
        Self {
            vendor_view_repository: Some(vendor_view_repository),
            product_view_repository: None,
            product_services: None,
            error_handler: None,
        }
    }

    pub fn for_product(
        product_view_repository: ProductViewRepository,
        product_services: Arc<ProductServices>,
    ) -> Self {
        Self {
            vendor_view_repository: None,
            product_view_repository: Some(product_view_repository),
            product_services: Some(product_services),
            error_handler: None,
        }
    }

    pub fn use_error_handler(&mut self, error_handler: Box<ErrorHandler>) {
        self.error_handler = Some(error_handler);
    }

    pub async fn load(&self, view_id: &str) -> Option<VendorProductsView> {
        let view = if let Some(repository) = &self.vendor_view_repository {
            repository.load_with_context(&view_id)
        } else if let Some(repository) = &self.product_view_repository {
            repository.load_with_context(&view_id)
        } else {
            return None;
        };

        match view.await {
            Ok(option) => option.map(|(view, _)| view),
            Err(error) => {
                self.handle_error(error);
                None
            }
        }
    }

    fn get_product_services(&self) -> &Arc<ProductServices> {
        self.product_services.as_ref().expect("No service found")
    }

    async fn load_mut(
        &self,
        view_id: String,
    ) -> Result<(VendorProductsView, ViewContext), PersistenceError> {
        let view = if let Some(repository) = &self.vendor_view_repository {
            repository.load_with_context(&view_id)
        } else if let Some(repository) = &self.product_view_repository {
            repository.load_with_context(&view_id)
        } else {
            let view_context = ViewContext::new(view_id, 0);
            return Ok((Default::default(), view_context));
        };

        match view.await? {
            None => {
                let view_context = ViewContext::new(view_id, 0);
                Ok((Default::default(), view_context))
            }
            Some((view, context)) => Ok((view, context)),
        }
    }

    async fn apply_vendor_events(
        &self,
        view_id: &str,
        events: &[EventEnvelope<Vendor>],
    ) -> Result<(), PersistenceError> {
        let (view, view_context) = self.load_mut(view_id.to_string()).await?;
        if let Some(repository) = &self.vendor_view_repository {
            self.apply_events(repository, view, view_context, events)
                .await?;
        }
        Ok(())
    }

    async fn apply_product_events(
        &self,
        view_id: &str,
        events: &[EventEnvelope<Product>],
    ) -> Result<(), PersistenceError> {
        let (view, view_context) = self.load_mut(view_id.to_string()).await?;
        log::warn!("Got view: {:?} {}", view, view_id);
        if let Some(repository) = &self.product_view_repository {
            self.apply_events(repository, view, view_context, events)
                .await?;
        }
        Ok(())
    }

    async fn replay_events<A: Aggregate, V: View<A>>(
        &self,
        repository: &MysqlViewRepository<V, A>,
        view_id: &str,
        events: &[EventEnvelope<A>],
    ) -> Result<(), PersistenceError> {
        let view_context = ViewContext::new(view_id.to_string(), 0);
        let mut view: V = Default::default();
        for event in events {
            view.update(event);
        }
        repository.delete_view(view_id).await?;
        repository.update_view(view, view_context).await?;
        Ok(())
    }

    async fn apply_events<A: Aggregate, V: View<A>>(
        &self,
        repository: &MysqlViewRepository<V, A>,
        mut view: V,
        view_context: ViewContext,
        events: &[EventEnvelope<A>],
    ) -> Result<(), PersistenceError> {
        for event in events {
            view.update(event);
        }
        repository.update_view(view, view_context).await?;
        Ok(())
    }

    fn handle_error(&self, error: PersistenceError) {
        match &self.error_handler {
            None => {}
            Some(handler) => {
                (handler)(error);
            }
        }
    }
}

// #[async_trait]
// impl<R, V, A> ReplayableQuery<A> for VendorProductsQuery<R, V, A>
// where
//     R: ViewRepository<V, A>,
//     V: View<A>,
//     A: Aggregate,
// {
//     async fn replay(&self, view_id: &str, events: &[EventEnvelope<A>]) {
//         // match self.replay_events(view_id, events).await {
//         //     Ok(_) => {}
//         //     Err(err) => self.handle_error(err),
//         // };
//     }
// }
