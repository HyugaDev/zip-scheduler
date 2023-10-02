// Copyright 2021 Zipline International Inc. All rights reserved.
#pragma once

#include <vector>

#include "flight.h"
#include "order.h"
#include "util.h"

namespace zipline
{
class ZipScheduler
{
   public:
    // Add an order to the queue to potentially launch at the next time LaunchFlights is called.
    void QueueOrder(const Order &order);

    // Returns an ordered list of flights to launch.
    std::vector<Flight> LaunchFlights(Timestamp current_time);
};
}  // namespace zipline
