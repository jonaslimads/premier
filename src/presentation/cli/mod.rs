use clap::{Parser, Subcommand};
use serde_json::Value;

pub mod config;
mod parse;

pub use crate::presentation::startup;
pub use config::Config;
pub use parse::parse;

#[derive(Debug, Parser)]
#[clap(author, version, about, long_about = None)]
pub struct Cli {
    #[clap(subcommand)]
    pub mode: Mode,

    #[clap(short, long)]
    pub config: Option<String>,
}

#[derive(Debug, Subcommand)]
pub enum Mode {
    Serve,
    Replay { aggregate: String },
    Command { command: String, payload: Value },
    Query { query: String, id: String },
}

impl Cli {
    pub fn parse_config(&self) -> Config {
        Config::parse(self.config.clone())
    }
}
