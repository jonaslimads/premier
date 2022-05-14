use jsonwebtoken::{decode, errors as JwtError, Algorithm};
use keycloak::{types::*, KeycloakAdmin, KeycloakAdminToken};
use reqwest::Client;
use serde_json::Value;
use std::collections::HashMap;
use std::fmt;
use std::sync::Arc;

use crate::infrastructure::auth::oidc_providers::OidcProvider;
use crate::infrastructure::Result;

#[derive(Default)]
pub struct Keycloak {
    url: String,
    realm: String,
    admin_username: String,
    admin_password: String,
    signature: Signature,
    client: Client,
    // admin: Option<KeycloakAdmin>,
    // token: Option<KeycloakAdminToken>,
}

// TODO introspect from http://localhost:8080/auth/realms/master/protocol/openid-connect/certs
#[derive(Default)]
pub struct Signature {
    algorithm: String,
    modulus: String,
    exponent: String,
}

impl fmt::Debug for Keycloak {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Keycloak")
    }
}

impl Keycloak {
    pub fn new(
        url: String,
        realm: String,
        admin_username: String,
        admin_password: String,
        signature: Signature,
    ) -> Arc<Self> {
        Arc::new(Self {
            url,
            realm,
            admin_username,
            admin_password,
            signature,
            client: Client::new(), // token: None,
            ..Default::default()
        })
    }

    pub async fn save(
        &self,
        email: String,
        password: Option<String>,
        first_name: String,
        last_name: String,
        attributes: Option<HashMap<String, Value>>,
        enabled: bool,
    ) -> Result<String> {
        let realm = self.realm.as_ref();
        let admin = self.get_admin().await?;

        admin
            .realm_users_post(
                realm,
                UserRepresentation {
                    email: Some(email.clone()),
                    first_name: Some(first_name),
                    last_name: Some(last_name),
                    attributes,
                    enabled: Some(enabled),
                    ..Default::default()
                },
            )
            .await?;

        let users = admin
            .realm_users_get(
                realm,
                None,
                Some(email.clone()),
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
            )
            .await?;

        let id = users
            .iter()
            .find(|u| u.email == Some(email.clone()))
            .unwrap()
            .id
            .as_ref()
            .unwrap()
            .to_string();

        admin
            .realm_users_with_id_reset_password_put(
                realm,
                id.as_str(),
                CredentialRepresentation {
                    type_: Some("password".to_string()),
                    value: password,
                    temporary: Some(false),
                    ..Default::default()
                },
            )
            .await?;

        Ok(id)
    }

    pub async fn exists_by_email(&self, email: String) -> Result<bool> {
        let admin = self.get_admin().await?;

        let users = admin
            .realm_users_get(
                self.realm.as_ref(),
                None,
                Some(email.clone()),
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
                None,
            )
            .await?;

        Ok(!users.is_empty())
    }

    async fn get_admin(&self) -> Result<KeycloakAdmin> {
        // let user = env::var("BACKEND_KEYCLOAK_USER").unwrap_or("keycloak".to_string());
        // let password = env::var("BACKEND_KEYCLOAK_PASSWORD").unwrap_or("admin".to_string());
        // let url = format!(
        //     "http://{}",
        //     env::var("KEYCLOAK_URL").unwrap_or("192.168.0.2".to_string())
        // );
        let client = Client::new();
        let token = KeycloakAdminToken::acquire(
            self.url.as_ref(),
            self.admin_username.as_ref(),
            self.admin_password.as_ref(),
            &self.client,
        )
        .await?;
        Ok(KeycloakAdmin::new(self.url.as_ref(), token, client))
    }
}

impl OidcProvider for Keycloak {
    fn get_modulus(&self) -> &str {
        self.signature.modulus.as_str()
    }

    fn get_exponent(&self) -> &str {
        self.signature.exponent.as_str()
    }

    fn get_algorithm(&self) -> Algorithm {
        Algorithm::RS256
    }
}

impl Signature {
    pub fn new(algorithm: String, modulus: String, exponent: String) -> Self {
        Self {
            algorithm,
            modulus,
            exponent,
        }
    }
}
