import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../controllers/patient_management_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class PatientProfileScreen extends GetView<PatientManagementController> {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final uid = authController.currentUser.value?.uid ?? '';

    // Fetch on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uid.isNotEmpty) {
        controller.fetchPatientProfile(uid);
      }
    });

    final formKey = GlobalKey<FormState>();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('My Profile', style: AppTextStyles.headlineMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.currentPatient.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final patient = controller.currentPatient.value;
        if (patient == null) {
          return Center(
            child: Text('Profile not found.', style: AppTextStyles.bodyLarge),
          );
        }

        // Initialize controllers
        phoneCtrl.text = patient.phone;
        addressCtrl.text = patient.address;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Info Card (Editable - SRS-28)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: _buildGlassCard(
                  title: 'Basic Information',
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryContainer,
                            radius: 30,
                            child: Text(
                              patient.name.isNotEmpty
                                  ? patient.name[0].toUpperCase()
                                  : 'P',
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            patient.name,
                            style: AppTextStyles.headlineMedium,
                          ),
                          subtitle: Text(
                            'ID: ${patient.patientId}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingL),
                        AppTextField(
                          controller: phoneCtrl,
                          label: 'Phone Number',
                          prefixIcon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: AppDimensions.paddingM),
                        AppTextField(
                          controller: addressCtrl,
                          label: 'Address',
                          prefixIcon: Icons.home_outlined,
                        ),
                        const SizedBox(height: AppDimensions.paddingL),
                        PrimaryButton(
                          label: 'Update Info',
                          icon: Icons.save_rounded,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final updated = patient.copyWith(
                                phone: phoneCtrl.text,
                                address: addressCtrl.text,
                              );
                              controller.updatePatient(updated);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),

              // Medical Info (Read-Only)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                child: _buildGlassCard(
                  title: 'Medical History',
                  child: Text(
                    patient.medicalHistory['notes'] ??
                        'No medical history recorded.',
                    style: AppTextStyles.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),

              // Emergency Contact (Read-Only)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: _buildGlassCard(
                  title: 'Emergency Contact',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.person_outline,
                        'Name',
                        patient.emergencyContact['name'] ?? 'N/A',
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'Phone',
                        patient.emergencyContact['phone'] ?? 'N/A',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGlassCard({required String title, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppDimensions.paddingM),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: AppDimensions.paddingS),
        Text(
          '$label: ',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(child: Text(value, style: AppTextStyles.bodyLarge)),
      ],
    );
  }
}
