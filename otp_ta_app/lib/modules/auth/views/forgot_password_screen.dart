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
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final isWeb = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
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
                                Icons.lock_reset_rounded,
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
                                        'Reset Password',
                                        style: AppTextStyles.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXS),
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 250),
                                      child: Text(
                                        'Enter your email address and we will send you a link to reset your password.',
                                        style: AppTextStyles.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXL),
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 300),
                                      child: AppTextField(
                                        controller: emailCtrl,
                                        label: 'Email Address',
                                        hint: 'doctor@hospital.com',
                                        prefixIcon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        validator: Validators.validateEmail,
                                        onFieldSubmitted: (_) {
                                          if (formKey.currentState!.validate()) {
                                            controller.sendPasswordResetEmail(emailCtrl.text);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.paddingXXL),
                                    FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: const Duration(milliseconds: 400),
                                      child: Obx(
                                        () => PrimaryButton(
                                          label: 'Send Reset Link',
                                          isLoading: controller.isLoading.value,
                                          icon: Icons.send_rounded,
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              controller.sendPasswordResetEmail(emailCtrl.text);
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
