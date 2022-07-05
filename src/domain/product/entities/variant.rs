use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::domain::product::entities::{Allocation, PaymentOption, Stock};
use crate::domain::product::ProductError;

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Variant {
    pub id: String,
    pub sku: String,
    pub price: u32,
    pub attachments: Vec<String>,
    pub attributes: Value,
    pub is_published: bool,
    pub stocks: Vec<Stock>,
    pub payment_options: Vec<PaymentOption>,
}

impl Variant {
    pub fn new(
        id: String,
        sku: String,
        price: u32,
        attachments: Vec<String>,
        attributes: Value,
    ) -> Self {
        Self {
            id,
            sku,
            price,
            attachments,
            attributes,
            ..Default::default()
        }
    }

    pub fn get_available_stock_or_error(&self, quantity: u32) -> Result<&Stock, ProductError> {
        self.get_available_stock(quantity)
            .ok_or(ProductError::WarehouseWithEnoughStockNotFound)
    }

    fn get_available_stock(&self, quantity: u32) -> Option<&Stock> {
        for stock in self.stocks.iter() {
            if stock.has_enough_quantity_for_allocation(quantity) {
                return Some(stock);
            }
        }
        None
    }

    pub fn has_stock_from_warehouse(&self, warehouse_id: String) -> bool {
        for stock in self.stocks.iter() {
            if stock.warehouse.id == warehouse_id {
                return true;
            }
        }
        false
    }

    pub fn get_stock_by_warehouse_id_as_mut_ref(
        &mut self,
        warehouse_id: String,
    ) -> Option<&mut Stock> {
        for stock in self.stocks.iter_mut() {
            if stock.warehouse.id == warehouse_id {
                return Some(stock);
            }
        }
        None
    }

    pub fn has_allocation_by_order_id(&self, order_id: String) -> bool {
        self.get_allocated_quantity_by_order_id(order_id) > 0
    }

    pub fn get_allocated_quantity_by_order_id(&self, order_id: String) -> u32 {
        match self.get_stock_allocation_by_order_id(order_id) {
            Some((_, allocation)) => allocation.quantity,
            None => 0,
        }
    }

    pub fn get_stock_allocation_by_order_id(
        &self,
        order_id: String,
    ) -> Option<(&Stock, &Allocation)> {
        for stock in self.stocks.iter() {
            if let Some(index) = stock
                .allocations
                .iter()
                .position(|allocation| allocation.order.id == order_id)
            {
                return Some((stock, &stock.allocations[index]));
            }
        }
        None
    }

    pub fn remove_allocation_by_order_id(&mut self, order_id: String) -> Option<&mut Stock> {
        for stock in self.stocks.iter_mut() {
            if let Some(index) = stock
                .allocations
                .iter()
                .position(|allocation| allocation.order.id == order_id)
            {
                stock.allocations.remove(index);
                return Some(stock);
            }
        }
        None
    }

    pub fn add_stock(&mut self, warehouse_id: String, quantity: u32) {
        self.stocks.push(Stock::new(warehouse_id, quantity));
    }

    pub fn remove_stock(&mut self, warehouse_id: String) {
        if let Some(index) = self
            .stocks
            .iter()
            .position(|stock| stock.warehouse.id == warehouse_id)
        {
            self.stocks.remove(index);
        }
    }
}
