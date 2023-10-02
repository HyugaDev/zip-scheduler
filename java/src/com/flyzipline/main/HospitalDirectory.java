package com.flyzipline.main;

import java.util.HashMap;
import java.util.List;

public class HospitalDirectory {
    private final HashMap<String, Hospital> hospitalHashMap;

    public HospitalDirectory(List<Hospital> hospitals) {
        this.hospitalHashMap = new HashMap<>();
        for (Hospital h : hospitals) {
            hospitalHashMap.put(h.name(), h);
        }
    }

    public Hospital getHospital(String name) {
        return hospitalHashMap.get(name);
    }
}
