use std::marker::PhantomData;
use std::sync::Arc;

use cqrs_es::persist::{PersistenceError, ViewContext, ViewRepository};
use cqrs_es::{Aggregate, EventEnvelope, View};

type ErrorHandler = dyn Fn(PersistenceError) + Send + Sync + 'static;

pub struct BaseQuery<R, V, A, S>
where
    R: ViewRepository<V, A>,
    V: View<A>,
    A: Aggregate,
{
    view_repository: Arc<R>,
    error_handler: Option<Box<ErrorHandler>>,
    pub services: Arc<S>,
    phantom: PhantomData<(V, A)>,
}

impl<R, V, A, S> BaseQuery<R, V, A, S>
where
    R: ViewRepository<V, A>,
    V: View<A>,
    A: Aggregate,
{
    pub fn new(view_repository: Arc<R>, services: Arc<S>) -> Self {
        BaseQuery {
            view_repository,
            error_handler: None,
            services,
            phantom: Default::default(),
        }
    }

    pub fn use_error_handler(&mut self, error_handler: Box<ErrorHandler>) {
        self.error_handler = Some(error_handler);
    }

    pub async fn load(&self, view_id: &str) -> Option<V> {
        match self.view_repository.load_with_context(view_id).await {
            Ok(option) => option.map(|(view, _)| view),
            Err(e) => {
                self.handle_error(e);
                None
            }
        }
    }

    async fn load_mut(&self, view_id: String) -> Result<(V, ViewContext), PersistenceError> {
        match self.view_repository.load_with_context(&view_id).await? {
            None => {
                let view_context = ViewContext::new(view_id, 0);
                Ok((Default::default(), view_context))
            }
            Some((view, context)) => Ok((view, context)),
        }
    }

    pub(crate) async fn apply_events(
        &self,
        view_id: &str,
        events: &[EventEnvelope<A>],
    ) -> Result<(), PersistenceError> {
        let (mut view, view_context) = self.load_mut(view_id.to_string()).await?;
        for event in events {
            view.update(event);
        }
        self.view_repository.update_view(view, view_context).await?;
        Ok(())
    }

    pub(crate) async fn replay_events(
        &self,
        view_id: &str,
        events: &[EventEnvelope<A>],
    ) -> Result<(), PersistenceError> {
        todo!()
        // let mut view: V = Default::default();
        // for event in events {
        //     view.update(event);
        // }
        // let view_context = ViewContext::new(view_id.to_string(), 0);
        // self.view_repository.delete_view(view_id).await?;
        // self.view_repository.update_view(view, view_context).await?;
        // Ok(())
    }

    pub fn handle_error(&self, error: PersistenceError) {
        match &self.error_handler {
            None => {}
            Some(handler) => {
                (handler)(error);
            }
        }
    }
}
