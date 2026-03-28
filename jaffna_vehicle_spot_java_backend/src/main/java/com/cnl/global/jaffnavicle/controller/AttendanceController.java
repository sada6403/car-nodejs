package com.cnl.global.jaffnavicle.controller;

import com.cnl.global.jaffnavicle.model.Attendance;
import com.cnl.global.jaffnavicle.model.User;
import com.cnl.global.jaffnavicle.repository.AttendanceRepository;
import com.cnl.global.jaffnavicle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/attendance")
public class AttendanceController {

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private UserRepository userRepository;

    private User getCurrentUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email).get();
    }

    @PostMapping("/login")
    public ResponseEntity<Attendance> clockIn() {
        User user = getCurrentUser();
        Attendance attendance = Attendance.builder()
                .userId(user.getId())
                .branchId(user.getBranchId())
                .clockIn(LocalDateTime.now())
                .status("Present")
                .build();
        return ResponseEntity.ok(attendanceRepository.save(attendance));
    }

    @PostMapping("/logout")
    public ResponseEntity<Attendance> clockOut() {
        User user = getCurrentUser();
        List<Attendance> attendances = attendanceRepository.findByUserId(user.getId());
        if (attendances.isEmpty()) return ResponseEntity.notFound().build();

        Attendance lastAttendance = attendances.get(attendances.size() - 1);
        if (lastAttendance.getClockOut() != null) return ResponseEntity.badRequest().build();

        lastAttendance.setClockOut(LocalDateTime.now());
        return ResponseEntity.ok(attendanceRepository.save(lastAttendance));
    }

    @GetMapping("/report")
    public List<Attendance> getReports() {
        User user = getCurrentUser();
        if ("Admin".equalsIgnoreCase(user.getRole())) {
            return attendanceRepository.findAll();
        }
        return attendanceRepository.findByUserId(user.getId());
    }
}
