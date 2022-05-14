#![forbid(unsafe_code)]
#![deny(clippy::all)]

mod application;
mod domain;
mod infrastructure;
mod presentation;

// idea for name: Lilo

use crate::presentation::cli;

#[tokio::main]
async fn main() {
    env_logger::init();

    match cli::parse().await {
        Err(error) => {
            log::error!("{:?}", error);
        }
        Ok(Some(result)) => {
            println!("{}", result);
        }
        Ok(None) => {}
    }
}

// select premier.get_random_product_event_aggregate_id(100000000000, 1000000000000-1);

// select * from vendor_event ve order by json_extract(metadata, '$.s') desc;

// ./target/debug/premier command vendor AddVendor '{"id":"931763989041","name":"My Store","attributes":{}}'
// ./target/debug/premier command vendor ArchiveVendor '{"id":"931763989041"}'
// ./target/debug/premier command vendor UnarchiveVendor '{"id":"931763989041"}'
// ./target/debug/premier command product AddProduct '{"id":"582696182822","vendor_id":"931763989041","name":"USB stick","description":"","slug":"usb-stick","currency":"USD","attachments":[],"attributes":{}}'
// ./target/debug/premier command product AddProductVariant '{"id":"582696182822","variant_id":"931763989041","sku":"USB-1","price":1200,"attachments":[],"attributes":{}}'
