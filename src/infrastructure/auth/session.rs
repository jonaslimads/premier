use std::collections::HashMap;
use std::sync::Arc;

use itertools::Itertools;
use jsonwebtoken::{decode, errors as JwtError, DecodingKey, TokenData, Validation};
use serde::{Deserialize, Serialize};

use crate::infrastructure::auth::oidc_providers::OidcProvider;
use crate::infrastructure::error::InfrastructureError;

#[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct SessionIntent {
    authorization: String,
    metadata: HashMap<String, String>,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct Session {
    claims: Claims,
    user_id: String,
    pub metadata: HashMap<String, String>,
}

// pub struct Headers {
//     pub authorization: Option<String>,
// }

#[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct Claims {
    sub: String,
    // groups: Option<Vec<String>>,
}

impl SessionIntent {
    pub fn new(authorization: Option<String>) -> Self {
        Self {
            authorization: authorization.unwrap_or("".to_string()),
            metadata: HashMap::new(),
        }
    }

    pub fn insert_to_metadata(&mut self, key: &str, value: Option<String>) {
        self.metadata
            .insert(key.to_string(), value.unwrap_or("".to_string()));
    }

    pub fn parse_or_anonymous(&self, oidc_provider: Arc<dyn OidcProvider>) -> Session {
        self.parse(oidc_provider).unwrap_or(self.as_anonymous())
    }

    pub fn parse(
        &self,
        oidc_provider: Arc<dyn OidcProvider>,
    ) -> Result<Session, InfrastructureError> {
        if self.authorization == "" {
            return Err(invalid_token_error());
        }

        let parts: Vec<&str> = self.authorization.split_whitespace().collect_vec();

        if parts.len() < 2 || parts[0] != "Bearer" {
            return Err(invalid_token_error());
        }

        let token = String::from(parts[1]);
        let token = Self::validate(oidc_provider, token)?;
        let claims = token.claims;
        let user_id = claims.sub.clone();
        let mut metadata = self.metadata.clone();
        metadata.insert("user_id".to_string(), user_id.clone());

        Ok(Session {
            claims,
            user_id,
            metadata,
        })
    }

    pub fn validate(
        oidc_provider: Arc<dyn OidcProvider>,
        token: String,
    ) -> jsonwebtoken::errors::Result<TokenData<Claims>> {
        decode::<Claims>(
            &token,
            &DecodingKey::from_rsa_components(
                oidc_provider.get_modulus(),
                oidc_provider.get_exponent(),
            )?,
            &Validation::new(oidc_provider.get_algorithm()),
        )
    }

    pub fn as_anonymous(&self) -> Session {
        Session {
            metadata: self.metadata.clone(),
            ..Default::default()
        }
    }
}

// impl Session {
//     pub fn is_anonymous(&self) -> bool {
//         self.user_id == "".to_string()
//     }
// }

pub fn invalid_token_error() -> InfrastructureError {
    InfrastructureError::from(JwtError::Error::from(JwtError::ErrorKind::InvalidToken))
}

// fn invalid_subject_error() -> InfrastructureError {
//     InfrastructureError::from(JwtError::Error::from(JwtError::ErrorKind::InvalidSubject))
// }
