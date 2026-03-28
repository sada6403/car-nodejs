package com.cnl.global.jaffnavicle.repository;

import com.cnl.global.jaffnavicle.model.Branch;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface BranchRepository extends MongoRepository<Branch, String> {
    Optional<Branch> findByBranchCode(String branchCode);
}
