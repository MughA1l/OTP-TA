import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/operation_model.dart';

abstract class IOperationRepository {
  /// Fetch a specific operation by its ID
  Future<Either<Failure, OperationModel>> fetchOperation(String operationId);

  /// Fetch an operation tied to a specific appointment
  Future<Either<Failure, OperationModel?>> fetchOperationByAppointment(String appointmentId);

  /// Update the status of an operation
  Future<Either<Failure, void>> updateStatus(String operationId, OperationStatus status);

  /// Watch operation by its ID for real-time updates (SRS-53)
  Stream<OperationModel?> watchOperation(String operationId);

  /// Watch all operations for a specific patient
  Stream<List<OperationModel>> watchPatientOperations(String patientId);
}
