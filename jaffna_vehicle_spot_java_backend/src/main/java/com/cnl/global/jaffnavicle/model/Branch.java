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
@Document(collection = "branches")
public class Branch {

    @Id
    private String id;

    @Indexed(unique = true)
    @Field("branch_name")
    private String branchName;

    @Indexed(unique = true)
    @Field("branch_code")
    private String branchCode;

    @Field("location")
    private String location;

    @Field("manager_id")
    private String managerId;

    @Field("is_active")
    @Builder.Default
    private boolean isActive = true;

    @CreatedDate
    @Field("created_at")
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Field("updated_at")
    private LocalDateTime updatedAt;
}
