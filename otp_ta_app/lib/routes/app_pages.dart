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
import '../modules/admin/bindings/staff_binding.dart';
import '../modules/admin/views/staff_list_screen.dart';
import '../modules/admin/views/add_edit_staff_screen.dart';
import '../modules/admin/bindings/role_permission_binding.dart';
import '../modules/admin/views/role_permissions_screen.dart';
import '../modules/doctor/bindings/doctor_binding.dart';
import '../modules/admin/views/doctor_list_screen.dart';
import '../modules/admin/views/add_edit_doctor_screen.dart';
import '../modules/doctor/views/doctor_availability_screen.dart';
import '../modules/patient/bindings/patient_binding.dart';
import '../modules/admin/views/patient_list_screen.dart';
import '../modules/admin/views/add_patient_screen.dart';
import '../modules/patient/views/patient_profile_screen.dart';

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
      page: () => const Scaffold(body: Center(child: Text('Admin Dashboard'))),
    ),
    GetPage(
      name: AppRoutes.doctorDashboard,
      page: () => const Scaffold(body: Center(child: Text('Doctor Dashboard'))),
    ),
    GetPage(
      name: AppRoutes.patientDashboard,
      page: () => const Scaffold(body: Center(child: Text('Patient Dashboard'))),
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
  ];
}
