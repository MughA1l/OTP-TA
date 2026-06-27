import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/appointment_model.dart';

abstract class IAppointmentRepository {
  /// Book a new appointment
  Future<Either<Failure, String>> bookAppointment(AppointmentModel appointment);

  /// Reschedule an existing appointment (SRS-43)
  Future<Either<Failure, void>> reschedule(String appointmentId, DateTime newDateTime);

  /// Cancel an appointment – frees the slot (SRS-44)
  Future<Either<Failure, void>> cancel(String appointmentId);

  /// Update appointment status
  Future<Either<Failure, void>> updateStatus(String appointmentId, AppointmentStatus status);

  /// Watch all appointments (real-time)
  Stream<List<AppointmentModel>> watchAllAppointments();

  /// Watch appointments for a specific doctor
  Stream<List<AppointmentModel>> watchDoctorAppointments(String doctorId);

  /// Watch appointments for a specific patient
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId);
}
