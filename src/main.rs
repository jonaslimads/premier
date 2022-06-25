#![forbid(unsafe_code)]
#![deny(clippy::all)]

mod application;
mod commons;
mod domain;
mod infrastructure;
mod presentation;

use crate::presentation::cli;

#[tokio::main]
async fn main() -> Result<(), presentation::PresentationError> {
    env_logger::init();

    match cli::parse().await {
        Err(error) => Err(error),
        Ok(Some(result)) => {
            println!("{}", result);
            Ok(())
        }
        Ok(None) => Ok(()),
    }
}

// SET FOREIGN_KEY_CHECKS=0;
// TRUNCATE TABLE store_event;
// TRUNCATE TABLE product_event;
// TRUNCATE TABLE store_product;
// TRUNCATE TABLE store_product_view;
// SET FOREIGN_KEY_CHECKS=1;
// SELECT GET_RANDOM_STORE_EVENT_AGGREGATE_ID(100000000000, 1000000000000-1);

// select premier.get_random_product_event_aggregate_id(100000000000, 1000000000000-1);

// select * from store_event ve order by json_extract(metadata, '$.s') desc;

// ./target/debug/premier command store AddStore '{"id":"931763989041","name":"My Store","attributes":{}}'
// ./target/debug/premier command store ArchiveStore '{"id":"931763989041"}'
// ./target/debug/premier command store UnarchiveStore '{"id":"931763989041"}'
// ./target/debug/premier command product AddProduct '{"id":"582696182822","store_id":"931763989041","name":"USB stick","description":"","slug":"usb-stick","currency":"USD","attachments":[],"attributes":{}}'
// ./target/debug/premier command product AddProductVariant '{"id":"582696182822","variant_id":"931763989041","sku":"USB-1","price":1200,"attachments":[],"attributes":{}}'
