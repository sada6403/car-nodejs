package com.cnl.global.jaffnavicle.repository;

import com.cnl.global.jaffnavicle.model.GarageRecord;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface GarageRecordRepository extends MongoRepository<GarageRecord, String> {
    List<GarageRecord> findByVehicleId(String vehicleId);
}
