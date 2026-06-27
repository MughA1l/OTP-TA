import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final IAuthRepository _authRepository;

  AuthController({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final GetStorage _storage = GetStorage();

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Listen to Firebase auth state changes for persistent session
    FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) async {
    if (user == null) {
      currentUser.value = null;
    } else {
      // Fetch fresh user data from Firestore on state restore
      final result = await _authRepository.fetchCurrentUserData();
      result.fold(
        (failure) => currentUser.value = null,
        (userData) {
          currentUser.value = userData;
          // Don't navigate here — SplashController handles initial routing
        },
      );
    }
  }

  // ─── Sign In ──────────────────────────────────────────────────────────────
  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    final result = await _authRepository.signIn(email, password);
    result.fold(
      (failure) {
        SnackbarHelper.showError('Error', failure.message);
      },
      (user) async {
        currentUser.value = user;
        _storage.write('userRole', user.role.name);

        // Update FCM token after successful sign in
        await _updateFcmToken(user.uid);

        // SRS-96: Force password change on first login
        if (user.isFirstLogin) {
          Get.offAllNamed(AppRoutes.changePassword);
          return;
        }

        _navigateByRole(user.role);
      },
    );
    isLoading.value = false;
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    isLoading.value = true;
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        currentUser.value = null;
        _storage.erase();
        Get.offAllNamed(AppRoutes.signIn);
      },
    );
    isLoading.value = false;
  }

  // ─── Forgot Password ──────────────────────────────────────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    isLoading.value = true;
    final result = await _authRepository.sendPasswordResetEmail(email);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess(
          'Success',
          'Password reset link sent! Please check your inbox.',
        );
        Get.back();
      },
    );
    isLoading.value = false;
  }

  // ─── Change Password ──────────────────────────────────────────────────────
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    final result = await _authRepository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess('Success', 'Password updated successfully.');
        if (currentUser.value != null) {
          _navigateByRole(currentUser.value!.role);
        } else {
          Get.offAllNamed(AppRoutes.signIn);
        }
      },
    );
    isLoading.value = false;
  }

  // ─── FCM Token Update ─────────────────────────────────────────────────────
  Future<void> _updateFcmToken(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _authRepository.updateFcmToken(uid, token);
      }
    } catch (_) {
      // Non-critical — silent fail
    }
  }

  // ─── Role-Based Navigation ────────────────────────────────────────────────
  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.receptionist:
        Get.offAllNamed(AppRoutes.adminDashboard);
      case UserRole.doctor:
        Get.offAllNamed(AppRoutes.doctorDashboard);
      case UserRole.patient:
        Get.offAllNamed(AppRoutes.patientDashboard);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  bool get isSignedIn => currentUser.value != null;
}
