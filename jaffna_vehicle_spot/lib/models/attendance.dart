
class Attendance {
  final String id;
  final String userId;
  final String userName;
  final String userRole;
  final String branch;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double totalHours;
  final double overtimeHours;
  final String status; // 'Active', 'Completed', 'Invalid'
  final String? loginLocation;
  final String? logoutLocation;
  final String date;

  Attendance({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.branch,
    required this.checkIn,
    this.checkOut,
    this.totalHours = 0.0,
    this.overtimeHours = 0.0,
    this.status = 'Active',
    this.loginLocation,
    this.logoutLocation,
    String? date,
  }) : date = date ?? "${checkIn.year}-${checkIn.month.toString().padLeft(2, '0')}-${checkIn.day.toString().padLeft(2, '0')}";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userRole': userRole,
      'branch': branch,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'totalHours': totalHours,
      'overtimeHours': overtimeHours,
      'status': status,
      'loginLocation': loginLocation,
      'logoutLocation': logoutLocation,
      'date': date,
    };
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Unknown',
      userRole: json['userRole'] ?? 'Staff',
      branch: json['branch'] ?? 'Jaffna',
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      totalHours: json['totalHours']?.toDouble() ?? 0.0,
      overtimeHours: json['overtimeHours']?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Active',
      loginLocation: json['loginLocation'],
      logoutLocation: json['logoutLocation'],
      date: json['date'],
    );
  }
}
