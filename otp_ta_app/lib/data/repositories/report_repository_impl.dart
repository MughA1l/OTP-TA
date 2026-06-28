import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/analytics_model.dart';
import '../models/operation_model.dart';
import 'report_repository.dart';

class ReportRepositoryImpl implements IReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, AnalyticsCacheModel>> fetchOperationAnalytics(Map<String, dynamic> filters) async {
    try {
      final querySnapshot = await _firestore.collection('operations').get();
      final allOps = querySnapshot.docs.map((doc) => OperationModel.fromMap(doc.data(), doc.id)).toList();

      // Apply filters in memory
      final filteredOps = _applyFilters(allOps, filters);

      // Calculations
      final total = filteredOps.length;
      final completed = filteredOps.where((op) => op.status == OperationStatus.completed).length;
      final successRate = total > 0 ? (completed / total) * 100 : 0.0;

      double totalDuration = 0;
      int completedWithDuration = 0;

      final typeCount = <String, int>{};
      final roomCount = <String, int>{};
      final dateCount = <String, int>{};
      final doctorMap = <String, List<OperationModel>>{};

      for (var op in filteredOps) {
        // Breakdown by surgery type
        typeCount[op.surgeryType] = (typeCount[op.surgeryType] ?? 0) + 1;

        // Breakdown by OT room
        roomCount[op.otRoom] = (roomCount[op.otRoom] ?? 0) + 1;

        // Breakdown by date (yyyy-MM-dd)
        final dateStr = "${op.scheduledDate.year}-${op.scheduledDate.month.toString().padLeft(2, '0')}-${op.scheduledDate.day.toString().padLeft(2, '0')}";
        dateCount[dateStr] = (dateCount[dateStr] ?? 0) + 1;

        // Track doctor performance mapping
        final docId = op.surgicalTeam.primaryDoctorId;
        if (docId.isNotEmpty) {
          doctorMap.putIfAbsent(docId, () => []).add(op);
        }

        // Calculate duration for completed ones
        if (op.status == OperationStatus.completed) {
          final diff = op.updatedAt.difference(op.createdAt).inMinutes;
          final duration = diff > 0 ? diff : 90; // Fallback to 90 min if duration is 0
          totalDuration += duration;
          completedWithDuration++;
        }
      }

      final avgDuration = completedWithDuration > 0 ? totalDuration / completedWithDuration : 0.0;

      // Group doctor performances
      final List<DoctorPerformanceModel> doctorPerformances = [];
      for (var entry in doctorMap.entries) {
        final docOps = entry.value;
        final docCompleted = docOps.where((op) => op.status == OperationStatus.completed).length;
        
        double docDurationSum = 0;
        int docCompletedCount = 0;
        int onTimeCount = 0;

        for (var op in docOps) {
          if (op.status == OperationStatus.completed) {
            final diff = op.updatedAt.difference(op.createdAt).inMinutes;
            docDurationSum += diff > 0 ? diff : 90;
            docCompletedCount++;
          }
          // Punctuality check (mock check: if audit log doesn't report delay)
          final hasDelay = op.auditLog.any((log) => log.action.toLowerCase().contains('delay'));
          if (!hasDelay) {
            onTimeCount++;
          }
        }

        final docAvgDuration = docCompletedCount > 0 ? docDurationSum / docCompletedCount : 0.0;
        final punctuality = docOps.isNotEmpty ? onTimeCount / docOps.length : 1.0;

        doctorPerformances.add(
          DoctorPerformanceModel(
            doctorId: entry.key,
            doctorName: docOps.first.surgicalTeam.primaryDoctorId, // We will update names in controller/UI
            operationsCompleted: docCompleted,
            avgDurationMinutes: docAvgDuration,
            punctualityRate: punctuality,
          ),
        );
      }

      final resultCache = AnalyticsCacheModel(
        cacheId: 'live',
        lastUpdated: DateTime.now(),
        totalOperations: total,
        successRate: successRate,
        avgDurationMinutes: avgDuration,
        operationsBySurgeryType: typeCount,
        operationsByOtRoom: roomCount,
        operationsByDate: dateCount,
        doctorPerformances: doctorPerformances,
        recoveryMetrics: {
          'readmissionRate': total > 0 ? (filteredOps.where((op) => op.outcome?.complications.toLowerCase().contains('readmit') == true).length / total) * 100 : 0.0,
          'avgRecoveryTimeHours': 4.5,
        },
      );

      return Right(resultCache);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch analytics.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, DoctorPerformanceModel>> fetchDoctorPerformance(String doctorId) async {
    try {
      final querySnapshot = await _firestore
          .collection('operations')
          .get(); // Fetch all and filter in memory to avoid index creation issues

      final docOps = querySnapshot.docs
          .map((doc) => OperationModel.fromMap(doc.data(), doc.id))
          .where((op) => op.surgicalTeam.primaryDoctorId == doctorId)
          .toList();

      final completed = docOps.where((op) => op.status == OperationStatus.completed).length;
      
      double durationSum = 0;
      int completedCount = 0;
      int onTimeCount = 0;

      for (var op in docOps) {
        if (op.status == OperationStatus.completed) {
          final diff = op.updatedAt.difference(op.createdAt).inMinutes;
          durationSum += diff > 0 ? diff : 90;
          completedCount++;
        }
        final hasDelay = op.auditLog.any((log) => log.action.toLowerCase().contains('delay'));
        if (!hasDelay) {
          onTimeCount++;
        }
      }

      final avgDuration = completedCount > 0 ? durationSum / completedCount : 0.0;
      final punctuality = docOps.isNotEmpty ? onTimeCount / docOps.length : 1.0;

      return Right(
        DoctorPerformanceModel(
          doctorId: doctorId,
          doctorName: 'Doctor',
          operationsCompleted: completed,
          avgDurationMinutes: avgDuration,
          punctualityRate: punctuality,
        ),
      );
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch doctor performance.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchRecoveryAnalytics(Map<String, dynamic> filters) async {
    try {
      final querySnapshot = await _firestore.collection('operations').get();
      final allOps = querySnapshot.docs.map((doc) => OperationModel.fromMap(doc.data(), doc.id)).toList();

      final filteredOps = _applyFilters(allOps, filters);
      
      // Calculate recovery distribution
      // Recovery time in hours distribution
      int under2h = 0;
      int between2and4h = 0;
      int between4and8h = 0;
      int over8h = 0;
      int readmissions = 0;

      for (var op in filteredOps) {
        final outcome = op.outcome;
        if (outcome != null) {
          final notes = outcome.notes.toLowerCase();
          final complications = outcome.complications.toLowerCase();
          
          if (complications.contains('readmit') || notes.contains('readmission')) {
            readmissions++;
          }

          // Parse recovery time if indicated, else mock based on surgery type
          double recTime = 3.0; // default 3 hours
          if (notes.contains('recovery:')) {
            final idx = notes.indexOf('recovery:');
            final substr = notes.substring(idx + 9).trim();
            final match = RegExp(r'^\d+').firstMatch(substr);
            if (match != null) {
              recTime = double.tryParse(match.group(0)!) ?? 3.0;
            }
          } else {
            // Mock value based on hash of id
            recTime = (op.operationId.hashCode % 10) + 1.0;
          }

          if (recTime < 2) {
            under2h++;
          } else if (recTime <= 4) {
            between2and4h++;
          } else if (recTime <= 8) {
            between4and8h++;
          } else {
            over8h++;
          }
        }
      }

      final totalWithOutcome = under2h + between2and4h + between4and8h + over8h;
      final readmissionRate = filteredOps.isNotEmpty ? (readmissions / filteredOps.length) * 100 : 0.0;

      return Right({
        'distribution': {
          '< 2h': under2h,
          '2-4h': between2and4h,
          '4-8h': between4and8h,
          '> 8h': over8h,
        },
        'readmissions': readmissions,
        'readmissionRate': readmissionRate,
        'totalWithOutcome': totalWithOutcome,
      });
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch recovery analytics.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  List<OperationModel> _applyFilters(List<OperationModel> ops, Map<String, dynamic> filters) {
    List<OperationModel> result = List.from(ops);

    if (filters.containsKey('otRoom') && filters['otRoom'] != null && filters['otRoom'].toString().isNotEmpty) {
      result = result.where((op) => op.otRoom == filters['otRoom']).toList();
    }

    if (filters.containsKey('surgeryType') && filters['surgeryType'] != null && filters['surgeryType'].toString().isNotEmpty) {
      result = result.where((op) => op.surgeryType == filters['surgeryType']).toList();
    }

    if (filters.containsKey('startDate') && filters['startDate'] != null) {
      final startDate = filters['startDate'] as DateTime;
      result = result.where((op) => op.scheduledDate.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
    }

    if (filters.containsKey('endDate') && filters['endDate'] != null) {
      final endDate = filters['endDate'] as DateTime;
      result = result.where((op) => op.scheduledDate.isBefore(endDate.add(const Duration(days: 1)))).toList();
    }

    return result;
  }
}
