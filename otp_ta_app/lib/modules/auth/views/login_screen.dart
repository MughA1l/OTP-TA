import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../shared_widgets/inputs/app_password_field.dart';
import '../../../shared_widgets/misc/app_logo.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final passwordFocus = FocusNode();

    final isWeb = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Subtle radial glow background ────────────────────────────────
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

          // ─── Main Scrollable Body ──────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingXL,
                ),
                child: ConstrainedBox(
                  // Cap card width on web for clean look
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 460 : double.infinity,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ─── Logo ────────────────────────────────────────────
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: const Center(child: AppLogo()),
                        ),

                        const SizedBox(height: AppDimensions.paddingXXL),

                        // ─── Glass Card ──────────────────────────────────────
                        FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 100),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusXL),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                              child: Container(
                                padding: const EdgeInsets.all(
                                    AppDimensions.paddingXL),
                                decoration: BoxDecoration(
                                  color: AppColors.glassBackground,
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXL),
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Welcome text
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      delay:
                                          const Duration(milliseconds: 200),
                                      child: Text(
                                        'Welcome Back',
                                        style: AppTextStyles.headlineLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: AppDimensions.paddingXS),
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      delay:
                                          const Duration(milliseconds: 250),
                                      child: Text(
                                        'Sign in to your account to continue',
                                        style: AppTextStyles.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: AppDimensions.paddingXL),

                                    // ─── Email Field ──────────────────────
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      delay:
                                          const Duration(milliseconds: 300),
                                      child: AppTextField(
                                        controller: emailCtrl,
                                        label: 'Email Address',
                                        hint: 'doctor@hospital.com',
                                        prefixIcon: Icons.email_outlined,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: Validators.validateEmail,
                                        onFieldSubmitted: (_) =>
                                            passwordFocus.requestFocus(),
                                      ),
                                    ),

                                    const SizedBox(
                                        height: AppDimensions.paddingM),

                                    // ─── Password Field ───────────────────
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      delay:
                                          const Duration(milliseconds: 400),
                                      child: AppPasswordField(
                                        controller: passwordCtrl,
                                        label: 'Password',
                                        focusNode: passwordFocus,
                                        textInputAction: TextInputAction.done,
                                        validator: Validators.validatePassword,
                                        onFieldSubmitted: (_) {
                                          if (formKey.currentState!
                                              .validate()) {
                                            controller.signIn(
                                              emailCtrl.text,
                                              passwordCtrl.text,
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                        height: AppDimensions.paddingS),

                                    // ─── Forgot Password ──────────────────
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      delay:
                                          const Duration(milliseconds: 450),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => Get.toNamed(
                                              AppRoutes.forgotPassword),
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          child: Text(
                                            'Forgot Password?',
                                            style:
                                                AppTextStyles.labelMedium.copyWith(
                                              color: AppColors.textLink,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        height: AppDimensions.paddingXL),

                                    // ─── Sign In Button ───────────────────
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      delay:
                                          const Duration(milliseconds: 500),
                                      child: Obx(
                                        () => PrimaryButton(
                                          label: 'Sign In',
                                          isLoading:
                                              controller.isLoading.value,
                                          icon: Icons.login_rounded,
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              controller.signIn(
                                                emailCtrl.text,
                                                passwordCtrl.text,
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

                        const SizedBox(height: AppDimensions.paddingXL),

                        // ─── Version note ─────────────────────────────────
                        FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          delay: const Duration(milliseconds: 600),
                          child: Text(
                            'OT Procedures & Tracking App v1.0',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.center,
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
