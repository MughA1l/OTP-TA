import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/operation_model.dart';

abstract class IOperationRepository {
  /// Fetch a specific operation by its ID
  Future<Either<Failure, OperationModel>> fetchOperation(String operationId);

  /// Fetch an operation tied to a specific appointment
  Future<Either<Failure, OperationModel?>> fetchOperationByAppointment(
    String appointmentId,
  );

  /// Update the status of an operation
  Future<Either<Failure, void>> updateStatus(
    String operationId,
    OperationStatus status,
  );

  /// Watch operation by its ID for real-time updates (SRS-53)
  Stream<OperationModel?> watchOperation(String operationId);

  /// Watch all operations for a specific patient
  Stream<List<OperationModel>> watchPatientOperations(String patientId);

  /// Create a new operation record (SRS-64)
  Future<Either<Failure, String>> createOperation(OperationModel operation);

  /// Assign surgical team to an operation (SRS-66, SRS-69)
  Future<Either<Failure, void>> assignSurgicalTeam(
    String operationId,
    SurgicalTeamModel team,
  );

  /// Update surgical team and append audit log (SRS-67, SRS-68, SRS-70)
  Future<Either<Failure, void>> updateSurgicalTeam(
    String operationId,
    SurgicalTeamModel team,
    AuditLogEntryModel auditLogEntry,
  );

  /// Record outcome of an operation (SRS-72, SRS-73)
  Future<Either<Failure, void>> recordOutcome(
    String operationId,
    OperationOutcomeModel outcome,
  );

  /// Watch the most recent operation status of a patient in real-time
  Stream<OperationModel?> watchPatientOperationStatus(String patientId);

  /// Fetch operations history with pagination and filters (SRS-79, SRS-80)
  Future<Either<Failure, List<OperationModel>>> fetchOperationHistory({
    int limit = 10,
    DocumentSnapshot? startAfter,
    Map<String, dynamic>? filters,
  });

  /// Upload report to Cloudinary and append URL to operation reportUrls (SRS-76, SRS-78)
  Future<Either<Failure, String>> uploadMedicalReport(
    File file,
    String operationId,
  );
}
