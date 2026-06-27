import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/staff_model.dart';

abstract class IStaffRepository {
  /// Create a new staff profile in Firestore
  Future<Either<Failure, void>> createStaff(StaffModel staff, String uid);

  /// Update an existing staff profile
  Future<Either<Failure, void>> updateStaff(StaffModel staff);

  /// Watch all staff members (real-time stream)
  Stream<List<StaffModel>> watchAllStaff();

  /// Update account status (active, suspended, deactivated)
  Future<Either<Failure, void>> updateAccountStatus(String uid, String status);
}
