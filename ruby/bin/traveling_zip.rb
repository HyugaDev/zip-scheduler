require './lib/constants'
require './lib/hospital'
require './lib/order'
require './lib/scheduler'
require './lib/runner.rb'
require 'csv'

##
# Run me from ./ruby
# ruby ./bin/traveling_zip.rb
if __FILE__ == $0
  root_dir = File.join(
    [
      File.expand_path("../..", __dir__),
      'inputs'
    ]
  )
  hospitals_path = File.join(root_dir, "hospitals.csv")
  orders_path = File.join(root_dir, "orders.csv")

  runner = Runner.new(
    hospitals_path: hospitals_path,
    orders_path: orders_path,
  )
  runner.run
end
