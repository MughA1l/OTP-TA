import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/patient_model.dart';

abstract class IPatientRepository {
  /// Create a new patient profile
  Future<Either<Failure, void>> createPatient(PatientModel patient);

  /// Update an existing patient profile
  Future<Either<Failure, void>> updatePatient(PatientModel patient);

  /// Fetch a specific patient by ID
  Future<Either<Failure, PatientModel>> fetchPatient(String patientId);

  /// Watch all patients (real-time stream for admin list)
  Stream<List<PatientModel>> watchAllPatients();

  /// Update account status (active, suspended, deactivated)
  Future<Either<Failure, void>> updateAccountStatus(String uid, String status);
}
