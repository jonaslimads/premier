pub mod order;
pub mod platform;
pub mod product;
pub mod store;

pub fn default_platform_id() -> String {
    "0".to_string()
}

pub fn skip_default_platform_id(platform_id: &String) -> bool {
    platform_id == "0"
}

macro_rules! event_enum {
    (version $version:literal,
    enum $name:ident {
        $($variant:ident { $($tt:tt)* }),*,
    }) => {
        #[derive(Clone, Debug, Deserialize, PartialEq, Serialize)]
        pub enum $name {
            $($variant { $($tt)* }),*
        }

        impl cqrs_es::DomainEvent for $name {
            fn event_type(&self) -> String {
                match self {
                    $($name::$variant { .. } => stringify!($variant).to_string()),*
                }
            }

            fn event_version(&self) -> String {
                $version.to_string()
            }
        }
    };
}

pub(crate) use event_enum;
