import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl = 'https://ui-avatars.com/api/?name=Admin&background=2563EB&color=fff',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

class UserProfileService {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  final ValueNotifier<UserProfile> profileNotifier = ValueNotifier<UserProfile>(
    UserProfile(
      name: 'Jaffna Vehicle Spot Admin',
      email: 'admin@jaffnavspot.com',
      phone: '077 727 1735',
    ),
  );

  void updateProfile(UserProfile newProfile) {
    profileNotifier.value = newProfile;
  }
}

