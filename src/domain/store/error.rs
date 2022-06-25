use thiserror::Error;

use crate::application::store::services::CouldNotFindIdError;

#[derive(Clone, Debug, Error)]
pub enum StoreError {
    #[error("Could not find ID")]
    CouldNotFindId,
}

impl From<CouldNotFindIdError> for StoreError {
    #[inline]
    fn from(_: CouldNotFindIdError) -> Self {
        Self::CouldNotFindId
    }
}
