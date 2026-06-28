import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/analytics_model.dart';

abstract class IReportRepository {
  /// Fetches operation analytics based on date range or room filters.
  Future<Either<Failure, AnalyticsCacheModel>> fetchOperationAnalytics(
    Map<String, dynamic> filters,
  );

  /// Fetches specific doctor performance metrics (SRS-109).
  Future<Either<Failure, DoctorPerformanceModel>> fetchDoctorPerformance(
    String doctorId,
  );

  /// Fetches recovery analytics including distribution and readmissions (SRS-110).
  Future<Either<Failure, Map<String, dynamic>>> fetchRecoveryAnalytics(
    Map<String, dynamic> filters,
  );
}
