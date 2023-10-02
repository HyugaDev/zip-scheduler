##
# You shouldn't need to modify this class
class Hospital
  attr_reader :name

  def initialize(name, north_m, east_m)
    @name = name
    @north_m = north_m
    @east_m = east_m
  end

  ##
  # Reads and processes a CSV file object that conforms to the hospital.csv schema defined in README.md.
  # @param [String] f CSV file object to read into a hash.
  # @return [Hash] Hospitals and their coordinates.
  def self.load_from_csv(f)
    CSV.read(f).map do |hospital_row|
      hospital_row.each(&:strip!)
      [hospital_row[0], Hospital.new(hospital_row[0], hospital_row[1].to_i, hospital_row[2].to_i)]
    end.to_h
  end

  def to_s
    "Hospital {name: #{@name}, north_m: #{@north_m}, east_m: #{@east_m}}"
  end
end
