import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/patient_model.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../shared_widgets/inputs/app_password_field.dart';
import '../../patient/controllers/patient_management_controller.dart';

class AddPatientScreen extends GetView<PatientManagementController> {
  const AddPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final medicalHistoryCtrl = TextEditingController();
    final emergencyNameCtrl = TextEditingController();
    final emergencyPhoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    // Auto-generate Unique Patient ID (SRS-25)
    final String generatedId =
        'PT-${Random().nextInt(9999).toString().padLeft(4, '0')}';

    final isWeb = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Register Patient', style: AppTextStyles.headlineMedium),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.6),
                  radius: 1.0,
                  colors: [AppColors.primaryContainer, AppColors.background],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 600 : double.infinity,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingXL),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXL,
                          ),
                          border: Border.all(
                            color: AppColors.glassBorder,
                            width: 1,
                          ),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Patient ID Display
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    AppDimensions.paddingM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusM,
                                    ),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Auto-generated Patient ID:',
                                        style: AppTextStyles.labelLarge,
                                      ),
                                      Text(
                                        generatedId,
                                        style: AppTextStyles.headlineMedium
                                            .copyWith(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // Section: Personal Data
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 100),
                                child: Text(
                                  'Personal Information',
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 150),
                                child: AppTextField(
                                  controller: nameCtrl,
                                  label: 'Full Name',
                                  prefixIcon: Icons.person_outline,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 200),
                                child: AppTextField(
                                  controller: phoneCtrl,
                                  label: 'Phone Number',
                                  prefixIcon: Icons.phone_outlined,
                                  validator: Validators.validatePhone,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 250),
                                child: AppTextField(
                                  controller: addressCtrl,
                                  label: 'Address',
                                  prefixIcon: Icons.home_outlined,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // Section: Medical History
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 300),
                                child: Text(
                                  'Medical Info',
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 350),
                                child: AppTextField(
                                  controller: medicalHistoryCtrl,
                                  label: 'Medical History (Optional)',
                                  hint: 'Allergies, past conditions, etc.',
                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // Section: Emergency Contact
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 400),
                                child: Text(
                                  'Emergency Contact',
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 450),
                                child: AppTextField(
                                  controller: emergencyNameCtrl,
                                  label: 'Contact Name',
                                  prefixIcon: Icons.person_outline,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 500),
                                child: AppTextField(
                                  controller: emergencyPhoneCtrl,
                                  label: 'Contact Phone',
                                  prefixIcon: Icons.phone_outlined,
                                  validator: Validators.validatePhone,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // Account Setup
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 550),
                                child: Text(
                                  'Account Setup',
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 600),
                                child: AppPasswordField(
                                  controller: passwordCtrl,
                                  label: 'Initial Password',
                                  validator: Validators.validatePassword,
                                ),
                              ),

                              const SizedBox(height: AppDimensions.paddingXXL),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 650),
                                child: Obx(
                                  () => PrimaryButton(
                                    label: 'Register Patient',
                                    isLoading: controller.isLoading.value,
                                    icon: Icons.how_to_reg_rounded,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        final newPatient = PatientModel(
                                          patientId: generatedId,
                                          uid: '', // Set by controller
                                          name: nameCtrl.text,
                                          phone: phoneCtrl.text,
                                          address: addressCtrl.text,
                                          medicalHistory: {
                                            'notes': medicalHistoryCtrl.text,
                                          },
                                          emergencyContact: {
                                            'name': emergencyNameCtrl.text,
                                            'phone': emergencyPhoneCtrl.text,
                                          },
                                          createdAt: DateTime.now(),
                                        );
                                        controller.createPatient(
                                          newPatient,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
