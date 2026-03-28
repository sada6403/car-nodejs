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
@Document(collection = "attendance")
public class Attendance {

    @Id
    private String id;

    @Field("user_id")
    private String userId;

    @Field("branch_id")
    private String branchId;

    @Field("clock_in")
    private LocalDateTime clockIn;

    @Field("clock_out")
    private LocalDateTime clockOut;

    @Field("status")
    @Builder.Default
    private String status = "Present"; // Present, Half-Day, etc.
}
