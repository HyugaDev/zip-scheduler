"""
    Runner(; scheduler::ZipScheduler, orders::Vector{Order})
    Runner(hospitals_path::AbstractString, orders_path::AbstractString; kwargs...)

A simulation runner that can playback order CSVs as if the day were progressing.

The constructor will typically be called by specifying a `hospitals_path` and
`orders_path` where the hospital and order CSV files are stored, respectively. This
contstructor method takes in additional keyword arguments for defaults that will be
passed into the `ZipScheduler` constructor.

An additional constructor method allows the `scheduler` and `orders` to be passed
in directly by keyword.
"""
Base.@kwdef mutable struct Runner
    scheduler::ZipScheduler
    orders::Vector{Order} = []
end
function Runner(hospitals_path::AbstractString, orders_path::AbstractString; kwargs...)
    hospitals = load_from_csv(Hospital, hospitals_path)
    hospital_directory = Dict(hospital.name => hospital for hospital in hospitals)

    orders = load_from_csv(Order, orders_path, hospital_directory)

    scheduler =  ZipScheduler(;
        hospital_directory = hospital_directory,
        unfulfilled_orders = Order[],
        kwargs...,
    )

    return Runner(
        scheduler = scheduler,
        orders = orders,
    )
end

"""
    run!(runner::Runner)

Run the simulator. This assumes any orders not fulfilled by the end of the day are failed.

Note:
    This is a barebones implementation that should help get you
    started. You probably want to expand the runner's capabilities.
"""
function run!(runner::Runner)
    # Simulate time going from the first order time, until the end of the
    # day, in 1 minute increments
    for sec_since_midnight in first(runner.orders).time:SEC_PER_DAY
        # Find and queue pending orders.
        _queue_pending_orders!(runner, sec_since_midnight)

        if sec_since_midnight % 60 == 0
            # Once a minute, poke the flight launcher
            _update_launch_flights!(runner, sec_since_midnight)
        end
    end

    # These orders were not launched by midnight
    println(
        length(runner.scheduler.unfulfilled_orders),
        " unfulfilled orders at the end of the day",
    )
    return nothing
end

function _update_launch_flights!(runner::Runner, sec_since_midnight)
    flights = launch_flights!(runner.scheduler, sec_since_midnight)
    if !isempty(flights)
        println("[$sec_since_midnight] Scheduling flights:")
        for flight in flights
            println("  ", flight)
        end
    end
    return nothing
end

function _queue_pending_orders!(runner::Runner, sec_since_midnight)
    (; scheduler, orders) = runner
    while !isempty(orders) && first(orders).time == sec_since_midnight
        # Find any orders that were placed during this second and tell
        # our scheduler about them
        order = popfirst!(orders)
        println(
            "[$sec_since_midnight] ",
            string(order.priority) |> titlecase,
            " order received to $(order.hospital.name)",
        )
        queue_order!(scheduler, order)
    end
    return nothing
end
