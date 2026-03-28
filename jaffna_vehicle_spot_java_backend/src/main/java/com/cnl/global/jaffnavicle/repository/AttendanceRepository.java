package com.cnl.global.jaffnavicle.repository;

import com.cnl.global.jaffnavicle.model.Attendance;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface AttendanceRepository extends MongoRepository<Attendance, String> {
    List<Attendance> findByUserId(String userId);
}
