package com.cnl.global.jaffnavicle.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "garage_records")
public class GarageRecord {

    @Id
    private String id;

    @Field("vehicle_id")
    private String vehicleId;

    @Field("entry_date")
    private LocalDateTime entryDate;

    @Field("exit_date")
    private LocalDateTime exitDate;

    @Field("description")
    private String description;

    @Field("cost")
    private Double cost;
}
