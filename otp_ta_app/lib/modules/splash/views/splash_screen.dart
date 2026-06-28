import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring the controller is initialized
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient / Shimmer effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [AppColors.primaryContainer, AppColors.background],
                    radius: 1.5,
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Fade + Scale
                ZoomIn(
                  duration: const Duration(milliseconds: 900),
                  child: FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOverlay,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.glassBorder,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App Title
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                  child: Text(
                    'OTP & TA',
                    style: AppTextStyles.displayMedium.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline text with Slide upward
                SlideInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 800),
                  child: FadeIn(
                    delay: const Duration(milliseconds: 800),
                    child: Text(
                      'OT Procedures & Tracking',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom loading indicator
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeIn(
              delay: const Duration(milliseconds: 1200),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
