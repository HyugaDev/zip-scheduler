package com.flyzipline.main;

public class Zip {
    // Each Nest has this many Zips
    public final static int NUM_ZIPS = 10;
    // Each Zip can carry between 1 and this many packages per flight
    // Note: a Zip can deliver more than 1 package per stop
    public final static int MAX_PACKAGES_PER_ZIP = 3;
    // Zips fly a constant groundspeed (m/s)
    public final static int ZIP_SPEED_MPS = 30;
    // Zips can fly a total roundtrip distance (m)
    public final static int ZIP_MAX_CUMULATIVE_RANGE_M = 160 * 1000;  // 160 km -> meters
}
