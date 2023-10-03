require './lib/constants'
require './lib/hospital'
require './lib/order'
require './lib/scheduler'
require './lib/runner.rb'
require './lib/flight.rb'

class Runner
  include Constants
  attr_reader :orders, :hospitals, :scheduler

  def initialize(
    hospitals_path:,
    orders_path:
  )
    @hospitals = Hospital.load_from_csv(hospitals_path)
    @orders = Order.load_from_csv(orders_path, @hospitals)

    @scheduler = ZipScheduler.new(
      hospitals,
      NUM_ZIPS,
      MAX_PACKAGES_PER_ZIP,
      ZIP_SPEED_MPS,
      ZIP_MAX_CUMULATIVE_RANGE_M
    )
  end

  def run
    (time_of_next_order..SEC_PER_DAY).each do |sec_since_midnight|
      queue_pending_orders(sec_since_midnight)

      if sec_since_midnight % 60 == 0
        update_launch_flights(sec_since_midnight)
      end
    end

    puts("#{scheduler.unfulfilled_orders.length} unfulfilled orders at the end of the day")
  end

  private

  def queue_pending_orders(sec_since_midnight)

    until no_orders_remaining || next_order_not_due(sec_since_midnight)
      order = orders.shift
      puts(
        "[#{sec_since_midnight}] #{order.priority} order received to #{order.hospital.name}",
        )
      scheduler.queue_order(order)
    end
  end

  def update_launch_flights(sec_since_midnight)
    flights = scheduler.launch_flights(sec_since_midnight)
    unless flights.empty?
      puts("[#{sec_since_midnight}] Scheduling flights:")
      flights.each { |flight| puts(flight) }
      puts("---------------------------------------------")
    end
    scheduler.check_completed_flights(sec_since_midnight, flights)
  end

  def time_of_next_order
    orders[0].time unless orders.empty?
  end

  def next_order_not_due(sec_since_midnight)
    time_of_next_order != sec_since_midnight
  end

  def no_orders_remaining
    orders.empty?
  end
end
