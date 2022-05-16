use crate::{Aggregate, AggregateContext};

/// Holds context for the pure event store implementation PostgresStore.
/// This is only used internally within the `EventStore`.
pub struct EventStoreAggregateContext<A: Aggregate> {
    /// The aggregate ID of the aggregate instance that has been loaded.
    pub aggregate_id: String,
    /// The current state of the aggregate instance.
    pub aggregate: A,
    /// The last committed event sequence number for this aggregate instance.
    pub current_sequence: usize,
    /// The last committed snapshot version for this aggregate instance.
    pub current_snapshot: Option<usize>,
}

impl<A: Aggregate> EventStoreAggregateContext<A> {
    pub(crate) fn context_for(aggregate_id: &str, _is_event_source: bool) -> Self {
        Self {
            aggregate_id: aggregate_id.to_string(),
            aggregate: A::default(),
            current_sequence: 0,
            current_snapshot: None,
        }
    }
}

impl<A: Aggregate> AggregateContext<A> for EventStoreAggregateContext<A> {
    fn aggregate(&self) -> &A {
        &self.aggregate
    }
}

/// A data structure maintaining context when updating views.
pub struct ViewContext {
    /// Unique identifier of the view instance that is being modified.
    pub view_instance_id: String,
    /// The current version of the view instance, used for optimistic locking.
    pub version: i64,
}

impl ViewContext {
    /// Convenience function to create a new QueryContext.
    pub fn new(view_instance_id: String, version: i64) -> Self {
        Self {
            view_instance_id,
            version,
        }
    }
}
