# The two acceptable priorities
@enum Priority EMERGENCY RESUPPLY

Base.@kwdef struct Hospital
    name::String
    north_m::Int
    east_m::Int
end

# Just an alias for a String => Hospital dictionary
const HospitalDirectory = Dict{String, Hospital}

Base.@kwdef struct Order
    time::Int
    hospital::Hospital
    priority::Priority = EMERGENCY
end

# A launched flight
# NOTE: Modify this as needed
Base.@kwdef struct Flight
    launch_time::Int
    orders::Vector{Order} = Order[]
end
