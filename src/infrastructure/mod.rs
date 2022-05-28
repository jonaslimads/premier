pub mod auth;
pub mod error;
pub mod product;
pub mod vendor;

pub use error::{InfrastructureError, Result};

// this will depend on the chosen build flags
// use mysql_es::{mysql_cqrs, MysqlCqrs, MysqlViewRepository};
mod mysql;
pub use mysql::{cqrs, start_connection_pool};
pub type Cqrs<A> = mysql::MysqlCqrs<A>;
pub type ViewRepository<V, A> = mysql::MysqlViewRepository<V, A>;
pub type ConnectionPool = sqlx::MySqlPool;
