import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentStatus { scheduled, completed, cancelled, noShow }

class AppointmentModel {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final DateTime dateTime;
  final AppointmentStatus status;
  final DateTime createdAt;
  final String? notes;

  const AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.dateTime,
    this.status = AppointmentStatus.scheduled,
    required this.createdAt,
    this.notes,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return AppointmentModel(
      appointmentId: docId,
      doctorId: map['doctorId'] as String? ?? '',
      patientId: map['patientId'] as String? ?? '',
      dateTime: (map['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'scheduled'),
        orElse: () => AppointmentStatus.scheduled,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (notes != null) 'notes': notes,
    };
  }

  AppointmentModel copyWith({
    String? appointmentId,
    String? doctorId,
    String? patientId,
    DateTime? dateTime,
    AppointmentStatus? status,
    DateTime? createdAt,
    String? notes,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
