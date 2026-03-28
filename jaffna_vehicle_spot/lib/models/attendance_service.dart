import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'attendance.dart';
import '../utils/notification_service.dart';

class AttendanceService {
  static final AttendanceService _instance = AttendanceService._internal();
  factory AttendanceService() => _instance;
  AttendanceService._internal() {
    _loadAttendances();
  }

  Attendance? _currentAttendance;
  Attendance? get currentAttendance => _currentAttendance;

  // New: Store all attendance records for the report page
  final ValueNotifier<List<Attendance>> allAttendancesNotifier = ValueNotifier<List<Attendance>>([]);

  // Working hours configuration
  final int startHour = 8;  // 8:00 AM
  final int endHour = 18;   // 6:00 PM
  final int forceLogoutHour = 22; // 10:00 PM

  Future<void> checkIn(String userId, String userName, String userRole, String branch) async {
    final now = DateTime.now();
    _currentAttendance = Attendance(
      id: DateFormat('yyyyMMdd_HHmmss').format(now),
      userId: userId,
      userName: userName,
      userRole: userRole,
      branch: branch,
      checkIn: now,
      status: 'Active',
    );
    
    if (!kIsWeb) {
      NotificationService().showNotification(
        id: 1,
        title: 'Check-In Successful',
        body: 'Welcome $userName! Your attendance has been marked at ${DateFormat('hh:mm a').format(now)}.',
      );
    }
    
    debugPrint('Checked in at: $now');
    
    // Add to all attendances list immediately (as active)
    _updateAllAttendances(_currentAttendance!);
  }

  Future<void> checkOut() async {
    if (_currentAttendance == null) return;

    final now = DateTime.now();
    final checkIn = _currentAttendance!.checkIn;
    
    // Calculate total hours
    final duration = now.difference(checkIn);
    final totalHours = duration.inMinutes / 60.0;

    // Calculate overtime (if logout after 6:00 PM today)
    double overtime = 0.0;
    final workEndTime = DateTime(now.year, now.month, now.day, endHour);
    
    if (now.isAfter(workEndTime)) {
      final overtimeDuration = now.difference(workEndTime.isAfter(checkIn) ? workEndTime : checkIn);
      if (overtimeDuration.inMinutes > 0) {
        overtime = overtimeDuration.inMinutes / 60.0;
      }
    }

    final completedAttendance = Attendance(
      id: _currentAttendance!.id,
      userId: _currentAttendance!.userId,
      userName: _currentAttendance!.userName,
      userRole: _currentAttendance!.userRole,
      branch: _currentAttendance!.branch,
      checkIn: _currentAttendance!.checkIn,
      checkOut: now,
      totalHours: totalHours,
      overtimeHours: overtime,
      status: 'Completed',
    );

    debugPrint('Checked out at: $now. Total Hours: ${totalHours.toStringAsFixed(2)}, Overtime: ${overtime.toStringAsFixed(2)}');
    
    // Update the record in the list
    _updateAllAttendances(completedAttendance);
    
    _currentAttendance = null; 
  }

  Future<void> _saveAttendances() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = allAttendancesNotifier.value.map((a) => a.toJson()).toList();
      await prefs.setString('attendances_data', jsonEncode(jsonList));
      debugPrint('Attendance saved to SharedPreferences');
    } catch (e) {
      debugPrint('Error saving attendance: $e');
    }
  }

  Future<void> _loadAttendances() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('attendances_data');
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        allAttendancesNotifier.value = jsonList.map((j) => Attendance.fromJson(j)).toList();
        debugPrint('Attendance loaded from SharedPreferences: ${allAttendancesNotifier.value.length} records');
      }
    } catch (e) {
      debugPrint('Error loading attendance: $e');
    }
  }

  void _updateAllAttendances(Attendance attendance) {
    final list = List<Attendance>.from(allAttendancesNotifier.value);
    final index = list.indexWhere((a) => a.id == attendance.id);
    if (index != -1) {
      list[index] = attendance;
    } else {
      list.add(attendance);
    }
    allAttendancesNotifier.value = list;
    _saveAttendances(); // Persist on every update
  }

  bool isOvertimeStarted() {
    final now = DateTime.now();
    return now.hour >= endHour;
  }


  // Night System Task: Runs at 10 PM
  Future<void> forceLogoutAtNight() async {
    if (_currentAttendance != null) {
      await checkOut(); // Finalize current session
      if (!kIsWeb) {
        NotificationService().showNotification(
          id: 3,
          title: 'Night Auto-Logout',
          body: 'Your work session has been automatically closed for the day.',
        );
      }
      debugPrint('Night auto-logout completed.');
    }
  }
}
