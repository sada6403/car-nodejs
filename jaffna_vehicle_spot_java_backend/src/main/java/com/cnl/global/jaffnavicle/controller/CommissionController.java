package com.cnl.global.jaffnavicle.controller;

import com.cnl.global.jaffnavicle.model.Commission;
import com.cnl.global.jaffnavicle.repository.CommissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/commission")
public class CommissionController {

    @Autowired
    private CommissionRepository commissionRepository;

    @PostMapping("/add")
    @PreAuthorize("hasRole('Admin') or hasRole('Manager')")
    public Commission addCommission(@RequestBody Commission commission) {
        return commissionRepository.save(commission);
    }

    @GetMapping("/report")
    @PreAuthorize("hasRole('Admin') or hasRole('Manager')")
    public List<Commission> getCommissions() {
        return commissionRepository.findAll();
    }
}
