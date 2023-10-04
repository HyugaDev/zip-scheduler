# spec/zip_scheduler_spec.rb

require_relative '../lib/scheduler' # Adjust the path as needed
require_relative '../lib/hospital' # Adjust the path as needed
require_relative '../lib/order' # Adjust the path as needed
require_relative '../lib/flight' # Adjust the path as needed
require_relative '../lib/constants'
require 'rspec'

describe ZipScheduler do
  # Initialize hospitals, orders, and scheduler for testing
  let(:hospitals) { [Hospital.new('Hospital A', 0.5, 0.9), Hospital.new('Hospital B', 10, 10)] }
  let(:orders) { [Order.new('Emergency', hospitals[0], Time.now), Order.new('Resupply', hospitals[1], Time.now)] }
  let(:scheduler) do
    described_class.new(
      hospitals,
      Constants::NUM_ZIPS,
      Constants::MAX_PACKAGES_PER_ZIP,
      Constants::ZIP_SPEED_MPS,
      Constants::ZIP_MAX_CUMULATIVE_RANGE_M
    )
  end

  describe '#launch_flights' do
    context 'when there are orders to fulfill' do
      it 'launches flights and fulfills orders' do
        # Add orders to the scheduler
        scheduler.queue_order(orders[0])
        scheduler.queue_order(orders[1])

        # Set a current time for testing
        current_time = 3600 # 1 hour since midnight

        # Call the launch_flights method
        flights = scheduler.launch_flights(current_time)

        # Expectations
        expect(flights).not_to be_empty
        expect(scheduler.unfulfilled_orders).to be_empty
      end
    end

    context 'when there are no orders to fulfill' do
      it 'does not launch flights' do
        # Set a current time for testing
        current_time = 3600 # 1 hour since midnight

        # Call the launch_flights method
        flights = scheduler.launch_flights(current_time)

        # Expectations
        expect(flights).to be_empty
      end
    end

    context 'when there are orders of different priorities' do
      it 'launches emergency orders before resupply orders' do
        # Add orders with different priorities to the scheduler
        emergency_order = Order.new('Emergency', hospitals[0], Time.now)
        resupply_order = Order.new('Resupply', hospitals[1], Time.now)
        scheduler.queue_order(resupply_order)
        scheduler.queue_order(emergency_order)

        # Set a current time for testing
        current_time = 3600 # 1 hour since midnight

        # Call the launch_flights method
        flights = scheduler.launch_flights(current_time)

        # Expectations
        expect(flights.length).to eq(1)
        expect(flights[0].orders).to eq([emergency_order, resupply_order])
      end
    end

    context 'when there are orders with different distances' do
      it 'optimizes flight routes to minimize total distance' do
        # Create hospitals with different distances from a single origin
        hospitals = [
          Hospital.new('Hospital A', 0.5, 0.9),
          Hospital.new('Hospital B', 1.0, 1.0),
          Hospital.new('Hospital C', 2.0, 2.0)
        ]

        # Add orders to the scheduler
        orders = hospitals.map { |hospital| Order.new('Emergency', hospital, Time.now) }
        orders.each { |order| scheduler.queue_order(order) }

        # Set a current time for testing
        current_time = 3600 # 1 hour since midnight

        # Call the launch_flights method
        flights = scheduler.launch_flights(current_time)

        # Expectations
        expect(flights.length).to eq(1)
        # Ensure that the orders are sorted in a way that minimizes total distance
        expected_order_names = ['Hospital A', 'Hospital B', 'Hospital C']
        actual_order_names = flights[0].orders.map { |order| order.hospital.name }
        expect(actual_order_names).to eq(expected_order_names)
      end
    end
  end
end
