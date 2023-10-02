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
    @unfulfilled_orders.sort_by! { |o| [o.priority == 'Emergency' ? 0 : 1, o.time] }
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
    flights_to_launch = []

    # Loop through available Zips
    (1..@num_zips).each do |zip_id|
      current_flight_orders = []
      current_range = 0.0

      @unfulfilled_orders.each do |order|
        # Calculate the distance to the hospital for the current order
        distance_to_hospital = calculate_distance_to_hospital(order.hospital)

        # Check if the Zip can accommodate the order and stay within its range
        if (current_flight_orders.length < @max_packages_per_zip) && (current_range + distance_to_hospital <= @zip_max_cumulative_range_m)
          current_flight_orders.append(order)
          current_range += distance_to_hospital
        end
      end

      # Create a new Flight if there are orders for this Zip
      if current_flight_orders.any?
        flights_to_launch.append(Flight.new(current_time, current_flight_orders))
        current_flight_orders.each { |order| @unfulfilled_orders.delete(order) }
      end
    end
    # p @flights_to_launch
    flights_to_launch
  end

  private

  # Calculate the distance from the Nest to the hospital
  def calculate_distance_to_hospital(hospital)
    north_diff = hospital.north_m
    east_diff = hospital.east_m
    Math.sqrt(north_diff**2 + east_diff**2)
  end
end
