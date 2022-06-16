pub mod order;
pub mod platform;
pub mod product;
pub mod vendor;

pub fn default_platform_id() -> String {
    "0".to_string()
}

pub fn skip_default_platform_id(platform_id: &String) -> bool {
    platform_id == "0"
}
