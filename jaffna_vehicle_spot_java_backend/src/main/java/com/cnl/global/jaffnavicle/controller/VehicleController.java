package com.cnl.global.jaffnavicle.controller;

import com.cnl.global.jaffnavicle.model.Vehicle;
import com.cnl.global.jaffnavicle.repository.VehicleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vehicle")
public class VehicleController {

    @Autowired
    private VehicleRepository vehicleRepository;

    @GetMapping("/list")
    public List<Vehicle> getAllVehicles() {
        return vehicleRepository.findAll();
    }

    @PostMapping("/add")
    @PreAuthorize("hasRole('Admin') or hasRole('Manager')")
    public Vehicle addVehicle(@RequestBody Vehicle vehicle) {
        return vehicleRepository.save(vehicle);
    }

    @PutMapping("/update/{id}")
    @PreAuthorize("hasRole('Admin') or hasRole('Manager')")
    public ResponseEntity<Vehicle> updateVehicle(@PathVariable String id, @RequestBody Vehicle vehicleDetails) {
        return vehicleRepository.findById(id).map(vehicle -> {
            vehicle.setVehicleName(vehicleDetails.getVehicleName());
            vehicle.setVehicleNumber(vehicleDetails.getVehicleNumber());
            vehicle.setModel(vehicleDetails.getModel());
            vehicle.setStatus(vehicleDetails.getStatus());
            vehicle.setBranchId(vehicleDetails.getBranchId());
            return ResponseEntity.ok(vehicleRepository.save(vehicle));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/delete/{id}")
    @PreAuthorize("hasRole('Admin')")
    public ResponseEntity<?> deleteVehicle(@PathVariable String id) {
        return vehicleRepository.findById(id).map(vehicle -> {
            vehicleRepository.delete(vehicle);
            return ResponseEntity.ok().build();
        }).orElse(ResponseEntity.notFound().build());
    }
}
