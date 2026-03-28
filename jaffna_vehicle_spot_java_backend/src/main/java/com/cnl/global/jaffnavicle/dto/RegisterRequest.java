package com.cnl.global.jaffnavicle.dto;

import lombok.Data;

@Data
public class RegisterRequest {
    private String name;
    private String email;
    private String phone;
    private String password;
    private String role;
    private String branch_id;
}
