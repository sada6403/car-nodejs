package com.cnl.global.jaffnavicle.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class JwtResponse {
    private String id;
    private String name;
    private String role;
    private String token;
}
