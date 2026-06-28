import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum for user roles across the app
enum UserRole { admin, receptionist, doctor, patient }

/// Enum for account status
enum UserStatus { active, deactivated, suspended }

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.receptionist:
        return 'receptionist';
      case UserRole.doctor:
        return 'doctor';
      case UserRole.patient:
        return 'patient';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'receptionist':
        return UserRole.receptionist;
      case 'doctor':
        return UserRole.doctor;
      case 'patient':
        return UserRole.patient;
      default:
        return UserRole.patient;
    }
  }
}

extension UserStatusExtension on UserStatus {
  String get name {
    switch (this) {
      case UserStatus.active:
        return 'active';
      case UserStatus.deactivated:
        return 'deactivated';
      case UserStatus.suspended:
        return 'suspended';
    }
  }

  static UserStatus fromString(String value) {
    switch (value) {
      case 'active':
        return UserStatus.active;
      case 'deactivated':
        return UserStatus.deactivated;
      case 'suspended':
        return UserStatus.suspended;
      default:
        return UserStatus.active;
    }
  }
}

/// Core user model shared across all roles
/// Firestore schema: users/{uid}
class UserModel {
  final String uid;
  final String email;
  final UserRole role;
  final UserStatus status;
  final String? displayName;
  final String? fcmToken;
  final bool isFirstLogin;
  final DateTime? tokenExpiry; // For first-login password reset (SRS-96)
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.status,
    this.displayName,
    this.fcmToken,
    this.isFirstLogin = false,
    this.tokenExpiry,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] as String? ?? '',
      role: UserRoleExtension.fromString(map['role'] as String? ?? 'patient'),
      status: UserStatusExtension.fromString(
        map['status'] as String? ?? 'active',
      ),
      displayName: map['displayName'] as String?,
      fcmToken: map['fcmToken'] as String?,
      isFirstLogin: map['isFirstLogin'] as bool? ?? false,
      tokenExpiry: (map['tokenExpiry'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role.name,
      'status': status.name,
      if (displayName != null) 'displayName': displayName,
      if (fcmToken != null) 'fcmToken': fcmToken,
      'isFirstLogin': isFirstLogin,
      if (tokenExpiry != null) 'tokenExpiry': Timestamp.fromDate(tokenExpiry!),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    UserRole? role,
    UserStatus? status,
    String? displayName,
    String? fcmToken,
    bool? isFirstLogin,
    DateTime? tokenExpiry,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      fcmToken: fcmToken ?? this.fcmToken,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isActive => status == UserStatus.active;
  bool get isDeactivated => status == UserStatus.deactivated;
}
