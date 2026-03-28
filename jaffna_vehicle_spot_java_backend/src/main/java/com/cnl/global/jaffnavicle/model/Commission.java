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
@Document(collection = "commissions")
public class Commission {

    @Id
    private String id;

    @Field("agent_name")
    private String agentName;

    @Field("amount")
    private Double amount;

    @Field("vehicle_id")
    private String vehicleId;

    @Field("date")
    private LocalDateTime date;
}
