import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/services/security_hardening_service.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Safe Firebase Initialization to prevent black screen on launch failure
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // Initialize GetStorage for session persistence
  await GetStorage.init();
  await SecurityHardeningService.initializeAppCheck();

  // runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true, // Required for DevicePreview
      locale: DevicePreview.locale(context), // Required for DevicePreview
      builder: DevicePreview.appBuilder, // Required for DevicePreview
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
