use std::sync::Arc;

use crate::infrastructure::auth::{OidcProvider, Session, SessionIntent};
use crate::infrastructure::{get_random_event_aggregate_id, ConnectionPool};
use crate::presentation::{PresentationError, Result};

pub struct PresentationService {
    pool: ConnectionPool,
    oidc_provider: Arc<dyn OidcProvider + Send + Sync>,
}

impl PresentationService {
    pub fn new(
        pool: ConnectionPool,
        oidc_provider: Arc<dyn OidcProvider + Send + Sync>,
    ) -> Arc<Self> {
        Arc::new(Self {
            pool,
            oidc_provider,
        })
    }

    pub async fn prepare_aggregate_id(
        &self,
        aggregate_id: String,
        aggregate_type: &str,
        command_type: &str,
    ) -> Result<String> {
        let is_new =
            command_type.to_string().to_lowercase() == format!("{}{}", "add", aggregate_type);
        if is_new && aggregate_id == "" {
            Ok(get_random_event_aggregate_id(&self.pool, aggregate_type).await?)
        } else if is_new && aggregate_id != "" {
            Ok(aggregate_id)
        } else if !is_new && aggregate_id == "" {
            Err(PresentationError::EmptyAggregateId)
        } else if !self
            .exists_aggregate_id(aggregate_type, aggregate_id.clone())
            .await?
        {
            Err(PresentationError::NotFoundAggregate(aggregate_id))
        } else {
            Ok(aggregate_id)
        }
    }

    pub async fn parse_anonymous_session(&self, session_intent: SessionIntent) -> Result<Session> {
        Ok(session_intent.parse_or_anonymous(self.oidc_provider.clone()))
    }

    pub async fn parse_session(&self, session_intent: SessionIntent) -> Result<Session> {
        Ok(session_intent.parse(self.oidc_provider.clone())?)
    }

    // TODO make this regardless of database
    async fn exists_aggregate_id(
        &self,
        aggregate_type: &str,
        aggregate_id: String,
    ) -> Result<bool> {
        let sql = format!(
            "SELECT 1 FROM {}_event WHERE aggregate_id = ?",
            aggregate_type
        );
        let row: Option<(i32,)> = sqlx::query_as(sql.as_str())
            .bind(aggregate_id)
            .fetch_optional(&self.pool)
            .await?;
        match row {
            Some(_) => Ok(true),
            None => Ok(false),
        }
    }
}
