class ZipScheduler
  attr_reader :unfulfilled_orders

  def initialize(
    hospitals,
    num_zips,
    max_packages_per_zip,
    zip_speed_mps,
    max_cumulative_m
  )
    @hospitals = hospitals
    @num_zips = num_zips
    @max_packages_per_zip = max_packages_per_zip
    @zip_speed_mps = zip_speed_mps
    @zip_max_cumulative_range_m = max_cumulative_m

    # Track which orders haven't been launched yet
    @unfulfilled_orders = []
  end

  ##
  # Add a new order to our queue.
  #
  # Note: Called every time a new order arrives.
  #
  # @param [Order] order The order just placed.
  def queue_order(order)
    @unfulfilled_orders.append(order)

    # TODO: implement me
  end

  ##
  # Determines which flights should be launched right now. Each flight has an ordered list of
  # Orders to serve.
  #
  # Note: Will be called periodically (approximately once a minute).
  #
  # @param [Integer] current_time Seconds since midnight.
  # @return [Array] Flight objects that launch at this time.
  def launch_flights(current_time)
    # TODO: implement me!
    # You should remove any orders from `self.unfulfilled_orders` as you go
    []
  end
end
