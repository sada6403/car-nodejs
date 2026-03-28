package com.cnl.global.jaffnavicle.repository;

import com.cnl.global.jaffnavicle.model.Vehicle;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface VehicleRepository extends MongoRepository<Vehicle, String> {
    Optional<Vehicle> findByVehicleNumber(String vehicleNumber);
}
