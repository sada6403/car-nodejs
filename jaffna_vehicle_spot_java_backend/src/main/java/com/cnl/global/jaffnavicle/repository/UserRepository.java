package com.cnl.global.jaffnavicle.repository;

import com.cnl.global.jaffnavicle.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);
}
