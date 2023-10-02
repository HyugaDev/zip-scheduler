##
# You shouldn't need to modify this class
class Order
  attr_reader :time, :hospital, :priority

  def initialize(time, hospital, priority)
    @time = time
    @hospital = hospital
    @priority = priority
  end

  ##
  # Reads and processes a CSV file object that conforms to the orders.csv schema defined in README.md.
  # Ok to assume the orders are sorted.
  # @param [String] f CSV file object to read into an array.
  # @param [Hash] hospitals Mapping of hospital name to Hospital objects
  # @return [Array] Order objects.
  def self.load_from_csv(f, hospitals)
    CSV.read(f).map do |order_row|
      order_row.each(&:strip!)
      Order.new(
        order_row[0].to_i,
        hospitals[order_row[1]],
        order_row[2]
      )
    end
  end

  def to_s
    "Order {time: #{@time}, hospital: #{@hospital}, priority: #{@priority}}"
  end
end
