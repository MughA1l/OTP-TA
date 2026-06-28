import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/services/render_api_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/operation_model.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/operation_repository.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../../data/repositories/doctor_repository.dart';

class OperationController extends GetxController {
  final IOperationRepository _operationRepository;
  final IPatientRepository _patientRepository;
  final IDoctorRepository _doctorRepository;

  OperationController({
    required IOperationRepository operationRepository,
    required IPatientRepository patientRepository,
    required IDoctorRepository doctorRepository,
  })  : _operationRepository = operationRepository,
        _patientRepository = patientRepository,
        _doctorRepository = doctorRepository;

  final RxBool isLoading = false.obs;
  final RxList<OperationModel> operationsList = <OperationModel>[].obs;
  final Rx<OperationModel?> selectedOperation = Rx<OperationModel?>(null);

  // Observable lists of Patients and Doctors
  final RxList<PatientModel> patientList = <PatientModel>[].obs;
  final RxList<DoctorModel> doctorList = <DoctorModel>[].obs;

  // For pagination in history
  DocumentSnapshot? _lastDocument;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    _watchPatients();
    _watchDoctors();
  }

  void _watchPatients() {
    _patientRepository.watchAllPatients().listen(
      (list) => patientList.value = list,
      onError: (_) => SnackbarHelper.showError('Error', 'Failed to load patients list.'),
    );
  }

  void _watchDoctors() {
    _doctorRepository.watchAllDoctors().listen(
      (list) => doctorList.value = list,
      onError: (_) => SnackbarHelper.showError('Error', 'Failed to load doctors list.'),
    );
  }

  /// Creates a new operation record and auto-navigates to team assignment (SRS-64)
  Future<void> createOperation(OperationModel operation) async {
    isLoading.value = true;
    final result = await _operationRepository.createOperation(operation);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (operationId) {
        SnackbarHelper.showSuccess('Success', 'Operation Record Created Successfully');
        // Auto-navigate to Assign Team screen passing the operationId
        Get.offNamed('/assign-team', arguments: operationId);
      },
    );
    isLoading.value = false;
  }

  /// Assign surgical team and send notification to team members (SRS-66, SRS-69)
  Future<void> assignSurgicalTeam(String operationId, SurgicalTeamModel team) async {
    isLoading.value = true;
    final result = await _operationRepository.assignSurgicalTeam(operationId, team);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess('Success', 'Surgical Team Assigned Successfully');
        Get.back(); // Return to dashboard/list
      },
    );
    isLoading.value = false;
  }

  /// Update surgical team and log changes (SRS-67, SRS-68, SRS-70)
  Future<void> updateSurgicalTeam(
    String operationId,
    SurgicalTeamModel team,
    String changesDescription,
  ) async {
    isLoading.value = true;
    
    final currentUserId = Get.find<AuthController>().currentUser.value?.uid ?? 'Admin';
    final auditLog = AuditLogEntryModel(
      timestamp: DateTime.now(),
      changedBy: currentUserId,
      action: 'UPDATE_TEAM',
      changes: changesDescription,
    );

    final result = await _operationRepository.updateSurgicalTeam(operationId, team, auditLog);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess('Success', 'Surgical Team Updated Successfully');
        Get.back();
      },
    );
    isLoading.value = false;
  }

  /// Update operation status and dispatch push notification to patient (SRS-100)
  Future<void> updateOperationStatus(String operationId, OperationStatus status) async {
    isLoading.value = true;
    
    // 1. Update in Firestore
    final result = await _operationRepository.updateStatus(operationId, status);
    
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) async {
        SnackbarHelper.showSuccess('Success', 'Status updated to ${status.name}');
        
        // 2. Dispatch live notification through Render backend
        _triggerStatusNotification(operationId, status);
      },
    );
    isLoading.value = false;
  }

  /// Record outcome, mark completed, and trigger automated credentials dispatch (SRS-72, SRS-73, SRS-74, SRS-95)
  Future<void> recordOutcome(String operationId, OperationOutcomeModel outcome) async {
    isLoading.value = true;
    final result = await _operationRepository.recordOutcome(operationId, outcome);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) async {
        SnackbarHelper.showSuccess('Success', 'Operation Outcome Recorded Successfully');
        
        // Trigger patient credentials automation
        _triggerCredentialsDispatch(operationId);
        
        Get.back();
      },
    );
    isLoading.value = false;
  }

  /// Upload medical report file to Cloudinary and append URL (SRS-76, SRS-78)
  Future<void> uploadMedicalReport(File file, String operationId) async {
    isLoading.value = true;
    final result = await _operationRepository.uploadMedicalReport(file, operationId);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (secureUrl) {
        SnackbarHelper.showSuccess('Success', 'Medical Report Uploaded Successfully');
      },
    );
    isLoading.value = false;
  }

  /// Fetch history list with filters and infinite scroll pagination (SRS-79, SRS-80)
  Future<void> fetchHistory({bool isRefresh = false, Map<String, dynamic>? filters}) async {
    if (isRefresh) {
      _lastDocument = null;
      hasMore.value = true;
      operationsList.clear();
    }

    if (!hasMore.value) return;

    isLoading.value = true;
    final result = await _operationRepository.fetchOperationHistory(
      limit: 10,
      startAfter: _lastDocument,
      filters: filters,
    );

    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (list) {
        if (list.length < 10) {
          hasMore.value = false;
        }
        operationsList.addAll(list);
        
        // Save last document snapshot for next page fetch
        if (list.isNotEmpty) {
          _lastDocument = null;
          _updateLastDocReference(list.last.operationId);
        }
      },
    );
    isLoading.value = false;
  }

  /// Real-time listener for patient operation updates
  Stream<OperationModel?> watchPatientOperation(String patientId) {
    return _operationRepository.watchPatientOperationStatus(patientId);
  }

  // ─── Private Automation Helpers ──────────────────────────────────────────

  /// Fetches patient FCM token and calls Render endpoint (SRS-100)
  void _triggerStatusNotification(String operationId, OperationStatus status) async {
    try {
      final opRes = await _operationRepository.fetchOperation(operationId);
      opRes.fold((_) {}, (operation) async {
        final patientDoc = await FirebaseFirestore.instance.collection('users').doc(operation.patientId).get();
        if (patientDoc.exists) {
          final patientUser = UserModel.fromMap(patientDoc.data()!, patientDoc.id);
          final fcmToken = patientUser.fcmToken;
          if (fcmToken != null && fcmToken.isNotEmpty) {
            await RenderApiService.sendOperationStatusNotification(
              fcmToken: fcmToken,
              title: 'OT Live Tracking Update',
              body: 'Your operation status has been updated to: ${status.name.toUpperCase()}',
              operationId: operationId,
              newStatus: status.name,
            );
          }
        }
      });
    } catch (e) {
      print('OperationController._triggerStatusNotification Exception: $e');
    }
  }

  /// Sets deep-link expiry in Firestore and calls Render Resend endpoint (SRS-73, SRS-74, SRS-95)
  void _triggerCredentialsDispatch(String operationId) async {
    try {
      final opRes = await _operationRepository.fetchOperation(operationId);
      opRes.fold((_) {}, (operation) async {
        final patientId = operation.patientId;
        final patientDoc = await FirebaseFirestore.instance.collection('users').doc(patientId).get();
        if (patientDoc.exists) {
          final user = UserModel.fromMap(patientDoc.data()!, patientDoc.id);

          // 1. Set 24h expiry token and isFirstLogin in Firestore (SRS-95)
          final expiry = DateTime.now().add(const Duration(hours: 24));
          await FirebaseFirestore.instance.collection('users').doc(patientId).update({
            'tokenExpiry': Timestamp.fromDate(expiry),
            'isFirstLogin': true,
          });

          // 2. Generate temporary password (e.g. pat123) and dispatch via Render
          final tempPassword = 'OTP_Temp_${DateTime.now().millisecondsSinceEpoch % 10000}';
          final deepLink = 'https://otpta-app.web.app/reset-password?uid=$patientId';

          await RenderApiService.sendPatientCredentials(
            email: user.email,
            name: user.displayName ?? 'Patient',
            temporaryPassword: tempPassword,
            deepLink: deepLink,
          );
        }
      });
    } catch (e) {
      print('OperationController._triggerCredentialsDispatch Exception: $e');
    }
  }

  void _updateLastDocReference(String operationId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('operations').doc(operationId).get();
      _lastDocument = doc;
    } catch (_) {}
  }
}
