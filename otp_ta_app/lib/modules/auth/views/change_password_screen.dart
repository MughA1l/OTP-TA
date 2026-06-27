import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_password_field.dart';
import '../controllers/auth_controller.dart';

class ChangePasswordScreen extends GetView<AuthController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    
    final newPasswordFocus = FocusNode();
    final confirmPasswordFocus = FocusNode();

    final isWeb = ResponsiveHelper.isDesktop(context);

    // If it's a first-time login (forced reset), hide the back button
    final bool isFirstLogin = controller.currentUser.value?.isFirstLogin ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: !isFirstLogin,
        leading: isFirstLogin 
          ? null 
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
              onPressed: () => Get.back(),
            ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.6),
                  radius: 1.0,
                  colors: [
                    AppColors.primaryContainer,
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingXL,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 460 : double.infinity,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(AppDimensions.paddingL),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceOverlay,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.glassBorder, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.password_rounded,
                                size: 56,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 100),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                              child: Container(
                                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                                decoration: BoxDecoration(
                                  color: AppColors.glassBackground,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                                  border: Border.all(color: AppColors.glassBorder, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 200),
                                      child: Text(
                                        isFirstLogin ? 'Set New Password' : 'Change Password',
                                        style: AppTextStyles.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXS),
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 250),
                                      child: Text(
                                        isFirstLogin 
                                          ? 'For your security, please set a new password before continuing.'
                                          : 'Update your account password. Ensure it meets the security requirements.',
                                        style: AppTextStyles.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXL),
                                    
                                    // ─── Old Password ──────────────────────
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 300),
                                      child: AppPasswordField(
                                        controller: oldPasswordCtrl,
                                        label: 'Current Password',
                                        textInputAction: TextInputAction.next,
                                        validator: Validators.validatePassword,
                                        onFieldSubmitted: (_) => newPasswordFocus.requestFocus(),
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingM),
                                    
                                    // ─── New Password ──────────────────────
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 350),
                                      child: AppPasswordField(
                                        controller: newPasswordCtrl,
                                        label: 'New Password',
                                        focusNode: newPasswordFocus,
                                        textInputAction: TextInputAction.next,
                                        validator: Validators.validateNewPassword, // SRS-15 / SRS-16 Validation
                                        onFieldSubmitted: (_) => confirmPasswordFocus.requestFocus(),
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingM),
                                    
                                    // ─── Confirm New Password ──────────────
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 400),
                                      child: AppPasswordField(
                                        controller: confirmPasswordCtrl,
                                        label: 'Confirm New Password',
                                        focusNode: confirmPasswordFocus,
                                        textInputAction: TextInputAction.done,
                                        validator: (val) => Validators.validateConfirmPassword(val, newPasswordCtrl.text),
                                        onFieldSubmitted: (_) {
                                          if (formKey.currentState!.validate()) {
                                            controller.updatePassword(
                                              currentPassword: oldPasswordCtrl.text, 
                                              newPassword: newPasswordCtrl.text
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXXL),
                                    
                                    // ─── Update Button ─────────────────────
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 450),
                                      child: Obx(
                                        () => PrimaryButton(
                                          label: 'Update Password',
                                          isLoading: controller.isLoading.value,
                                          icon: Icons.check_circle_outline_rounded,
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              controller.updatePassword(
                                                currentPassword: oldPasswordCtrl.text, 
                                                newPassword: newPasswordCtrl.text
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
