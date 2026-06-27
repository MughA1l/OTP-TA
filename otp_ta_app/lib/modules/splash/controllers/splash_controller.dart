import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _checkInitialState();
  }

  void _checkInitialState() async {
    // Artificial delay to show the beautiful splash animations
    await Future.delayed(const Duration(milliseconds: 2500));

    final bool isFirstLaunch = _storage.read<bool>('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Normally we'd fetch the user's role from Firestore here and route appropriately
        // For now, if logged in, we send to a default dashboard
        // We will refine this in Phase 3
        Get.offAllNamed(AppRoutes.patientDashboard);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    }
  }
}
