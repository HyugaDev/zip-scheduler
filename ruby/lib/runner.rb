require './lib/constants'
require './lib/hospital'
require './lib/order'
require './lib/scheduler'
require './lib/runner.rb'

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

  ##
  # Run the simulator.
  # This assumes any orders not fulfilled by the end of the day are failed.
  #
  # Note: This is a barebones implementation that should help get you started. You probably want
  # to expand the runner's capabilities.
  def run
    # Simulate time going from the first order time, until the end of the day,
    # in 1 minute increments
    (time_of_next_order..SEC_PER_DAY).each do |sec_since_midnight|
      # Find and queue pending orders.
      queue_pending_orders(sec_since_midnight)

      if sec_since_midnight % 60 == 0
        # Once a minute, poke the flight launcher
        update_launch_flights(sec_since_midnight)
      end
    end

    # These orders were not launched by midnight
    puts("#{scheduler.unfulfilled_orders.length} unfulfilled orders at the end of the day")
  end

  private
  ##
  # Grab an order from the queue and queue it.
  #
  # @param [Integer] sec_since_midnight Seconds since midnight.
  def queue_pending_orders(sec_since_midnight)

    until no_orders_remaining || next_order_not_due(sec_since_midnight)
      order = orders.shift
      puts(
        "[#{sec_since_midnight}] #{order.priority} order received to #{order.hospital.name}",
        )
      scheduler.queue_order(order)
    end
  end

  ##
  # Schedule which flights should launch now.
  #
  # @param [Integer] sec_since_midnight Seconds since midnight.
  def update_launch_flights(sec_since_midnight)
    flights = scheduler.launch_flights(sec_since_midnight)
    unless flights.empty?
      puts("[#{sec_since_midnight}] Scheduling flights:")
      flights.each { |flight| puts(flight) }
    end
  end

  def time_of_next_order
    orders[0].time
  end

  def next_order_not_due(sec_since_midnight)
    time_of_next_order != sec_since_midnight
  end

  def no_orders_remaining
    orders.empty?
  end
end
