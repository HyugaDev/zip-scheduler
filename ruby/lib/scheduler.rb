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
    @unfulfilled_orders = []
    @zips_status = Array.new(num_zips, false)
  end

  def queue_order(order)
    @unfulfilled_orders.append(order)
    @unfulfilled_orders.sort_by! { |o| [o.priority == 'Emergency' ? 0 : 1, o.time] }
  end

  def launch_flights(current_time, time_until_next_order)
    flights_to_launch = []
    @num_zips.times do |zip_id|
      next if @zips_status[zip_id - 1]
      current_flight_orders = []
      current_range = 0.0

      @unfulfilled_orders.each do |order|
        distance_to_hospital = calculate_distance_to_hospital(order.hospital)

        if (current_flight_orders.length < @max_packages_per_zip) && (current_range + distance_to_hospital <= @zip_max_cumulative_range_m)
          current_flight_orders.append(order)
          current_range += distance_to_hospital
        end
      end

      if current_flight_orders.any?
        flight_time = (current_range / @zip_speed_mps).to_i
        flight = Flight.new(current_time, current_flight_orders, flight_time)
        check_busy_flight(time_until_next_order, flight, zip_id)
        flights_to_launch << flight
        current_flight_orders.each { |order| @unfulfilled_orders.delete(order) }
        
        @zips_status[zip_id] = true
        flight.busy_time = flight_time
      end
    end

    check_completed_flights(current_time, flights_to_launch)
    flights_to_launch
  end

  def check_completed_flights(current_time, flights_to_launch)
    flights_to_launch.each do |flight|
      next unless flight.busy_time
  
      flight.busy_time -= 1
      if flight.busy_time.zero?
        @zips_status[flight.zip_id] = false
      end
    end
  
    flights_to_launch.delete_if { |flight| flight.busy_time.zero? }
  end

  private

  def calculate_distance_to_hospital(hospital)
    north_diff = hospital.north_m
    east_diff = hospital.east_m
    Math.sqrt(north_diff**2 + east_diff**2)
  end

  def check_busy_flight(time_until_next_order, flight, zip_id)
    if flight.busy_time
      flight.busy_time -= time_until_next_order unless time_until_next_order.nil?
      flight.busy_time = 0 if flight.busy_time.negative?
    end

    if flight.busy_time.zero?
      @zips_status[zip_id] = false
    end
  end
end
