import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/prescription_model.dart';

abstract class IMedicationRepository {
  /// Add a new prescription record (SRS-82, SRS-83)
  Future<Either<Failure, String>> addPrescription(PrescriptionModel prescription);

  /// Update medicine lists and append audit logs for changes (SRS-85)
  Future<Either<Failure, void>> updatePrescription(
    String prescriptionId,
    List<MedicineModel> medicines,
    PrescriptionAuditLogModel auditLog,
  );

  /// Fetch prescription details for a specific operation
  Future<Either<Failure, PrescriptionModel?>> fetchPrescriptionByOperation(String operationId);

  /// Fetch all active prescriptions for a patient
  Future<Either<Failure, List<PrescriptionModel>>> fetchSchedule(String patientId);

  /// Watch all active prescriptions for a patient (real-time stream)
  Stream<List<PrescriptionModel>> watchPatientPrescriptions(String patientId);
}
