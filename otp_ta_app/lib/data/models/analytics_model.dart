import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPerformanceModel {
  final String doctorId;
  final String doctorName;
  final int operationsCompleted;
  final double avgDurationMinutes;
  final double punctualityRate; // e.g. 0.95 (95% operations started on time)

  DoctorPerformanceModel({
    required this.doctorId,
    required this.doctorName,
    required this.operationsCompleted,
    required this.avgDurationMinutes,
    required this.punctualityRate,
  });

  factory DoctorPerformanceModel.fromMap(Map<String, dynamic> map) {
    return DoctorPerformanceModel(
      doctorId: map['doctorId'] as String? ?? '',
      doctorName: map['doctorName'] as String? ?? '',
      operationsCompleted: map['operationsCompleted'] as int? ?? 0,
      avgDurationMinutes:
          (map['avgDurationMinutes'] as num?)?.toDouble() ?? 0.0,
      punctualityRate: (map['punctualityRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'operationsCompleted': operationsCompleted,
      'avgDurationMinutes': avgDurationMinutes,
      'punctualityRate': punctualityRate,
    };
  }
}

class AnalyticsCacheModel {
  final String cacheId;
  final DateTime lastUpdated;
  final int totalOperations;
  final double successRate;
  final double avgDurationMinutes;
  final Map<String, int> operationsBySurgeryType;
  final Map<String, int> operationsByOtRoom;
  final Map<String, int> operationsByDate;
  final List<DoctorPerformanceModel> doctorPerformances;
  final Map<String, double> recoveryMetrics;

  AnalyticsCacheModel({
    required this.cacheId,
    required this.lastUpdated,
    required this.totalOperations,
    required this.successRate,
    required this.avgDurationMinutes,
    required this.operationsBySurgeryType,
    required this.operationsByOtRoom,
    required this.operationsByDate,
    required this.doctorPerformances,
    required this.recoveryMetrics,
  });

  factory AnalyticsCacheModel.fromMap(Map<String, dynamic> map, String docId) {
    final rawDocs = map['doctorPerformances'] as List? ?? [];
    final performances = rawDocs
        .map(
          (d) => DoctorPerformanceModel.fromMap(
            Map<String, dynamic>.from(d as Map),
          ),
        )
        .toList();

    return AnalyticsCacheModel(
      cacheId: docId,
      lastUpdated:
          (map['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalOperations: map['totalOperations'] as int? ?? 0,
      successRate: (map['successRate'] as num?)?.toDouble() ?? 0.0,
      avgDurationMinutes:
          (map['avgDurationMinutes'] as num?)?.toDouble() ?? 0.0,
      operationsBySurgeryType: Map<String, int>.from(
        map['operationsBySurgeryType'] ?? {},
      ),
      operationsByOtRoom: Map<String, int>.from(
        map['operationsByOtRoom'] ?? {},
      ),
      operationsByDate: Map<String, int>.from(map['operationsByDate'] ?? {}),
      doctorPerformances: performances,
      recoveryMetrics: Map<String, double>.from(
        (map['recoveryMetrics'] ?? {}).map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'totalOperations': totalOperations,
      'successRate': successRate,
      'avgDurationMinutes': avgDurationMinutes,
      'operationsBySurgeryType': operationsBySurgeryType,
      'operationsByOtRoom': operationsByOtRoom,
      'operationsByDate': operationsByDate,
      'doctorPerformances': doctorPerformances.map((d) => d.toMap()).toList(),
      'recoveryMetrics': recoveryMetrics,
    };
  }
}
