import 'package:cloud_firestore/cloud_firestore.dart';

/// Schema for staff collection
/// Represents Doctors, Receptionists, and Admins in the system
class StaffModel {
  final String staffId;
  final String name;
  final String email;
  final String phone;
  final String role; // 'admin', 'doctor', 'receptionist'
  final List<String> shiftAllocations;
  final List<String> accessPermissions;
  final DateTime createdAt;
  final String? profilePicUrl;

  const StaffModel({
    required this.staffId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.shiftAllocations = const [],
    this.accessPermissions = const [],
    required this.createdAt,
    this.profilePicUrl,
  });

  factory StaffModel.fromMap(Map<String, dynamic> map, String id) {
    return StaffModel(
      staffId: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? 'doctor',
      shiftAllocations: List<String>.from(map['shiftAllocations'] ?? []),
      accessPermissions: List<String>.from(map['accessPermissions'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      profilePicUrl: map['profilePicUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'shiftAllocations': shiftAllocations,
      'accessPermissions': accessPermissions,
      'createdAt': Timestamp.fromDate(createdAt),
      if (profilePicUrl != null) 'profilePicUrl': profilePicUrl,
    };
  }

  StaffModel copyWith({
    String? staffId,
    String? name,
    String? email,
    String? phone,
    String? role,
    List<String>? shiftAllocations,
    List<String>? accessPermissions,
    DateTime? createdAt,
    String? profilePicUrl,
  }) {
    return StaffModel(
      staffId: staffId ?? this.staffId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      shiftAllocations: shiftAllocations ?? this.shiftAllocations,
      accessPermissions: accessPermissions ?? this.accessPermissions,
      createdAt: createdAt ?? this.createdAt,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    );
  }
}
