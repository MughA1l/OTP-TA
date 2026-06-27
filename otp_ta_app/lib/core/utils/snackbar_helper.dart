import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

abstract class SnackbarHelper {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.successContainer,
      colorText: AppColors.onSuccess,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle, color: AppColors.success),
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.errorContainer,
      colorText: AppColors.onError,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error, color: AppColors.error),
      duration: const Duration(seconds: 4),
    );
  }

  static void showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warningContainer,
      colorText: AppColors.onWarning,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.warning, color: AppColors.warning),
      duration: const Duration(seconds: 3),
    );
  }
}
