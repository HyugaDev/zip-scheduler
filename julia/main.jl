include("constants.jl")
include("data_types.jl")
include("data_loading.jl")
include("scheduler.jl")
include("runner.jl")

## Run the provided CSVs
root_dir = joinpath(@__DIR__, "..", "inputs")
hospitals_path = joinpath(root_dir, "hospitals.csv")
orders_path = joinpath(root_dir, "orders.csv")

runner = Runner(hospitals_path, orders_path)
run!(runner)
