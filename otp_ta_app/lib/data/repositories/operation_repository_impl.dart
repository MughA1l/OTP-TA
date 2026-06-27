import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
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
}
