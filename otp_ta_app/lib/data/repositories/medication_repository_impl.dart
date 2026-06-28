import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/prescription_model.dart';
import 'medication_repository.dart';

class MedicationRepositoryImpl implements IMedicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, String>> addPrescription(
    PrescriptionModel prescription,
  ) async {
    try {
      final docRef = await _firestore
          .collection('prescriptions')
          .add(prescription.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to add prescription.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePrescription(
    String prescriptionId,
    List<MedicineModel> medicines,
    PrescriptionAuditLogModel auditLog,
  ) async {
    try {
      await _firestore.collection('prescriptions').doc(prescriptionId).update({
        'medicines': medicines.map((m) => m.toMap()).toList(),
        'auditLog': FieldValue.arrayUnion([auditLog.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to update prescription.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, PrescriptionModel?>> fetchPrescriptionByOperation(
    String operationId,
  ) async {
    try {
      final qs = await _firestore
          .collection('prescriptions')
          .where('operationId', isEqualTo: operationId)
          .limit(1)
          .get();

      if (qs.docs.isEmpty) return const Right(null);
      return Right(
        PrescriptionModel.fromMap(qs.docs.first.data(), qs.docs.first.id),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to fetch prescription.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<PrescriptionModel>>> fetchSchedule(
    String patientId,
  ) async {
    try {
      final qs = await _firestore
          .collection('prescriptions')
          .where('patientId', isEqualTo: patientId)
          .orderBy('updatedAt', descending: true)
          .get();

      final list = qs.docs
          .map((doc) => PrescriptionModel.fromMap(doc.data(), doc.id))
          .toList();
      return Right(list);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to fetch medication schedule.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<List<PrescriptionModel>> watchPatientPrescriptions(String patientId) {
    return _firestore
        .collection('prescriptions')
        .where('patientId', isEqualTo: patientId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (qs) => qs.docs
              .map((doc) => PrescriptionModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
