import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/patient_model.dart';
import '../controllers/assigned_patients_controller.dart';
import '../../../shared_widgets/buttons/primary_button.dart';

class PatientDetailScreen extends GetView<AssignedPatientsController> {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) return const Scaffold(body: Center(child: Text('Error: No data')));

    final PatientModel patient = args['patient'] as PatientModel;
    final AppointmentModel appointment = args['appointment'] as AppointmentModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Patient Profile', style: AppTextStyles.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Profile Header ──────────────────────────────────────────────
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    Text(patient.name, style: AppTextStyles.headlineMedium),
                    Text('ID: ${patient.patientId}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // ── Patient Information ─────────────────────────────────────────
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 100),
              child: _buildInfoCard(
                title: 'Personal Information',
                icon: Icons.person_outline,
                children: [
                  _InfoRow(label: 'Age', value: '${patient.age} years'),
                  _InfoRow(label: 'Gender', value: patient.gender),
                  _InfoRow(label: 'Phone', value: patient.phone),
                  _InfoRow(label: 'Address', value: patient.address),
                  _InfoRow(label: 'Guardian', value: patient.guardianName ?? 'N/A'),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),

            // ── Medical Information ─────────────────────────────────────────
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 200),
              child: _buildInfoCard(
                title: 'Medical Information',
                icon: Icons.medical_information_outlined,
                children: [
                  _InfoRow(label: 'Blood Group', value: patient.bloodGroup),
                  _InfoRow(
                    label: 'Conditions',
                    value: patient.medicalConditions.isNotEmpty ? patient.medicalConditions.join(', ') : 'None',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // ── Appointment Actions ─────────────────────────────────────────
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 300),
              child: Text('Appointment Actions', style: AppTextStyles.titleLarge),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 400),
              child: Obx(() => Column(
                children: [
                  PrimaryButton(
                    label: 'Mark as Completed',
                    icon: Icons.check_circle_outline_rounded,
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.updateAppointmentStatus(appointment.appointmentId, AppointmentStatus.completed);
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        controller.updateAppointmentStatus(appointment.appointmentId, AppointmentStatus.noShow);
                      },
                      icon: const Icon(Icons.person_off_outlined, color: AppColors.warning),
                      label: Text('Mark as No Show', style: AppTextStyles.labelLarge.copyWith(color: AppColors.warning)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.warning),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(title, style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: AppDimensions.paddingM),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyLarge),
          ),
        ],
      ),
    );
  }
}
