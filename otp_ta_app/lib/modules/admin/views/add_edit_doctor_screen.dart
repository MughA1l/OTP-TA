import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/doctor_model.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_password_field.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../doctor/controllers/doctor_management_controller.dart';

class AddEditDoctorScreen extends GetView<DoctorManagementController> {
  const AddEditDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if we're editing an existing doctor
    final DoctorModel? existingDoctor = Get.arguments as DoctorModel?;
    final bool isEditing = existingDoctor != null;

    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existingDoctor?.name ?? '');
    final emailCtrl = TextEditingController(text: existingDoctor?.email ?? '');
    final phoneCtrl = TextEditingController(text: existingDoctor?.phone ?? '');
    final pmdcCtrl = TextEditingController(text: existingDoctor?.pmdc ?? '');
    final qualCtrl = TextEditingController(text: existingDoctor?.qualifications ?? '');
    final expCtrl = TextEditingController(text: existingDoctor?.experience ?? '');
    final passwordCtrl = TextEditingController();

    // Specializations chip input state
    final RxList<String> specializations = RxList<String>.from(existingDoctor?.specializations ?? []);
    final specializationInputCtrl = TextEditingController();

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
        title: Text(
          isEditing ? 'Edit Doctor Profile' : 'Add Doctor',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.5, -0.5),
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
                  constraints: BoxConstraints(maxWidth: isWeb ? 640 : double.infinity),
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
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ── Personal Info Section ──────────────────────
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                child: Text('Personal Information', style: AppTextStyles.titleLarge),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 60),
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
                                delay: const Duration(milliseconds: 120),
                                child: AppTextField(
                                  controller: emailCtrl,
                                  label: 'Email Address',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.validateEmail,
                                  enabled: !isEditing, // Email immutable when editing
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 180),
                                child: AppTextField(
                                  controller: phoneCtrl,
                                  label: 'Phone Number',
                                  prefixIcon: Icons.phone_outlined,
                                  validator: Validators.validatePhone,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // ── Professional Info Section ─────────────────
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 240),
                                child: Text('Professional Information', style: AppTextStyles.titleLarge),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 300),
                                child: AppTextField(
                                  controller: pmdcCtrl,
                                  label: 'PMDC Registration No.',
                                  prefixIcon: Icons.badge_outlined,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 360),
                                child: AppTextField(
                                  controller: qualCtrl,
                                  label: 'Qualifications',
                                  hint: 'e.g., MBBS, FCPS',
                                  prefixIcon: Icons.school_outlined,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 420),
                                child: AppTextField(
                                  controller: expCtrl,
                                  label: 'Years of Experience',
                                  hint: 'e.g., 5 years',
                                  prefixIcon: Icons.history_edu_outlined,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // ── Specializations Chip Input ────────────────
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 480),
                                child: Text('Specializations', style: AppTextStyles.titleLarge),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 540),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        controller: specializationInputCtrl,
                                        label: 'Add Specialization',
                                        hint: 'e.g., Cardiology',
                                        prefixIcon: Icons.local_hospital_outlined,
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.paddingM),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          final val = specializationInputCtrl.text.trim();
                                          if (val.isNotEmpty && !specializations.contains(val)) {
                                            specializations.add(val);
                                            specializationInputCtrl.clear();
                                          }
                                        },
                                        icon: const Icon(Icons.add, color: AppColors.onPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              // Chip display
                              Obx(() {
                                if (specializations.isEmpty) {
                                  return Text(
                                    'No specializations added yet.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  );
                                }
                                return Wrap(
                                  spacing: AppDimensions.paddingS,
                                  runSpacing: AppDimensions.paddingS,
                                  children: specializations.map((spec) {
                                    return Chip(
                                      label: Text(spec, style: AppTextStyles.labelLarge.copyWith(color: AppColors.onPrimary)),
                                      backgroundColor: AppColors.primary,
                                      deleteIcon: const Icon(Icons.close, color: AppColors.onPrimary, size: 16),
                                      onDeleted: () => specializations.remove(spec),
                                      side: BorderSide.none,
                                    );
                                  }).toList(),
                                );
                              }),
                              const SizedBox(height: AppDimensions.paddingL),

                              // ── Account Setup (Create only) ───────────────
                              if (!isEditing) ...[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  delay: const Duration(milliseconds: 600),
                                  child: Text('Account Setup', style: AppTextStyles.titleLarge),
                                ),
                                const SizedBox(height: AppDimensions.paddingM),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  delay: const Duration(milliseconds: 660),
                                  child: AppPasswordField(
                                    controller: passwordCtrl,
                                    label: 'Initial Password',
                                    validator: Validators.validatePassword,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingL),
                              ],

                              // ── Account Status (Edit only) ────────────────
                              if (isEditing) ...[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  delay: const Duration(milliseconds: 600),
                                  child: _AccountStatusRow(
                                    uid: existingDoctor.doctorId,
                                    onStatusChanged: controller.updateAccountStatus,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingL),
                              ],

                              // ── Submit ────────────────────────────────────
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 720),
                                child: Obx(() => PrimaryButton(
                                  label: isEditing ? 'Save Changes' : 'Add Doctor',
                                  icon: isEditing ? Icons.save_rounded : Icons.person_add_rounded,
                                  isLoading: controller.isLoading.value,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (specializations.isEmpty) {
                                        Get.snackbar(
                                          'Validation',
                                          'Please add at least one specialization.',
                                          backgroundColor: AppColors.error,
                                          colorText: AppColors.onPrimary,
                                        );
                                        return;
                                      }

                                      final doctor = DoctorModel(
                                        doctorId: existingDoctor?.doctorId ?? '',
                                        name: nameCtrl.text.trim(),
                                        email: emailCtrl.text.trim(),
                                        phone: phoneCtrl.text.trim(),
                                        qualifications: qualCtrl.text.trim(),
                                        specializations: specializations.toList(),
                                        pmdc: pmdcCtrl.text.trim(),
                                        experience: expCtrl.text.trim(),
                                        availabilitySlots: existingDoctor?.availabilitySlots ?? [],
                                        profilePicUrl: existingDoctor?.profilePicUrl,
                                        createdAt: existingDoctor?.createdAt ?? DateTime.now(),
                                      );

                                      if (isEditing) {
                                        controller.updateDoctor(doctor);
                                      } else {
                                        controller.createDoctor(doctor, passwordCtrl.text);
                                      }
                                    }
                                  },
                                )),
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

/// Account status change row widget (edit mode only)
class _AccountStatusRow extends StatelessWidget {
  final String uid;
  final Future<void> Function(String uid, String status) onStatusChanged;

  const _AccountStatusRow({required this.uid, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    final RxString selectedStatus = 'active'.obs;

    final statusOptions = [
      {'value': 'active', 'label': 'Active', 'color': AppColors.success},
      {'value': 'suspended', 'label': 'Suspended', 'color': AppColors.warning},
      {'value': 'deactivated', 'label': 'Deactivated', 'color': AppColors.error},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account Status', style: AppTextStyles.titleLarge),
        const SizedBox(height: AppDimensions.paddingM),
        Obx(() => Wrap(
          spacing: AppDimensions.paddingM,
          children: statusOptions.map((opt) {
            final isSelected = selectedStatus.value == opt['value'];
            return GestureDetector(
              onTap: () {
                selectedStatus.value = opt['value'] as String;
                onStatusChanged(uid, opt['value'] as String);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (opt['color'] as Color).withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  border: Border.all(
                    color: isSelected
                        ? opt['color'] as Color
                        : AppColors.glassBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  opt['label'] as String,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected ? opt['color'] as Color : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}
