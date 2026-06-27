import 'package:cloud_firestore/cloud_firestore.dart';

enum OperationStatus {
  preOp,
  inSurgery,
  recovery,
  completed
}

class OperationModel {
  final String operationId;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final OperationStatus status;
  final DateTime updatedAt;
  final DateTime createdAt;

  OperationModel({
    required this.operationId,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });

  OperationModel copyWith({
    String? operationId,
    String? appointmentId,
    String? patientId,
    String? doctorId,
    OperationStatus? status,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return OperationModel(
      operationId: operationId ?? this.operationId,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'status': status.name,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OperationModel.fromMap(Map<String, dynamic> map, String id) {
    return OperationModel(
      operationId: id,
      appointmentId: map['appointmentId'] ?? '',
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      status: OperationStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'preOp'),
        orElse: () => OperationStatus.preOp,
      ),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
