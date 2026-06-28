import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/error/failures.dart';
import '../models/doctor_model.dart';
import 'doctor_repository.dart';

class DoctorRepositoryImpl implements IDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> createDoctor(DoctorModel doctor) async {
    try {
      final batch = _firestore.batch();

      // Store user record
      final userRef = _firestore
          .collection(FirebaseConstants.users)
          .doc(doctor.doctorId);
      batch.set(userRef, {
        'email': doctor.email,
        'role': 'doctor',
        'status': 'active',
        'displayName': doctor.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Store doctor record
      final doctorRef = _firestore.collection('doctors').doc(doctor.doctorId);
      batch.set(doctorRef, doctor.toMap());

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to create doctor.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctor(DoctorModel doctor) async {
    try {
      await _firestore
          .collection('doctors')
          .doc(doctor.doctorId)
          .update(doctor.toMap());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to update doctor.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, DoctorModel>> fetchDoctor(String doctorId) async {
    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'Doctor not found.'));
      }
      return Right(DoctorModel.fromMap(doc.data()!, doc.id));
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to fetch doctor.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<List<DoctorModel>> watchAllDoctors() {
    return _firestore.collection('doctors').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<Either<Failure, void>> updateAccountStatus(
    String uid,
    String status,
  ) async {
    try {
      await _firestore.collection(FirebaseConstants.users).doc(uid).update({
        'status': status,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to update account status.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAvailability(
    String doctorId,
    List<String> slots,
  ) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'availabilitySlots': slots,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to update availability.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLeaveDates(
    String doctorId,
    List<String> leaveDates,
  ) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'leaveDates': leaveDates,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to update leave dates.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchLeaveDates(String doctorId) async {
    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      final data = doc.data();
      final leaveDates = List<String>.from(data?['leaveDates'] ?? []);
      return Right(leaveDates);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to fetch leave dates.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }
}
