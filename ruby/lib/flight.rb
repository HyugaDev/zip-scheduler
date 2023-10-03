class Flight
  attr_accessor :launch_time, :orders, :busy_time
  
  def initialize(launch_time, orders, busy_time)
    @launch_time = launch_time
    @orders = orders
    @busy_time = busy_time
  end
  def to_s
    hospitals = @orders.map { |order| order.hospital.name }
    hospitals.join("->")
  end
end
