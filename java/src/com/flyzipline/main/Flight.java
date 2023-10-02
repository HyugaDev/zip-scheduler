package com.flyzipline.main;

import java.util.List;

/**
 * Feel free to extend as needed
 */
public class Flight {
    private final int launchTime;
    private final List<Order> orders;

    public Flight(int launchTIme, List<Order> orders) {
        this.launchTime = launchTIme;
        this.orders = orders;
    }

    @Override
    public String toString() {
        return "Flight{" +
                "launchTime=" + launchTime +
                ", orders=" + orders +
                '}';
    }
}
