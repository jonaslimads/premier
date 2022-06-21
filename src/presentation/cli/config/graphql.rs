use serde::Deserialize;

const DEFAULT_PORT: u16 = 10001;

#[derive(Clone, Debug, Deserialize)]
pub struct GraphqlConfig {
    pub port: u16,
    pub playground: bool,
}

impl Default for GraphqlConfig {
    fn default() -> Self {
        Self {
            port: DEFAULT_PORT,
            playground: true,
        }
    }
}
