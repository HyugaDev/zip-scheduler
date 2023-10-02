package com.flyzipline.main;

public class Main {

    public static void main(String[] args) {
        Runner runner = new Runner(
                "../inputs/hospitals.csv",
                "../inputs/orders.csv"
        );
        runner.run();
    }
}
