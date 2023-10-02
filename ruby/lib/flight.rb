##
# Feel free to extend as needed
class Flight
  def initialize(launch_time, orders)
    @launch_time = launch_time
    @orders = orders
  end

  def to_s
    hospitals = @orders.map { |order| order.hospital.name }
    hospitals.join("->")
  end
end
