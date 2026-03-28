package com.cnl.global.jaffnavicle.repository;

import com.cnl.global.jaffnavicle.model.Commission;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CommissionRepository extends MongoRepository<Commission, String> {
}
