import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/services/render_api_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/operation_model.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/staff_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/operation_repository.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/staff_repository.dart';

class OperationController extends GetxController {
  final IOperationRepository _operationRepository;
  final IPatientRepository _patientRepository;
  final IDoctorRepository _doctorRepository;
  final IStaffRepository _staffRepository;

  OperationController({
    required IOperationRepository operationRepository,
    required IPatientRepository patientRepository,
    required IDoctorRepository doctorRepository,
    required IStaffRepository staffRepository,
  })  : _operationRepository = operationRepository,
        _patientRepository = patientRepository,
        _doctorRepository = doctorRepository,
        _staffRepository = staffRepository;

  final RxBool isLoading = false.obs;
  final RxList<OperationModel> operationsList = <OperationModel>[].obs;
  final Rx<OperationModel?> selectedOperation = Rx<OperationModel?>(null);

  // Observable lists of Patients, Doctors, and Staff
  final RxList<PatientModel> patientList = <PatientModel>[].obs;
  final RxList<DoctorModel> doctorList = <DoctorModel>[].obs;
  final RxList<StaffModel> staffList = <StaffModel>[].obs;

  // For pagination in history
  DocumentSnapshot? _lastDocument;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    _watchPatients();
    _watchDoctors();
    _watchStaff();
    _watchAllOperations(); // Watch operations list to perform real-time conflict checking
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

  void _watchStaff() {
    _staffRepository.watchAllStaff().listen(
      (list) => staffList.value = list,
      onError: (_) => SnackbarHelper.showError('Error', 'Failed to load staff list.'),
    );
  }

  void _watchAllOperations() {
    // Listens to operations snapshots to populate operationsList for real-time conflicts
    FirebaseFirestore.instance.collection('operations').snapshots().listen((qs) {
      operationsList.value = qs.docs.map((doc) => OperationModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Checks if a doctor has an overlapping operation at the given scheduledDateTime
  bool isDoctorAvailable(String doctorId, DateTime scheduledDateTime) {
    if (doctorId.isEmpty) return true;
    
    // Check if doctor has any other active operation scheduled on the same date/hour
    final hasConflict = operationsList.any((op) {
      if (op.operationId == selectedOperation.value?.operationId) return false; // Ignore current operation
      if (op.status == OperationStatus.cancelled || op.status == OperationStatus.completed) return false;
      if (op.surgicalTeam.primaryDoctorId != doctorId && op.surgicalTeam.anaesthesiologistId != doctorId) return false;
      
      // If dates match and time is within, say, 2 hours (or same hour)
      final difference = op.scheduledDate.difference(scheduledDateTime).inHours.abs();
      return difference < 2; // Conflict if operations are within 2 hours
    });
    
    return !hasConflict;
  }

  /// Checks if a doctor's weekly availability slots contain the proposed day
  bool isDoctorScheduledSlotValid(DoctorModel doctor, DateTime dateTime) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = days[dateTime.weekday - 1];
    
    if (doctor.availabilitySlots.isEmpty) return true;
    
    return doctor.availabilitySlots.any((slot) => slot.startsWith(dayName));
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
