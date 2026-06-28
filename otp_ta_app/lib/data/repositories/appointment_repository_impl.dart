import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/appointment_model.dart';
import 'appointment_repository.dart';

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, String>> bookAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      final docRef = await _firestore
          .collection('appointments')
          .add(appointment.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to book appointment.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> reschedule(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'dateTime': Timestamp.fromDate(newDateTime),
        'status': AppointmentStatus.scheduled.name,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to reschedule appointment.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> cancel(String appointmentId) async {
    try {
      // Cancel frees the time slot by updating status (SRS-44)
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': AppointmentStatus.cancelled.name,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to cancel appointment.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status.name,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to update status.'),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<List<AppointmentModel>> watchAllAppointments() {
    return _firestore
        .collection('appointments')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AppointmentModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  @override
  Stream<List<AppointmentModel>> watchDoctorAppointments(String doctorId) {
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AppointmentModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  @override
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId) {
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AppointmentModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }
}
