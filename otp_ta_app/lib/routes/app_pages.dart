import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const Scaffold(body: Center(child: Text('Splash Screen'))),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const Scaffold(body: Center(child: Text('Onboarding Screen'))),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const Scaffold(body: Center(child: Text('Sign In Screen'))),
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
