use cqrs_es::persist::PersistedEventStore;
use cqrs_es::{Aggregate, CqrsFramework, Query};
use sqlite_es::SqliteViewRepository;
use sqlite_es::{SqliteEventRepository, SqlQueryFactory};
use sqlx::sqlite::SqlitePoolOptions;

pub type ViewRepository<V, A> = SqliteViewRepository<V, A>;

pub type ConnectionPool = sqlx::SqlitePool;

pub type Cqrs<A> = CqrsFramework<A, PersistedEventStore<SqliteEventRepository, A>>;

pub async fn cqrs<A>(
    pool: ConnectionPool,
    events_table: &str,
    queries: Vec<Box<dyn Query<A>>>,
    services: A::Services,
) -> Cqrs<A>
where
    A: Aggregate,
{
    let snapshots_table = "snapshot";
    let event_select_fields = "
        '' AS aggregate_type,
        aggregate_id,
        sequence,
        event_type,
        event_version,
        payload,
        metadata
    ";
    let query_factory = SqlQueryFactory::with(
        format!("
SELECT {}
  FROM {}
  WHERE '' = ? AND aggregate_id = ?
  ORDER BY sequence", event_select_fields, events_table),
        format!("
INSERT INTO {} (aggregate_id, sequence, event_type, event_version, payload, metadata)
  VALUES (?, ?, ?, ?, ?, ?)", events_table),
        format!("
SELECT {}
  FROM {}
  WHERE '' = ?
  ORDER BY aggregate_id, sequence", event_select_fields, events_table),
        format!("
SELECT {}
  FROM {}
  WHERE '' = ? AND aggregate_id = ? AND sequence > ?
  ORDER BY sequence", event_select_fields, events_table),
        format!("
INSERT INTO {} (aggregate_id, last_sequence, current_snapshot, payload)
  VALUES (?, ?, ?, ?)", snapshots_table),
        format!("
UPDATE {}
  SET last_sequence = ? , payload = ?, current_snapshot = ?
  WHERE '' = ? AND aggregate_id = ? AND current_snapshot = ?", snapshots_table),
        format!("
SELECT '' AS aggregate_type, aggregate_id, last_sequence, current_snapshot, payload
  FROM {}
  WHERE '' = ? AND aggregate_id = ?", snapshots_table));
    let repo = SqliteEventRepository::new(pool).with_query_factory(query_factory);
    let store = PersistedEventStore::new_event_store(repo); //.with_upcasters(get_upcasters());
    CqrsFramework::new(store, queries, services)
}

pub async fn start_connection_pool(database_uri: &str, max_connections: u32) -> ConnectionPool {
    SqlitePoolOptions::new()
        .max_connections(max_connections)
        .connect(database_uri)
        .await
        .expect("unable to connect to database")
}