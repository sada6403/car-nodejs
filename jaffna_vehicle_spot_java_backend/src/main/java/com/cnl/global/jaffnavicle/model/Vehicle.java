package com.cnl.global.jaffnavicle.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "vehicles")
public class Vehicle {

    @Id
    private String id;

    @Field("vehicle_name")
    private String vehicleName;

    @Indexed(unique = true)
    @Field("vehicle_number")
    private String vehicleNumber;

    @Field("model")
    private String model;

    @Field("status")
    @Builder.Default
    private String status = "Available"; // Available, Sold, In Garage

    @Field("branch_id")
    private String branchId;

    @CreatedDate
    @Field("created_at")
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Field("updated_at")
    private LocalDateTime updatedAt;
}
