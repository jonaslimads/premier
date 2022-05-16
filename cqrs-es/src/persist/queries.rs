use std::marker::PhantomData;
use std::sync::Arc;

use async_trait::async_trait;

use crate::persist::{PersistenceError, ViewContext, ViewRepository};
use crate::{Aggregate, EventEnvelope, Query, View};

/// A simple query and view repository. This is used both to act as a `Query` for processing events
/// and to return materialized views.
pub struct GenericQuery<R, V, A>
where
    R: ViewRepository<V, A>,
    V: View<A>,
    A: Aggregate,
{
    view_repository: Arc<R>,
    error_handler: Option<Box<ErrorHandler>>,
    phantom: PhantomData<(V, A)>,
}

type ErrorHandler = dyn Fn(PersistenceError) + Send + Sync + 'static;

impl<R, V, A> GenericQuery<R, V, A>
where
    R: ViewRepository<V, A>,
    V: View<A>,
    A: Aggregate,
{
    /// Creates a new `GenericQuery` using the provided `ViewRepository`.
    ///
    /// ```
    /// # use std::sync::Arc;
    /// # use cqrs_es::doc::MyAggregate;
    /// # use cqrs_es::persist::doc::{MyDatabaseConnection, MyView, MyViewRepository};
    /// # use cqrs_es::persist::GenericQuery;
    /// # fn config(my_db_connection: MyDatabaseConnection) {
    /// let repo = Arc::new(MyViewRepository::new(my_db_connection));
    /// let query = GenericQuery::<MyViewRepository, MyView, MyAggregate>::new(repo);
    /// # }
    /// ```
    pub fn new(view_repository: Arc<R>) -> Self {
        GenericQuery {
            view_repository,
            error_handler: None,
            phantom: Default::default(),
        }
    }
    /// Allows the user to apply a custom error handler to the query.
    /// Queries are infallible and _should_ never cause errors,
    /// but programming errors or other technical problems
    /// might. Adding an error handler allows the user to choose whether to
    /// panic the application, log the error or otherwise register the issue.
    ///
    /// Use of an error handler is *strongly* recommended since without one any error encountered
    /// by the query repository will simply be ignored.
    ///
    /// _Example: An error handler that panics on any error._
    /// ```
    /// # use cqrs_es::doc::MyAggregate;
    /// # use cqrs_es::persist::GenericQuery;
    /// # use cqrs_es::persist::doc::{MyViewRepository,MyView};
    /// # fn config(mut query: GenericQuery<MyViewRepository,MyView,MyAggregate>) {
    /// query.use_error_handler(Box::new(|e|panic!("{}",e)));
    /// # }
    /// ```
    pub fn use_error_handler(&mut self, error_handler: Box<ErrorHandler>) {
        self.error_handler = Some(error_handler);
    }

    /// Loads and deserializes a view based on the provided view id.
    /// Use this method to load a materialized view when requested by a user.
    ///
    /// ```
    /// # use cqrs_es::doc::MyAggregate;
    /// # use cqrs_es::persist::GenericQuery;
    /// # use cqrs_es::persist::doc::{MyViewRepository,MyView};
    /// # async fn config(mut query: GenericQuery<MyViewRepository,MyView,MyAggregate>) {
    /// let view = query.load("customer-B24DA0").await;
    /// # }
    /// ```
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

    fn handle_error(&self, error: PersistenceError) {
        match &self.error_handler {
            None => {}
            Some(handler) => {
                (handler)(error);
            }
        }
    }
}

#[async_trait]
impl<R, V, A> Query<A> for GenericQuery<R, V, A>
where
    R: ViewRepository<V, A>,
    V: View<A>,
    A: Aggregate,
{
    async fn dispatch(&self, view_id: &str, events: &[EventEnvelope<A>]) {
        match self.apply_events(view_id, events).await {
            Ok(_) => {}
            Err(err) => self.handle_error(err),
        };
    }
}
