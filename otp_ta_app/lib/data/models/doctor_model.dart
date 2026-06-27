import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String doctorId; // maps to UID
  final String name;
  final String email;
  final String phone;
  final String qualifications;
  final List<String> specializations;
  final String pmdc; // Registration number
  final String experience; // e.g., "5 years"
  final List<String> availabilitySlots;
  final String? profilePicUrl;
  final DateTime createdAt;

  const DoctorModel({
    required this.doctorId,
    required this.name,
    required this.email,
    required this.phone,
    required this.qualifications,
    this.specializations = const [],
    required this.pmdc,
    required this.experience,
    this.availabilitySlots = const [],
    this.profilePicUrl,
    required this.createdAt,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map, String docId) {
    return DoctorModel(
      doctorId: docId,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      qualifications: map['qualifications'] as String? ?? '',
      specializations: List<String>.from(map['specializations'] ?? []),
      pmdc: map['pmdc'] as String? ?? '',
      experience: map['experience'] as String? ?? '',
      availabilitySlots: List<String>.from(map['availabilitySlots'] ?? []),
      profilePicUrl: map['profilePicUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'qualifications': qualifications,
      'specializations': specializations,
      'pmdc': pmdc,
      'experience': experience,
      'availabilitySlots': availabilitySlots,
      'createdAt': Timestamp.fromDate(createdAt),
      if (profilePicUrl != null) 'profilePicUrl': profilePicUrl,
    };
  }

  DoctorModel copyWith({
    String? doctorId,
    String? name,
    String? email,
    String? phone,
    String? qualifications,
    List<String>? specializations,
    String? pmdc,
    String? experience,
    List<String>? availabilitySlots,
    String? profilePicUrl,
    DateTime? createdAt,
  }) {
    return DoctorModel(
      doctorId: doctorId ?? this.doctorId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      qualifications: qualifications ?? this.qualifications,
      specializations: specializations ?? this.specializations,
      pmdc: pmdc ?? this.pmdc,
      experience: experience ?? this.experience,
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
