import 'package:flutter/material.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../utils/snackbar_helper.dart';

class SecurityHardeningService {
  static Future<void> initializeAppCheck() async {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      );
    } catch (_) {
      // App Check is optional in local debug builds and should never break launch.
    }
  }

  static Future<void> logSecurityEvent({
    required String eventName,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('security_audit').add({
        'eventName': eventName,
        'uid': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'payload': payload,
      });
    } catch (_) {
      // Audit logging is best-effort and should not break the main user flow.
    }
  }

  static void showSessionWarning() {
    SnackbarHelper.showWarning(
      AppStrings.sessionExpiredTitle,
      AppStrings.sessionExpiredMessage,
    );
  }

  static Future<void> signOutAndWarn() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(AppRoutes.signIn);
      showSessionWarning();
    } catch (_) {
      Get.offAllNamed(AppRoutes.signIn);
    }
  }

  static Widget buildSecurityNotice(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.infoContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          const Icon(Icons.security_rounded, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
