import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/error/failures.dart';
import '../models/patient_model.dart';
import 'patient_repository.dart';

class PatientRepositoryImpl implements IPatientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> createPatient(PatientModel patient) async {
    try {
      final batch = _firestore.batch();
      
      // Store user record
      final userRef = _firestore.collection(FirebaseConstants.users).doc(patient.uid);
      batch.set(userRef, {
        'email': '${patient.patientId.toLowerCase()}@hospital.com', // mock email
        'role': 'patient',
        'status': 'active',
        'displayName': patient.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Store patient record
      final patientRef = _firestore.collection('patients').doc(patient.uid);
      batch.set(patientRef, patient.toMap());

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to create patient.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatient(PatientModel patient) async {
    try {
      await _firestore
          .collection('patients')
          .doc(patient.uid)
          .update(patient.toMap());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to update patient.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, PatientModel>> fetchPatient(String uid) async {
    try {
      final doc = await _firestore.collection('patients').doc(uid).get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'Patient not found.'));
      }
      return Right(PatientModel.fromMap(doc.data()!, doc.id));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch patient.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<List<PatientModel>> watchAllPatients() {
    return _firestore
        .collection('patients')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PatientModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
