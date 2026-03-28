package com.cnl.global.jaffnavicle.controller;

import com.cnl.global.jaffnavicle.model.Branch;
import com.cnl.global.jaffnavicle.repository.BranchRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/branch")
public class BranchController {

    @Autowired
    private BranchRepository branchRepository;

    @GetMapping("/list")
    public List<Branch> getAllBranches() {
        return branchRepository.findAll();
    }

    @PostMapping("/add")
    @PreAuthorize("hasRole('Admin')")
    public Branch addBranch(@RequestBody Branch branch) {
        return branchRepository.save(branch);
    }
}
