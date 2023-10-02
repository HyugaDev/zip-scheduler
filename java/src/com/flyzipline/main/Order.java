package com.flyzipline.main;


import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

enum Priority {
    Emergency, Resupply
}

public record Order(int time, Hospital hospital, Priority priority) {
    /**
     * Reads and processes a CSV file object that conforms to the orders.csv schema defined in README.md.
     *
     * @param path              CSV file path to read into a dict.
     * @param hospitalDirectory a directory of all the hosptials
     * @return a list of Orders
     */
    public static List<com.flyzipline.main.Order> readCSV(String path, HospitalDirectory hospitalDirectory) {
        List<com.flyzipline.main.Order> records = new ArrayList<>();
        try (Scanner scanner = new Scanner(new File(path))) {
            while (scanner.hasNextLine()) {
                List<String> record = getRecordFromLine(scanner.nextLine());
                records.add(
                        new com.flyzipline.main.Order(
                                Integer.parseInt(record.get(0)),
                                hospitalDirectory.getHospital(record.get(1)),
                                Priority.valueOf(record.get(2))
                        )
                );
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return records;
    }

    private static List<String> getRecordFromLine(String line) {
        List<String> values = new ArrayList<>();
        try (Scanner rowScanner = new Scanner(line)) {
            rowScanner.useDelimiter(", ");
            while (rowScanner.hasNext()) {
                values.add(rowScanner.next());
            }
        }
        return values;
    }

    @Override
    public String toString() {
        return "Order{" +
                "time=" + time +
                ", hospital=" + hospital +
                ", priority=" + priority +
                '}';
    }
}
