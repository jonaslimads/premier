use thiserror::Error;

use crate::application::vendor::services::CouldNotFindIdError;

#[derive(Clone, Debug, Error)]
pub enum VendorError {
    #[error("Could not find ID")]
    CouldNotFindId,
}

impl From<CouldNotFindIdError> for VendorError {
    #[inline]
    fn from(_: CouldNotFindIdError) -> Self {
        Self::CouldNotFindId
    }
}
