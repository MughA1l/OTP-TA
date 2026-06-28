import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/doctor_model.dart';

abstract class IDoctorRepository {
  /// Create a new doctor profile
  Future<Either<Failure, void>> createDoctor(DoctorModel doctor);

  /// Update an existing doctor profile
  Future<Either<Failure, void>> updateDoctor(DoctorModel doctor);

  /// Fetch a specific doctor by ID
  Future<Either<Failure, DoctorModel>> fetchDoctor(String doctorId);

  /// Watch all doctors (real-time stream for admin list / patients booking)
  Stream<List<DoctorModel>> watchAllDoctors();

  /// Update account status (active, suspended, deactivated)
  Future<Either<Failure, void>> updateAccountStatus(String uid, String status);

  /// Update doctor's availability slots (SRS-41)
  Future<Either<Failure, void>> updateAvailability(
    String doctorId,
    List<String> slots,
  );

  /// Mark dates as on-leave
  Future<Either<Failure, void>> updateLeaveDates(
    String doctorId,
    List<String> leaveDates,
  );

  /// Fetch leave dates
  Future<Either<Failure, List<String>>> fetchLeaveDates(String doctorId);
}
