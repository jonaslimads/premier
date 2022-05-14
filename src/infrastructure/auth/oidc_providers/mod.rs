use jsonwebtoken::Algorithm;

pub mod keycloak;

pub trait OidcProvider {
    fn get_modulus(&self) -> &str;
    fn get_exponent(&self) -> &str;
    fn get_algorithm(&self) -> Algorithm;
}
