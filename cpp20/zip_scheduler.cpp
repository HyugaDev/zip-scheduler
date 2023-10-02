// Copyright 2021 Zipline International Inc. All rights reserved.

#include "zip_scheduler.h"

namespace zipline
{
void ZipScheduler::QueueOrder(const Order &order)
{
    std::cout << "Queuing order:\n\t" << order.received_time() << "\n\t" << order.hospital().name() << "\n\t"
              << Order::PriorityToString(order.priority()) << std::endl;
    // TODO implement
}

std::vector<Flight> ZipScheduler::LaunchFlights(Timestamp current_time)
{
    std::cout << "Asking for flights at " << current_time << std::endl;
    // TODO implement

    return {};
}
}  // namespace zipline
