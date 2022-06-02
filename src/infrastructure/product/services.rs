use async_trait::async_trait;

use crate::application::product::services::ProductLookup as ProductLookupTrait;
use crate::application::ApplicationError;
use crate::infrastructure::{ConnectionPool, InfrastructureError};

pub struct ProductLookup {
    pool: ConnectionPool,
}

impl ProductLookup {
    pub fn new(pool: ConnectionPool) -> Box<Self> {
        Box::new(Self { pool })
    }
}

#[async_trait]
impl ProductLookupTrait for ProductLookup {
    async fn bind_vendor_product(
        &self,
        vendor_id: String,
        product_id: String,
    ) -> Result<(), ApplicationError> {
        sqlx::query(
            "INSERT INTO vendor_product VALUES(?, ?) ON DUPLICATE KEY UPDATE product_id = product_id",
        )
        .bind(vendor_id)
        .bind(product_id)
        .execute(&self.pool)
        .await
        .map_err(InfrastructureError::from)?;
        Ok(())
    }

    async fn get_vendor_id_by_product_id(
        &self,
        product_id: String,
    ) -> Result<String, ApplicationError> {
        let row: (String,) = sqlx::query_as(
            "SELECT CAST(vendor_id AS CHAR) AS vendor_id FROM vendor_product WHERE product_id = ?",
        )
        .bind(product_id)
        .fetch_one(&self.pool)
        .await
        .map_err(InfrastructureError::from)?;
        Ok(row.0)
    }
}