// use async_graphql::{ComplexObject, Context, ErrorExtensions, Object, Result};
use async_graphql::{Object, Result};

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn is_up(&self) -> Result<bool> {
        Ok(true)
    }
}
