use async_trait::async_trait;
use cqrs_es::persist::PersistenceError;
use cqrs_es::{Aggregate, View};

#[async_trait]
pub trait ExtendedViewRepository<V, A>: Send + Sync
where
    V: View<A>,
    A: Aggregate,
{
    async fn load_all(&self) -> Result<Vec<V>, PersistenceError>;

    async fn load_many(&self, view_ids: Vec<String>) -> Result<Vec<V>, PersistenceError>;
}
