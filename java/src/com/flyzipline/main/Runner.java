package com.flyzipline.main;

import java.util.List;

/**
 * A simulation runner that can playback order CSVs as if the day were progressing.
 */
public class Runner {
    private final List<Order> orders;
    private final Scheduler scheduler;

    public Runner(
            String hospitalsPath,
            String ordersPath
    ) {
        List<Hospital> hospitals = Hospital.readCSV(hospitalsPath);
        HospitalDirectory hospitalDirectory = new HospitalDirectory(hospitals);
        this.orders = Order.readCSV(ordersPath, hospitalDirectory);
        this.scheduler = new Scheduler(
                hospitalDirectory,
                Zip.NUM_ZIPS,
                Zip.MAX_PACKAGES_PER_ZIP,
                Zip.ZIP_SPEED_MPS,
                Zip.ZIP_MAX_CUMULATIVE_RANGE_M
        );
    }

    /**
     * Run the simulator. This assumes any orders not fulfilled by the end of the day are failed.
     * <p>
     * Note:
     * This is a barebones implementation that should help get you
     * started. You probably want to expand the runner's capabilities.
     */
    public void run() {
        // Simulate time going from the first order time, until the end of the
        // day, in 1 minute increments
        int sec_per_day = 24 * 60 * 60;
        for (int secSinceMidnight = this.orders.get(0).time(); secSinceMidnight < sec_per_day; secSinceMidnight++) {
            this.queuePendingOrder(secSinceMidnight);
            if ((secSinceMidnight % 60) == 0) {

                // Once a minute, poke the flight launcher
                this.updateLaunchFlights(secSinceMidnight);
            }
        }
        // These orders were not launched by midnight
        System.out.printf(
                "%d unfulfilled orders at the end of the day%n",
                this.scheduler.getUnfulfilledOrders().size()
        );
    }

    /**
     * Grab an order from the queue and queue it.
     *
     * @param secSinceMidnight Seconds since midnight.
     */
    private void queuePendingOrder(int secSinceMidnight) {
        while (this.orders.size() > 0 && this.orders.get(0).time() == secSinceMidnight) {
            Order order = this.orders.get(0);
            this.orders.remove(0);
            System.out.printf(
                    "[%d] %s order received to %s%n",
                    secSinceMidnight,
                    order.priority().toString(),
                    order.hospital()
            );
            this.scheduler.queueOrder(order);
        }
    }

    /**
     * Schedule which flights should launch now.
     *
     * @param secSinceMidnight Seconds since midnight.
     */
    private void updateLaunchFlights(int secSinceMidnight) {
        List<Flight> flights = this.scheduler.launchFlights(secSinceMidnight);
        if (flights.size() > 0) {
            System.out.printf(
                    "[%s] Scheduling flights:%n",
                    secSinceMidnight
            );
            for (Flight flight : flights) {
                System.out.println(flight);
            }
        }
    }
}
