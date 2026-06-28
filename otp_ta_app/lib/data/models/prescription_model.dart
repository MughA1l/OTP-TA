import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  final String name;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime endDate;

  MedicineModel({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    required this.endDate,
  });

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      name: map['name'] as String? ?? '',
      dosage: map['dosage'] as String? ?? '',
      frequency: map['frequency'] as String? ?? '',
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }

  MedicineModel copyWith({
    String? name,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return MedicineModel(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class PrescriptionAuditLogModel {
  final DateTime timestamp;
  final String oldDosage;
  final String newDosage;
  final String changedBy;

  PrescriptionAuditLogModel({
    required this.timestamp,
    required this.oldDosage,
    required this.newDosage,
    required this.changedBy,
  });

  factory PrescriptionAuditLogModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionAuditLogModel(
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      oldDosage: map['oldDosage'] as String? ?? '',
      newDosage: map['newDosage'] as String? ?? '',
      changedBy: map['changedBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'oldDosage': oldDosage,
      'newDosage': newDosage,
      'changedBy': changedBy,
    };
  }
}

class PrescriptionModel {
  final String prescriptionId;
  final String operationId;
  final String patientId;
  final String doctorId;
  final List<MedicineModel> medicines;
  final List<PrescriptionAuditLogModel> auditLog;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionModel({
    required this.prescriptionId,
    required this.operationId,
    required this.patientId,
    required this.doctorId,
    required this.medicines,
    required this.auditLog,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrescriptionModel.fromMap(Map<String, dynamic> map, String docId) {
    return PrescriptionModel(
      prescriptionId: docId,
      operationId: map['operationId'] as String? ?? '',
      patientId: map['patientId'] as String? ?? '',
      doctorId: map['doctorId'] as String? ?? '',
      medicines: (map['medicines'] as List?)
              ?.map((m) => MedicineModel.fromMap(Map<String, dynamic>.from(m)))
              .toList() ??
          [],
      auditLog: (map['auditLog'] as List?)
              ?.map((l) => PrescriptionAuditLogModel.fromMap(Map<String, dynamic>.from(l)))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'operationId': operationId,
      'patientId': patientId,
      'doctorId': doctorId,
      'medicines': medicines.map((m) => m.toMap()).toList(),
      'auditLog': auditLog.map((l) => l.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  PrescriptionModel copyWith({
    String? prescriptionId,
    String? operationId,
    String? patientId,
    String? doctorId,
    List<MedicineModel>? medicines,
    List<PrescriptionAuditLogModel>? auditLog,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrescriptionModel(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      operationId: operationId ?? this.operationId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      medicines: medicines ?? this.medicines,
      auditLog: auditLog ?? this.auditLog,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
