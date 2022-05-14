use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::order::entities::{Buyer, Product};
use crate::domain::order::error::OrderError;

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct Order {
    pub id: String,
    pub buyer: Buyer,
    pub state: OrderState,
    // pub total_gross_amount: u32,
    // pub total_net_amount: u32,
    pub products: Vec<Product>,
    pub created_on: DateTime<Utc>,
    pub is_archived: bool,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub enum OrderState {
    InCart,
    Confirmed,
    Processing,
    Completed,
    Attention,
    Canceled,
    Returned,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub enum OrderStateInput {
    Cancel,
    Confirm,
    FailDelivery,
    FailPayment,
    FinishPaymentsAndDeliveries,
    Return,
    SolveFailures,
    StartDeliveries,
    StartPayments,
}

impl Order {
    pub fn add_product(
        &mut self,
        product_id: String,
        vendor_id: String,
        name: String,
        slug: String,
        currency: String,
        attachment: String,
        attributes: Value,
    ) {
        self.products.push(Product::new(
            product_id, vendor_id, name, slug, currency, attachment, attributes,
        ))
    }

    pub fn get_product_or_error(&self, product_id: String) -> Result<&Product, OrderError> {
        self.get_product(product_id)
            .ok_or(OrderError::ProductNotFoundError)
    }

    pub fn get_product(&self, product_id: String) -> Option<&Product> {
        for product in self.products.iter() {
            if product.id == product_id {
                return Some(product);
            }
        }
        None
    }

    pub fn get_product_as_mut(&mut self, product_id: String) -> Option<&mut Product> {
        for product in self.products.iter_mut() {
            if product.id == product_id {
                return Some(product);
            }
        }
        None
    }

    pub fn transition(&mut self, input: OrderStateInput) -> Result<(), OrderError> {
        self.state = match (&self.state, &input) {
            // initial state
            (OrderState::InCart, OrderStateInput::Confirm) => OrderState::Confirmed,
            // normal flow
            (OrderState::Confirmed, OrderStateInput::StartPayments) => OrderState::Processing,
            (OrderState::Confirmed, OrderStateInput::StartDeliveries) => OrderState::Processing,
            (OrderState::Processing, OrderStateInput::FinishPaymentsAndDeliveries) => {
                OrderState::Completed
            }
            // cancellation flow
            (OrderState::Confirmed, OrderStateInput::Cancel) => OrderState::Canceled,
            (OrderState::Processing, OrderStateInput::Cancel) => OrderState::Canceled,
            (OrderState::Attention, OrderStateInput::Cancel) => OrderState::Canceled,
            // attention flow
            (OrderState::Confirmed, OrderStateInput::FailDelivery) => OrderState::Attention,
            (OrderState::Confirmed, OrderStateInput::FailPayment) => OrderState::Attention,
            (OrderState::Processing, OrderStateInput::FailDelivery) => OrderState::Attention,
            (OrderState::Processing, OrderStateInput::FailPayment) => OrderState::Attention,
            (OrderState::Attention, OrderStateInput::SolveFailures) => OrderState::Processing,
            // return flow
            (OrderState::Processing, OrderStateInput::Return) => OrderState::Returned,
            (OrderState::Attention, OrderStateInput::Return) => OrderState::Returned,
            _ => Err(OrderError::TransitionError(format!(
                "Cannot transition from {:?} through {:?}",
                self.state, input
            )))?,
        };
        Ok(())
    }
}

impl Default for Order {
    fn default() -> Self {
        Self {
            id: Default::default(),
            buyer: Default::default(),
            state: OrderState::InCart,
            // total_gross_amount: Default::default(),
            // total_net_amount: Default::default(),
            products: Default::default(),
            created_on: Utc::now(),
            is_archived: false,
        }
    }
}
