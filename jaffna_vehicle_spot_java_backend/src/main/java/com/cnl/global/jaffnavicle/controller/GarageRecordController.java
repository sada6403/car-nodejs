package com.cnl.global.jaffnavicle.controller;

import com.cnl.global.jaffnavicle.model.GarageRecord;
import com.cnl.global.jaffnavicle.repository.GarageRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/garage")
public class GarageRecordController {

    @Autowired
    private GarageRecordRepository garageRecordRepository;

    @PostMapping("/add")
    @PreAuthorize("hasRole('Admin') or hasRole('Manager')")
    public GarageRecord addRecord(@RequestBody GarageRecord record) {
        return garageRecordRepository.save(record);
    }

    @GetMapping("/list")
    public List<GarageRecord> getRecords() {
        return garageRecordRepository.findAll();
    }

    @GetMapping("/vehicle/{vehicleId}")
    public List<GarageRecord> getRecordsByVehicle(@PathVariable String vehicleId) {
        return garageRecordRepository.findByVehicleId(vehicleId);
    }
}
