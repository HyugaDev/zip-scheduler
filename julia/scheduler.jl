# Everything in this file should be edited as needed
Base.@kwdef mutable struct ZipScheduler
    "Dictionary of hospital names to `Hospital` instances"
    hospital_directory::HospitalDirectory = HospitalDirectory()

    "Queue of unfulfilled orders"
    unfulfilled_orders::Vector{Order} = Order[]

    "Each Nest has this many Zips"
    num_zips::Int = 10

    """
    Each Zip can carry between 1 and this many packages per flight
    Note: a Zip can deliver more than 1 package per stop
    """
    max_packages_per_zip::Int = 3

    "Zips fly a constant groundspeed (m/s)"
    zip_speed_mps::Int = 30

    "Zips can fly a total roundtrip distance (m)"
    zip_max_cumulative_range_m::Int = 160 * 1000
end

"""
    queue_order!(scheduler::ZipScheduler, order::Order)

Add a new order to the queue
"""
function queue_order!(scheduler::ZipScheduler, order::Order)
    push!(scheduler.unfulfilled_orders, order)

    # TODO: Implement me!
    return nothing
end

"""
    launch_flights!(scheduler::ZipScheduler, current_time::Int)

Return a list of which flights should be launched right now
"""
function launch_flights!(scheduler::ZipScheduler, current_time::Int)
    # TODO: Implement me!
    # NOTE: Remove orders from `scheduler.unfulfilled_orders` as you go
    return Flight[]
end
