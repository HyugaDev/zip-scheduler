package com.flyzipline.main;

import java.util.ArrayList;
import java.util.List;

public class Scheduler {
    private final HospitalDirectory hospitalDirectory;
    private final int numZips;
    private final int maxPackagesPerZip;
    private final int zipSpeedMps;
    private final int zipMaxCumulativeRangeM;

    private final List<Order> unfulfilledOrders;

    public Scheduler(
            HospitalDirectory hospitalDirectory,
            int numZips,
            int maxPackagesPerZip,
            int zipSpeedMps,
            int zipMaxCumulativeRangeM
    ) {
        this.hospitalDirectory = hospitalDirectory;
        this.numZips = numZips;
        this.maxPackagesPerZip = maxPackagesPerZip;
        this.zipSpeedMps = zipSpeedMps;
        this.zipMaxCumulativeRangeM = zipMaxCumulativeRangeM;

        // Track which orders haven't been launched yet
        this.unfulfilledOrders = new ArrayList<>();
    }

    /**
     * Add a new order to our queue
     * <p>
     * Note: Called every time a new order arrives
     *
     * @param order the order just placed
     */
    public void queueOrder(Order order) {
        this.unfulfilledOrders.add(order);

        // TODO: Implement me
    }

    /**
     * Determines which flights should be launched right now. Each flight has an ordered list of Orders to serve.
     * <p>
     * Note: Will be called periodically (approximately once a minute).
     *
     * @param currentTime Seconds since midnight.
     * @return Flight objects that launch at this time.
     */
    public List<Flight> launchFlights(int currentTime) {
        // TODO: Implement me
        // You should remove any orders from `this.unfulfilled_orders` as you go
        return new ArrayList<>();
    }

    public List<Order> getUnfulfilledOrders() {
        return unfulfilledOrders;
    }
}
