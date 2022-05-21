use cqrs_es::persist::{PersistedEventRepository, PersistedEventStore};
use cqrs_es::{Aggregate, CqrsFramework};
use mysql_es::MysqlEventRepository;
pub type MysqlCqrs<A> = CqrsFramework<A, PersistedEventStore<MysqlEventRepository, A>>;

//
use cqrs_es::Query;
pub use mysql_es::MysqlViewRepository;
pub use sqlx::mysql::MySqlPoolOptions;
pub use sqlx::MySqlPool;

pub async fn cqrs<A>(
    pool: MySqlPool,
    events_table: &str,
    query_processor: Vec<Box<dyn Query<A>>>,
    services: A::Services,
) -> MysqlCqrs<A>
where
    A: Aggregate,
{
    let snapshots_table = "snapshot";
    let repo = MysqlEventRepository {
        pool,
        event_table: events_table.to_string(),
        insert_event: format!("INSERT INTO {} (aggregate_id, sequence, event_type, event_version, payload, metadata)
                                    VALUES (?, ?, ?, CONVERT_VERSION_TO_INT(?), ?, ?)", events_table),
        select_events: format!("SELECT '' AS aggregate_type, CAST(aggregate_id AS CHAR) AS aggregate_id, sequence, event_type, CONVERT_VERSION_TO_TEXT(event_version) AS event_version, payload, metadata
                                    FROM {}
                                    WHERE '' = ?
                                        AND aggregate_id = ? ORDER BY sequence", events_table),
        select_last_events: format!("SELECT '' AS aggregate_type, CAST(aggregate_id AS CHAR) AS aggregate_id, sequence, event_type, event_version, payload, metadata
                                    FROM {}
                                    WHERE '' = ?
                                        AND aggregate_id = ?
                                        AND sequence > ?
                                    ORDER BY sequence", events_table),
        select_multiple_aggregate_events: format!("SELECT '' AS aggregate_type, CAST(aggregate_id AS CHAR) AS aggregate_id, sequence, event_type, event_version, payload, metadata
                                                    FROM {}
                                                    WHERE '' = ?
                                                        AND aggregate_id IN ?
                                                    ORDER BY CAST(aggregate_id AS UNSIGNED), sequence", events_table),

        insert_snapshot: format!("INSERT INTO {} (aggregate_id, last_sequence, current_snapshot, payload)
                                    VALUES (?, ?, ?, ?)", snapshots_table),
        update_snapshot: format!("UPDATE {}
                                    SET last_sequence= ? , payload= ?, current_snapshot= ?
                                    WHERE '' = ? AND aggregate_id= ? AND current_snapshot= ?", snapshots_table),
        select_snapshot: format!("SELECT '' AS aggregate_type, CAST(aggregate_id AS CHAR) AS aggregate_id, last_sequence, current_snapshot, payload
                                    FROM {}
                                    WHERE '' = ? AND aggregate_id = ?", snapshots_table),
    };
    log::warn!(
        "{:?}",
        repo.get_multiple_aggregate_events::<A>(vec!["332807312192", "332807312191"])
            .await
            .unwrap()
    );
    let store = PersistedEventStore::new_event_store(repo); //.with_upcasters(get_upcasters());
    CqrsFramework::new(store, query_processor, services)
}

pub async fn start_connection_pool(database_uri: &str, max_connections: u32) -> sqlx::MySqlPool {
    MySqlPoolOptions::new()
        .max_connections(max_connections)
        .connect(database_uri)
        .await
        .expect("unable to connect to database")
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
