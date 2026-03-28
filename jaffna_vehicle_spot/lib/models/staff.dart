import 'package:flutter/material.dart';

enum StaffRole {
  admin,
  manager,
  salesPerson,
  technician,
}

class Staff {
  final String id;
  final String name; // Keeping for existing UI consistency (can use fullName)
  final String fullName;
  final StaffRole role;
  final String phone; // Mobile No.
  final String mobileNo;
  final String homeNo;
  final String email;
  final String joinDate;
  final String? profileImage;
  
  // New Fields
  final String applicationPost;
  final String branch;
  final String postalAddress;
  final String permanentAddress;
  final String gender;
  final String civilStatus;
  final String dob;
  final String nicNo;
  final String spouseName;
  final String spouseContact;
  final String spouseNic;
  final String spouseAddress;
  final String spouseRelationship;
  final String olResults;
  final String alResults;
  final String otherQualifications;
  final bool hasOffense;
  final String offenseNature;
  final String salaryAmount;
  final String salaryAllowance;
  final String bankName;
  final String bankBranch;
  final String accountNo;
  final String epfNo;
  final String username; // Added to link with AuthService
  final String password; // Added for initial login credentials

  Staff({
    required this.id,
    required this.name,
    required this.fullName,
    required this.role,
    required this.phone,
    required this.mobileNo,
    required this.homeNo,
    required this.email,
    required this.joinDate,
    required this.applicationPost,
    required this.branch,
    required this.postalAddress,
    required this.permanentAddress,
    required this.gender,
    required this.civilStatus,
    required this.dob,
    required this.nicNo,
    required this.spouseName,
    required this.spouseContact,
    required this.spouseNic,
    required this.spouseAddress,
    required this.spouseRelationship,
    required this.olResults,
    required this.alResults,
    required this.otherQualifications,
    required this.hasOffense,
    required this.offenseNature,
    required this.salaryAmount,
    required this.salaryAllowance,
    required this.bankName,
    required this.bankBranch,
    required this.accountNo,
    required this.epfNo,
    required this.username,
    required this.password,
    this.profileImage,
  });

  String get roleDisplay {
    switch (role) {
      case StaffRole.admin:
        return 'Admin';
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.salesPerson:
        return 'Sales';
      case StaffRole.technician:
        return 'Technician';
    }
  }

  Color get roleColor {
    switch (role) {
      case StaffRole.admin:
        return const Color(0xFFEF4444); // Red
      case StaffRole.manager:
        return const Color(0xFF8B5CF6); // Purple
      case StaffRole.salesPerson:
        return const Color(0xFF3B82F6); // Blue
      case StaffRole.technician:
        return const Color(0xFF10B981); // Emerald
    }
  }

  Staff copyWith({
    String? name,
    String? fullName,
    StaffRole? role,
    String? phone,
    String? mobileNo,
    String? homeNo,
    String? email,
    String? postalAddress,
    String? permanentAddress,
    String? profileImage,
    String? password,
  }) {
    return Staff(
      id: id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      mobileNo: mobileNo ?? this.mobileNo,
      homeNo: homeNo ?? this.homeNo,
      email: email ?? this.email,
      joinDate: joinDate,
      applicationPost: applicationPost,
      branch: branch,
      postalAddress: postalAddress ?? this.postalAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      gender: gender,
      civilStatus: civilStatus,
      dob: dob,
      nicNo: nicNo,
      spouseName: spouseName,
      spouseContact: spouseContact,
      spouseNic: spouseNic,
      spouseAddress: spouseAddress,
      spouseRelationship: spouseRelationship,
      olResults: olResults,
      alResults: alResults,
      otherQualifications: otherQualifications,
      hasOffense: hasOffense,
      offenseNature: offenseNature,
      salaryAmount: salaryAmount,
      salaryAllowance: salaryAllowance,
      bankName: bankName,
      bankBranch: bankBranch,
      accountNo: accountNo,
      epfNo: epfNo,
      username: username,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class StaffService {
  static final StaffService _instance = StaffService._internal();
  factory StaffService() => _instance;
  StaffService._internal();

  final ValueNotifier<List<Staff>> staffsNotifier = ValueNotifier<List<Staff>>([
    Staff(
      id: 'ADM-001',
      name: 'Admin',
      fullName: 'System Administrator',
      role: StaffRole.admin,
      phone: '077 000 0000',
      mobileNo: '077 000 0000',
      homeNo: '011 000 0000',
      email: 'admin@jaffnavspot.com',
      joinDate: '2020-01-01',
      applicationPost: 'System Admin',
      branch: 'All Branches',
      postalAddress: 'Head Office, Colombo',
      permanentAddress: 'Head Office, Colombo',
      gender: 'Other',
      civilStatus: '-',
      dob: '1990-01-01',
      nicNo: '199014001234',
      spouseName: '-',
      spouseContact: '-',
      spouseNic: '-',
      spouseAddress: '-',
      spouseRelationship: '-',
      olResults: '-',
      alResults: '-',
      otherQualifications: '-',
      hasOffense: false,
      offenseNature: 'None',
      salaryAmount: '0',
      salaryAllowance: '0',
      bankName: '-',
      bankBranch: '-',
      accountNo: '-',
      epfNo: '-',
      username: 'admin',
      password: 'admin123',
    ),
    Staff(
      id: 'STF-001',
      name: 'Staff Jaffna',
      fullName: 'S. Lavapperiyan',
      role: StaffRole.salesPerson,
      phone: '077 123 4567',
      mobileNo: '077 123 4567',
      homeNo: '021 123 4567',
      email: 'lava@jaffna.com',
      joinDate: '2025-10-15',
      applicationPost: 'Sales Person',
      branch: 'Jaffna',
      postalAddress: '123 Point Pedro Road, Jaffna',
      permanentAddress: '123 Point Pedro Road, Jaffna',
      gender: 'Male',
      civilStatus: 'Single',
      dob: '1995-05-20',
      nicNo: '199514001234',
      spouseName: '-',
      spouseContact: '-',
      spouseNic: '-',
      spouseAddress: '-',
      spouseRelationship: '-',
      olResults: 'Distinction',
      alResults: '3As',
      otherQualifications: 'BSc in CS',
      hasOffense: false,
      offenseNature: 'None',
      salaryAmount: '150,000',
      salaryAllowance: '20,000',
      bankName: 'Bank of Ceylon',
      bankBranch: 'Main',
      accountNo: '123456789',
      epfNo: 'EPF-001',
      username: 'staff_jaffna',
      password: 'staff123',
    ),
    Staff(
      id: 'MGR-001',
      name: 'Manager Jaffna',
      fullName: 'J. Manager',
      role: StaffRole.manager,
      phone: '077 321 6543',
      mobileNo: '077 321 6543',
      homeNo: '021 321 6543',
      email: 'manager_jaffna@jaffnavspot.com',
      joinDate: '2024-01-01',
      applicationPost: 'Fleet Manager',
      branch: 'Jaffna',
      postalAddress: 'Jaffna Branch',
      permanentAddress: 'Jaffna Branch',
      gender: 'Male',
      civilStatus: 'Married',
      dob: '1985-01-01',
      nicNo: '198514001234',
      spouseName: '-',
      spouseContact: '-',
      spouseNic: '-',
      spouseAddress: '-',
      spouseRelationship: '-',
      olResults: '-',
      alResults: '-',
      otherQualifications: 'MBA',
      hasOffense: false,
      offenseNature: 'None',
      salaryAmount: '250,000',
      salaryAllowance: '50,000',
      bankName: 'HNB',
      bankBranch: 'Jaffna',
      accountNo: '987654321',
      epfNo: 'EPF-M01',
      username: 'manager_jaffna',
      password: 'manager123',
    ),
    Staff(
      id: 'MGR-002',
      name: 'Manager Poonakari',
      fullName: 'P. Manager',
      role: StaffRole.manager,
      phone: '077 444 5555',
      mobileNo: '077 444 5555',
      homeNo: '021 444 5555',
      email: 'manager_poonakari@jaffnavspot.com',
      joinDate: '2024-01-01',
      applicationPost: 'Fleet Manager',
      branch: 'Poonakari',
      postalAddress: 'Poonakari Branch',
      permanentAddress: 'Poonakari Branch',
      gender: 'Female',
      civilStatus: 'Married',
      dob: '1988-06-15',
      nicNo: '198814001234',
      spouseName: '-',
      spouseContact: '-',
      spouseNic: '-',
      spouseAddress: '-',
      spouseRelationship: '-',
      olResults: '-',
      alResults: '-',
      otherQualifications: 'MSc Management',
      hasOffense: false,
      offenseNature: 'None',
      salaryAmount: '250,000',
      salaryAllowance: '50,000',
      bankName: 'Commercial Bank',
      bankBranch: 'Poonakari',
      accountNo: '1122334455',
      epfNo: 'EPF-M02',
      username: 'manager_poonakari',
      password: 'manager123',
    ),
  ]);

  void addStaff(Staff staff) {
    staffsNotifier.value = [...staffsNotifier.value, staff];
  }

  void updateStaff(Staff updatedStaff) {
    final index = staffsNotifier.value.indexWhere((s) => s.id == updatedStaff.id);
    if (index != -1) {
      final newList = List<Staff>.from(staffsNotifier.value);
      newList[index] = updatedStaff;
      staffsNotifier.value = newList;
    }
  }

  void removeStaff(String id) {
    staffsNotifier.value = staffsNotifier.value.where((s) => s.id != id).toList();
  }
}

