use cqrs_es::persist::PersistedEventStore;
use cqrs_es::{Aggregate, CqrsFramework, Query};
use mysql_es::MysqlViewRepository;
use mysql_es::{MysqlEventRepository, SqlQueryFactory};
use sqlx::mysql::MySqlPoolOptions;

pub type ViewRepository<V, A> = MysqlViewRepository<V, A>;

pub type ConnectionPool = sqlx::MySqlPool;

pub type Cqrs<A> = CqrsFramework<A, PersistedEventStore<MysqlEventRepository, A>>;

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
        CAST(aggregate_id AS CHAR) AS aggregate_id,
        sequence,
        event_type,
        CONVERT_VERSION_TO_TEXT(event_version) AS event_version,
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
  VALUES (?, ?, ?, CONVERT_VERSION_TO_INT(?), ?, ?)", events_table),
        format!("
SELECT {}
  FROM {}
  WHERE '' = ?
  ORDER BY CAST(aggregate_id AS UNSIGNED), sequence", event_select_fields, events_table),
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
SELECT '' AS aggregate_type, CAST(aggregate_id AS CHAR) AS aggregate_id, last_sequence, current_snapshot, payload
  FROM {}
  WHERE '' = ? AND aggregate_id = ?", snapshots_table));
    let repo = MysqlEventRepository::new(pool).with_query_factory(query_factory);
    let store = PersistedEventStore::new_event_store(repo); //.with_upcasters(get_upcasters());
    CqrsFramework::new(store, queries, services)
}

pub async fn start_connection_pool(database_uri: String, max_connections: u32) -> ConnectionPool {
    MySqlPoolOptions::new()
        .max_connections(max_connections)
        .connect(database_uri.as_str())
        .await
        .expect("unable to connect to database")
}

pub async fn get_random_event_aggregate_id(pool: &ConnectionPool, aggregate_type: &str) -> crate::presentation::Result<String> {
  let sql = format!(
      "SELECT GET_RANDOM_{}_EVENT_AGGREGATE_ID(100000000000, 1000000000000-1)",
      aggregate_type
  );
  let row: (u64,) = sqlx::query_as(sql.as_str()).fetch_one(&pool).await?;
  Ok(row.0.to_string())
}

// test upcast
// use cqrs_es::persist::{EventUpcaster, SemanticVersionEventUpcaster};

// fn get_upcasters() -> Vec<Box<dyn EventUpcaster>> {
//     vec![
//         Box::new(SemanticVersionEventUpcaster::new(
//             "VendorArchived",
//             "0.1.1",
//             Box::new(|mut event| match event.get_mut("VendorArchived").unwrap() {
//                 Value::Object(object) => {
//                     object.insert("test".to_string(), Value::Bool(true));
//                     event
//                 }
//                 _ => panic!("not the expected object"),
//             }),
//         )),
//         Box::new(SemanticVersionEventUpcaster::new(
//             "VendorArchived",
//             "0.1.2",
//             Box::new(|mut event| match event.get_mut("VendorArchived").unwrap() {
//                 Value::Object(object) => {
//                     object.insert("test2".to_string(), Value::Bool(false));
//                     event
//                 }
//                 _ => panic!("not the expected object"),
//             }),
//         )),
//     ]
// }
