import 'package:cloud_firestore/cloud_firestore.dart';

/// Schema for patients collection
class PatientModel {
  final String patientId; // The unique ID shown in UI (SRS-25)
  final String uid; // Firebase Auth UID
  final String name;
  final String phone;
  final String address;
  final Map<String, dynamic> medicalHistory;
  final Map<String, dynamic> emergencyContact;
  final String? profilePicUrl;
  final DateTime createdAt;

  const PatientModel({
    required this.patientId,
    required this.uid,
    required this.name,
    required this.phone,
    required this.address,
    this.medicalHistory = const {},
    this.emergencyContact = const {},
    this.profilePicUrl,
    required this.createdAt,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map, String docId) {
    return PatientModel(
      patientId: map['patientId'] as String? ?? '',
      uid: docId,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      medicalHistory: Map<String, dynamic>.from(map['medicalHistory'] ?? {}),
      emergencyContact: Map<String, dynamic>.from(map['emergencyContact'] ?? {}),
      profilePicUrl: map['profilePicUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'name': name,
      'phone': phone,
      'address': address,
      'medicalHistory': medicalHistory,
      'emergencyContact': emergencyContact,
      'createdAt': Timestamp.fromDate(createdAt),
      if (profilePicUrl != null) 'profilePicUrl': profilePicUrl,
    };
  }

  PatientModel copyWith({
    String? patientId,
    String? uid,
    String? name,
    String? phone,
    String? address,
    Map<String, dynamic>? medicalHistory,
    Map<String, dynamic>? emergencyContact,
    String? profilePicUrl,
    DateTime? createdAt,
  }) {
    return PatientModel(
      patientId: patientId ?? this.patientId,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper getters for medical and personal info (mapping from maps)
  int get age {
    final rawAge = medicalHistory['age'];
    if (rawAge is int) return rawAge;
    if (rawAge is String) return int.tryParse(rawAge) ?? 0;
    return 0;
  }
  
  String get gender => (medicalHistory['gender'] as String?) ?? 'Not Specified';
  String? get guardianName => emergencyContact['name'] as String?;
  String get bloodGroup => (medicalHistory['bloodGroup'] as String?) ?? 'Not Specified';
  List<String> get medicalConditions => List<String>.from(medicalHistory['conditions'] ?? []);
}
