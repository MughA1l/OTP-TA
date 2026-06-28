import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../modules/splash/views/splash_screen.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/onboarding/views/onboarding_screen.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/forgot_password_screen.dart';
import '../modules/auth/views/change_password_screen.dart';
import '../modules/admin/bindings/admin_dashboard_binding.dart';
import '../modules/admin/views/admin_dashboard_screen.dart';
import '../modules/admin/bindings/staff_binding.dart';
import '../modules/admin/views/staff_list_screen.dart';
import '../modules/admin/views/add_edit_staff_screen.dart';
import '../modules/admin/bindings/role_permission_binding.dart';
import '../modules/admin/views/role_permissions_screen.dart';
import '../modules/doctor/bindings/doctor_binding.dart';
import '../modules/admin/views/doctor_list_screen.dart';
import '../modules/admin/views/add_edit_doctor_screen.dart';
import '../modules/doctor/views/doctor_availability_screen.dart';
import '../modules/appointment/bindings/appointment_binding.dart';
import '../modules/appointment/views/appointment_list_screen.dart';
import '../modules/appointment/views/book_appointment_screen.dart';
import '../modules/doctor/bindings/assigned_patients_binding.dart';
import '../modules/doctor/views/assigned_patients_screen.dart';
import '../modules/doctor/views/patient_detail_screen.dart';
import '../modules/patient/bindings/patient_dashboard_binding.dart';
import '../modules/patient/views/patient_dashboard_screen.dart';
import '../modules/patient/bindings/operation_tracking_binding.dart';
import '../modules/patient/views/operation_status_screen.dart';
import '../modules/patient/bindings/check_up_history_binding.dart';
import '../modules/patient/views/check_up_history_screen.dart';
import '../modules/patient/bindings/patient_binding.dart';
import '../modules/admin/views/patient_list_screen.dart';
import '../modules/admin/views/add_patient_screen.dart';
import '../modules/patient/views/patient_profile_screen.dart';
import '../modules/operation/bindings/operation_binding.dart';
import '../modules/operation/views/create_operation_screen.dart';
import '../modules/operation/views/assign_team_screen.dart';
import '../modules/operation/views/record_outcome_screen.dart';
import '../modules/operation/views/operation_detail_screen.dart';
import '../modules/operation/views/operation_list_screen.dart';
import '../modules/medication/bindings/medication_binding.dart';
import '../modules/medication/views/prescription_screen.dart';
import '../modules/medication/views/medication_schedule_screen.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.doctorDashboard,
      page: () => const Scaffold(body: Center(child: Text('Doctor Dashboard'))),
    ),
    GetPage(
      name: AppRoutes.patientDashboard,
      page: () => const PatientDashboardScreen(),
      binding: PatientDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.operationTracking,
      page: () => const OperationStatusScreen(),
      binding: OperationTrackingBinding(),
    ),
    GetPage(
      name: AppRoutes.staffList,
      page: () => const StaffListScreen(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: AppRoutes.addEditStaff,
      page: () => const AddEditStaffScreen(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: AppRoutes.rolePermissions,
      page: () => const RolePermissionsScreen(),
      binding: RolePermissionBinding(),
    ),
    GetPage(
      name: AppRoutes.doctorList,
      page: () => const DoctorListScreen(),
      binding: DoctorBinding(),
    ),
    GetPage(
      name: AppRoutes.addEditDoctor,
      page: () => const AddEditDoctorScreen(),
      binding: DoctorBinding(),
    ),
    GetPage(
      name: AppRoutes.doctorAvailability,
      page: () => const DoctorAvailabilityScreen(),
      binding: DoctorBinding(),
    ),
    GetPage(
      name: AppRoutes.appointmentList,
      page: () => const AppointmentListScreen(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: AppRoutes.bookAppointment,
      page: () => const BookAppointmentScreen(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: AppRoutes.assignedPatients,
      page: () => const AssignedPatientsScreen(),
      binding: AssignedPatientsBinding(),
    ),
    GetPage(
      name: AppRoutes.patientDetail,
      page: () => const PatientDetailScreen(),
      binding: AssignedPatientsBinding(),
    ),
    GetPage(
      name: AppRoutes.patientList,
      page: () => const PatientListScreen(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: AppRoutes.addPatient,
      page: () => const AddPatientScreen(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: AppRoutes.patientProfile,
      page: () => const PatientProfileScreen(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: AppRoutes.checkUpHistory,
      page: () => const CheckUpHistoryScreen(),
      binding: CheckUpHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.createOperation,
      page: () => const CreateOperationScreen(),
      binding: OperationBinding(),
    ),
    GetPage(
      name: AppRoutes.assignTeam,
      page: () => const AssignTeamScreen(),
      binding: OperationBinding(),
    ),
    GetPage(
      name: AppRoutes.recordOutcome,
      page: () => const RecordOutcomeScreen(),
      binding: OperationBinding(),
    ),
    GetPage(
      name: AppRoutes.operationDetail,
      page: () => const OperationDetailScreen(),
      binding: OperationBinding(),
    ),
    GetPage(
      name: AppRoutes.operationList,
      page: () => const OperationListScreen(),
      binding: OperationBinding(),
    ),
    GetPage(
      name: AppRoutes.prescription,
      page: () => const PrescriptionScreen(),
      binding: MedicationBinding(),
    ),
    GetPage(
      name: AppRoutes.medicationSchedule,
      page: () => const MedicationScheduleScreen(),
      binding: MedicationBinding(),
    ),
  ];
}
