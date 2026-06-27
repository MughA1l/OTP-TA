import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../modules/splash/views/splash_screen.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/onboarding/views/onboarding_screen.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/auth/bindings/auth_binding.dart';

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
      // login_screen.dart — will be created in Step 3.3
      page: () => const Scaffold(backgroundColor: Color(0xFF080A0E), body: Center(child: CircularProgressIndicator())),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      // forgot_password_screen.dart — will be created in Step 3.4
      page: () => const Scaffold(backgroundColor: Color(0xFF080A0E), body: Center(child: CircularProgressIndicator())),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      // change_password_screen.dart — will be created in Step 3.5
      page: () => const Scaffold(backgroundColor: Color(0xFF080A0E), body: Center(child: CircularProgressIndicator())),
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
  ];
}
