import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/services/cloudinary_service.dart';
import '../models/operation_model.dart';
import 'operation_repository.dart';

class OperationRepositoryImpl implements IOperationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, OperationModel>> fetchOperation(String operationId) async {
    try {
      final doc = await _firestore.collection('operations').doc(operationId).get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'Operation not found.'));
      }
      return Right(OperationModel.fromMap(doc.data()!, doc.id));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch operation.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, OperationModel?>> fetchOperationByAppointment(String appointmentId) async {
    try {
      final qs = await _firestore
          .collection('operations')
          .where('appointmentId', isEqualTo: appointmentId)
          .limit(1)
          .get();
      
      if (qs.docs.isEmpty) return const Right(null);
      return Right(OperationModel.fromMap(qs.docs.first.data(), qs.docs.first.id));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch operation.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(String operationId, OperationStatus status) async {
    try {
      await _firestore.collection('operations').doc(operationId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to update operation status.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<OperationModel?> watchOperation(String operationId) {
    return _firestore.collection('operations').doc(operationId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return OperationModel.fromMap(doc.data()!, doc.id);
    });
  }

  @override
  Stream<List<OperationModel>> watchPatientOperations(String patientId) {
    return _firestore
        .collection('operations')
        .where('patientId', isEqualTo: patientId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((qs) => qs.docs.map((doc) => OperationModel.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Future<Either<Failure, String>> createOperation(OperationModel operation) async {
    try {
      final docRef = await _firestore.collection('operations').add(operation.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to create operation record.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> assignSurgicalTeam(String operationId, SurgicalTeamModel team) async {
    try {
      final auditLog = AuditLogEntryModel(
        timestamp: DateTime.now(),
        changedBy: 'Admin',
        action: 'ASSIGN_TEAM',
        changes: 'Assigned primary doctor, anaesthesiologist, and nursing staff.',
      );

      await _firestore.collection('operations').doc(operationId).update({
        'surgicalTeam': team.toMap(),
        'auditLog': FieldValue.arrayUnion([auditLog.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to assign surgical team.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSurgicalTeam(
    String operationId,
    SurgicalTeamModel team,
    AuditLogEntryModel auditLogEntry,
  ) async {
    try {
      await _firestore.collection('operations').doc(operationId).update({
        'surgicalTeam': team.toMap(),
        'auditLog': FieldValue.arrayUnion([auditLogEntry.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to update surgical team.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> recordOutcome(String operationId, OperationOutcomeModel outcome) async {
    try {
      await _firestore.collection('operations').doc(operationId).update({
        'outcome': outcome.toMap(),
        'status': OperationStatus.completed.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to record operation outcome.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<OperationModel?> watchPatientOperationStatus(String patientId) {
    return _firestore
        .collection('operations')
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((qs) {
      if (qs.docs.isEmpty) return null;
      return OperationModel.fromMap(qs.docs.first.data(), qs.docs.first.id);
    });
  }

  @override
  Future<Either<Failure, List<OperationModel>>> fetchOperationHistory({
    int limit = 10,
    DocumentSnapshot? startAfter,
    Map<String, dynamic>? filters,
  }) async {
    try {
      Query query = _firestore.collection('operations');

      if (filters != null) {
        if (filters['status'] != null) {
          query = query.where('status', isEqualTo: filters['status']);
        }
        if (filters['doctorId'] != null) {
          query = query.where('surgicalTeam.primaryDoctorId', isEqualTo: filters['doctorId']);
        }
        if (filters['patientId'] != null) {
          query = query.where('patientId', isEqualTo: filters['patientId']);
        }
        if (filters['dateRangeStart'] != null && filters['dateRangeEnd'] != null) {
          query = query
              .where('scheduledDate', isGreaterThanOrEqualTo: Timestamp.fromDate(filters['dateRangeStart'] as DateTime))
              .where('scheduledDate', isLessThanOrEqualTo: Timestamp.fromDate(filters['dateRangeEnd'] as DateTime));
        }
      }

      // Order by scheduledDate descending
      query = query.orderBy('scheduledDate', descending: true);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final list = snapshot.docs
          .map((doc) => OperationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return Right(list);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch operations history.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadMedicalReport(File file, String operationId) async {
    try {
      // 1. Upload report to Cloudinary
      final secureUrl = await CloudinaryService.uploadReport(file);
      if (secureUrl == null) {
        return const Left(FirestoreFailure(message: 'Cloudinary upload failed.'));
      }

      // 2. Append the returned URL to operation reportUrls array
      await _firestore.collection('operations').doc(operationId).update({
        'reportUrls': FieldValue.arrayUnion([secureUrl]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return Right(secureUrl);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to update Firestore with report URL.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }
}
