import 'package:cloud_firestore/cloud_firestore.dart';

enum OperationStatus {
  scheduled,
  preOp,
  inSurgery,
  recovery,
  completed,
  cancelled
}

class SurgicalTeamModel {
  final String primaryDoctorId;
  final String anaesthesiologistId;
  final List<String> nursingStaff;

  SurgicalTeamModel({
    required this.primaryDoctorId,
    required this.anaesthesiologistId,
    required this.nursingStaff,
  });

  factory SurgicalTeamModel.fromMap(Map<String, dynamic> map) {
    return SurgicalTeamModel(
      primaryDoctorId: map['primaryDoctorId'] as String? ?? '',
      anaesthesiologistId: map['anaesthesiologistId'] as String? ?? '',
      nursingStaff: List<String>.from(map['nursingStaff'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primaryDoctorId': primaryDoctorId,
      'anaesthesiologistId': anaesthesiologistId,
      'nursingStaff': nursingStaff,
    };
  }

  SurgicalTeamModel copyWith({
    String? primaryDoctorId,
    String? anaesthesiologistId,
    List<String>? nursingStaff,
  }) {
    return SurgicalTeamModel(
      primaryDoctorId: primaryDoctorId ?? this.primaryDoctorId,
      anaesthesiologistId: anaesthesiologistId ?? this.anaesthesiologistId,
      nursingStaff: nursingStaff ?? this.nursingStaff,
    );
  }
}

class OperationOutcomeModel {
  final String notes;
  final String complications;
  final String patientCondition;
  final DateTime submittedAt;
  final String submittedBy;

  OperationOutcomeModel({
    required this.notes,
    required this.complications,
    required this.patientCondition,
    required this.submittedAt,
    required this.submittedBy,
  });

  factory OperationOutcomeModel.fromMap(Map<String, dynamic> map) {
    return OperationOutcomeModel(
      notes: map['notes'] as String? ?? '',
      complications: map['complications'] as String? ?? '',
      patientCondition: map['patientCondition'] as String? ?? '',
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      submittedBy: map['submittedBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'complications': complications,
      'patientCondition': patientCondition,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'submittedBy': submittedBy,
    };
  }
}

class AuditLogEntryModel {
  final DateTime timestamp;
  final String changedBy;
  final String action;
  final String changes;

  AuditLogEntryModel({
    required this.timestamp,
    required this.changedBy,
    required this.action,
    required this.changes,
  });

  factory AuditLogEntryModel.fromMap(Map<String, dynamic> map) {
    return AuditLogEntryModel(
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      changedBy: map['changedBy'] as String? ?? '',
      action: map['action'] as String? ?? '',
      changes: map['changes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'changedBy': changedBy,
      'action': action,
      'changes': changes,
    };
  }
}

class OperationModel {
  final String operationId;
  final String? appointmentId; // Links back to scheduling
  final String patientId;
  final String patientName;
  final String surgeryType;
  final String otRoom;
  final DateTime scheduledDate;
  final String scheduledTime;
  final OperationStatus status;
  final SurgicalTeamModel surgicalTeam;
  final OperationOutcomeModel? outcome;
  final bool credentialsGenerated;
  final List<String> reportUrls;
  final List<AuditLogEntryModel> auditLog;
  final DateTime createdAt;
  final DateTime updatedAt;

  OperationModel({
    required this.operationId,
    this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.surgeryType,
    required this.otRoom,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.surgicalTeam,
    this.outcome,
    required this.credentialsGenerated,
    required this.reportUrls,
    required this.auditLog,
    required this.createdAt,
    required this.updatedAt,
  });

  // Backward compatibility getter for screens expecting single reportUrl
  String? get reportUrl => reportUrls.isNotEmpty ? reportUrls.first : null;

  OperationModel copyWith({
    String? operationId,
    String? appointmentId,
    String? patientId,
    String? patientName,
    String? surgeryType,
    String? otRoom,
    DateTime? scheduledDate,
    String? scheduledTime,
    OperationStatus? status,
    SurgicalTeamModel? surgicalTeam,
    OperationOutcomeModel? outcome,
    bool? credentialsGenerated,
    List<String>? reportUrls,
    List<AuditLogEntryModel>? auditLog,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OperationModel(
      operationId: operationId ?? this.operationId,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      surgeryType: surgeryType ?? this.surgeryType,
      otRoom: otRoom ?? this.otRoom,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      surgicalTeam: surgicalTeam ?? this.surgicalTeam,
      outcome: outcome ?? this.outcome,
      credentialsGenerated: credentialsGenerated ?? this.credentialsGenerated,
      reportUrls: reportUrls ?? this.reportUrls,
      auditLog: auditLog ?? this.auditLog,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (appointmentId != null) 'appointmentId': appointmentId,
      'patientId': patientId,
      'patientName': patientName,
      'surgeryType': surgeryType,
      'otRoom': otRoom,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'scheduledTime': scheduledTime,
      'status': status.name,
      'surgicalTeam': surgicalTeam.toMap(),
      if (outcome != null) 'outcome': outcome!.toMap(),
      'credentialsGenerated': credentialsGenerated,
      'reportUrls': reportUrls,
      'auditLog': auditLog.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory OperationModel.fromMap(Map<String, dynamic> map, String id) {
    return OperationModel(
      operationId: id,
      appointmentId: map['appointmentId'] as String?,
      patientId: map['patientId'] as String? ?? '',
      patientName: map['patientName'] as String? ?? '',
      surgeryType: map['surgeryType'] as String? ?? '',
      otRoom: map['otRoom'] as String? ?? '',
      scheduledDate: (map['scheduledDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      scheduledTime: map['scheduledTime'] as String? ?? '',
      status: OperationStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['status'] as String? ?? 'scheduled').toLowerCase(),
        orElse: () => OperationStatus.scheduled,
      ),
      surgicalTeam: SurgicalTeamModel.fromMap(map['surgicalTeam'] as Map<String, dynamic>? ?? {}),
      outcome: map['outcome'] != null
          ? OperationOutcomeModel.fromMap(map['outcome'] as Map<String, dynamic>)
          : null,
      credentialsGenerated: map['credentialsGenerated'] as bool? ?? false,
      reportUrls: List<String>.from(map['reportUrls'] ?? []),
      auditLog: (map['auditLog'] as List?)
              ?.map((e) => AuditLogEntryModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
