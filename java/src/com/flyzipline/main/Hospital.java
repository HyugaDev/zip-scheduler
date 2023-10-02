package com.flyzipline.main;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * You shouldn't need to modify this class
 */
public record Hospital(String name, int northM, int eastM) {

    /**
     * Reads and processes a CSV file object that conforms to the hospital.csv schema defined in README.md.
     *
     * @param path CSV file path to read into a dict.
     * @return a list of hospitals
     */
    public static List<Hospital> readCSV(String path) {
        List<Hospital> records = new ArrayList<>();
        try (Scanner scanner = new Scanner(new File(path));) {
            while (scanner.hasNextLine()) {
                List<String> record = getRecordFromLine(scanner.nextLine());
                records.add(
                        new Hospital(
                                record.get(0),
                                Integer.parseInt(record.get(1)),
                                Integer.parseInt(record.get(2))
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
        return "Hospital{" +
                "name='" + name + '\'' +
                ", northM=" + northM +
                ", eastM=" + eastM +
                '}';
    }
}
