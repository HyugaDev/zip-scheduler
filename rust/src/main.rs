use csv::ReaderBuilder;
use serde::Deserialize;
use std::error::Error;

/// The number of Zips at each nest.
const NUM_ZIPS: usize = 10;

/// A Zip can carry between 1 and this many packages per flight.
/// Note: a Zip can deliver more than 1 package per stop.
const MAX_PACKAGES_PER_ZIP: usize = 3;

/// The (constant) ground speed all Zips fly at (in m/s).
const ZIP_SPEED_MPS: u32 = 30;

/// The farthest total roundtrip distance a Zip can fly (in m).
const ZIP_MAX_CUMULATIVE_RANGE_M: u32 = 160 * 1000; // 160 km -> meters

// The following structures describe the input data schema.
// You shouldn't need to modify them.

#[derive(Debug, Deserialize)]
struct Hospital {
    name: String,
    north_m: i32,
    east_m: i32,
}

#[derive(Debug, Deserialize)]
struct Order {
    time: u32,
    hospital: String,
    priority: OrderPriority,
}

#[derive(Debug, Deserialize)]
enum OrderPriority {
    Emergency,
    Resupply,
}

/// Represents a launched flight.
/// Feel free to extend.
#[derive(Debug)]
struct Flight {
    launch_time: u32,
    orders: Vec<Order>,
}

/// This is the component we're like you to implement.
struct ZipScheduler {
    hospitals: Vec<Hospital>,
    num_zips: usize,
    max_packages_per_zip: usize,
    zip_speed_mps: u32,
    zip_max_cumulative_range_m: u32,

    /// Tracks whcih orders haven't been launched yet.
    unfulfilled_orders: Vec<Order>,
}

impl ZipScheduler {
    /// Add a new order to our queue.
    ///
    /// Note: this function is called every time a new order arrives.
    fn queue_order(&mut self, order: Order) {
        self.unfulfilled_orders.push(order);

        // Implement me!
        todo!()
    }

    /// Returns a list of flights which should be launched right now.
    ///
    /// Each flight has an ordered list of Orders to serve.
    ///
    /// Note: will be called periodically (approximately once a minute).
    ///
    /// `current_time` refers to seconds since midnight.
    fn launch_flights(&mut self, current_time: u32) -> Vec<Flight> {
        // Implement me!
        // You should remove orders from self.unfulfilled_orders as you go.
        todo!()
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    let hospitals: Result<Vec<_>, _> = ReaderBuilder::new()
        .has_headers(false)
        .trim(csv::Trim::All)
        .from_path("../inputs/hospitals.csv")?
        .deserialize()
        .collect();

    let mut scheduler = ZipScheduler {
        hospitals: hospitals?,
        num_zips: NUM_ZIPS,
        max_packages_per_zip: MAX_PACKAGES_PER_ZIP,
        zip_speed_mps: ZIP_SPEED_MPS,
        zip_max_cumulative_range_m: ZIP_MAX_CUMULATIVE_RANGE_M,
        unfulfilled_orders: vec![],
    };

    let orders: Result<Vec<_>, _> = ReaderBuilder::new()
        .has_headers(false)
        .trim(csv::Trim::All)
        .from_path("../inputs/orders.csv")?
        .deserialize()
        .collect();
    let mut orders = orders?;
    orders.reverse();

    // Simulate time advancing forward until the end of the day.
    const SEC_PER_DAY: u32 = 24 * 60 * 60;
    let start_time = orders.last().map_or(0, |o: &Order| o.time);
    for current_time in start_time..SEC_PER_DAY {
        // Find and queue new orders.
        while let Some(order) = orders.last() {
            if order.time > current_time {
                break;
            }
            println!(
                "[{}] {:?} order received to {}",
                current_time, order.priority, order.hospital
            );
            scheduler.queue_order(orders.pop().unwrap());
        }

        // Once a minute, poke the flight launcher.
        if current_time % 60 == 0 {
            let flights = scheduler.launch_flights(current_time);
            if !flights.is_empty() {
                println!("[{}] Scheduling flights:", current_time);
                for flight in flights {
                    println!("\t{:?}", flight);
                }
            }
        }
    }

    println!(
        "{} unfulfilled orders at the end of the day",
        scheduler.unfulfilled_orders.len()
    );

    Ok(())
}
