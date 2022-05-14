use serde::{Deserialize, Serialize};

use crate::domain::product::entities::{Allocation, Order, Warehouse};

#[derive(Clone, Debug, Default, Deserialize, Eq, PartialEq, Serialize)]
pub struct Stock {
    pub warehouse: Warehouse,
    pub quantity: u32,
    pub allocations: Vec<Allocation>,
}

impl Stock {
    pub fn new(warehouse_id: String, quantity: u32) -> Self {
        Self {
            warehouse: Warehouse::new(warehouse_id),
            quantity,
            allocations: vec![],
        }
    }

    pub fn has_enough_quantity_for_allocation(&self, requested_quantity: u32) -> bool {
        requested_quantity < self.get_available_quantity()
    }

    pub fn get_available_quantity(&self) -> u32 {
        self.quantity - self.get_allocated_quantity()
    }

    pub fn get_allocated_quantity(&self) -> u32 {
        self.allocations
            .iter()
            .fold(0u32, |sum, allocation| sum + allocation.quantity)
    }

    pub fn allocate_quantity(&mut self, order_id: String, quantity: u32) {
        self.allocations.push(Allocation {
            order: Order::new(order_id),
            quantity,
        });
    }
}
