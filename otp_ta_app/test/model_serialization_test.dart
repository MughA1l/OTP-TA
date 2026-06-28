import 'package:flutter_test/flutter_test.dart';
import 'package:otp_ta_app/data/models/operation_model.dart';
import 'package:otp_ta_app/data/models/user_model.dart';

void main() {
  group('Model serialization', () {
    test('UserModel round-trips through map', () {
      final user = UserModel(
        uid: 'u1',
        email: 'doctor@example.com',
        role: UserRole.doctor,
        status: UserStatus.active,
        createdAt: DateTime(2026, 1, 1),
      );

      final map = user.toMap();
      final restored = UserModel.fromMap(map, user.uid);

      expect(restored.uid, user.uid);
      expect(restored.email, user.email);
      expect(restored.role, user.role);
      expect(restored.status, user.status);
    });

    test('OperationModel round-trips through map', () {
      final operation = OperationModel(
        operationId: 'op-1',
        patientId: 'p1',
        patientName: 'Ali Khan',
        surgeryType: 'Appendectomy',
        otRoom: 'OT-2',
        scheduledDate: DateTime(2026, 6, 28),
        scheduledTime: '09:00',
        status: OperationStatus.scheduled,
        surgicalTeam: SurgicalTeamModel(
          primaryDoctorId: 'd1',
          anaesthesiologistId: 'd2',
          nursingStaff: ['n1', 'n2'],
        ),
        credentialsGenerated: false,
        reportUrls: const [],
        auditLog: const [],
        createdAt: DateTime(2026, 6, 27),
        updatedAt: DateTime(2026, 6, 27),
      );

      final map = operation.toMap();
      final restored = OperationModel.fromMap(map, operation.operationId);

      expect(restored.operationId, operation.operationId);
      expect(restored.patientName, operation.patientName);
      expect(
        restored.surgicalTeam.primaryDoctorId,
        operation.surgicalTeam.primaryDoctorId,
      );
      expect(restored.reportUrls, isEmpty);
    });
  });
}
