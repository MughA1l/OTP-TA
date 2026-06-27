import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/appointment_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/assigned_patients_controller.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../core/utils/snackbar_helper.dart';

class AssignedPatientsScreen extends GetView<AssignedPatientsController> {
  const AssignedPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('My Patients', style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (context, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.primary,
                      surface: AppColors.surface,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                controller.setDateFilter(picked);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Header / Filters ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: const BoxDecoration(
              color: AppColors.surfaceOverlay,
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Appointments For:', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    Obx(() {
                      final d = controller.selectedDate.value;
                      return Text(
                        '${d.day}/${d.month}/${d.year}',
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                AppTextField(
                  controller: TextEditingController(),
                  label: 'Search Patient',
                  hint: 'Name or ID',
                  prefixIcon: Icons.search_rounded,
                  onChanged: controller.setSearchQuery,
                ),
              ],
            ),
          ),
          
          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.filteredAppointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined, size: 64, color: AppColors.textSecondary),
                      const SizedBox(height: AppDimensions.paddingM),
                      Text('No patients assigned for this date.', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                itemCount: controller.filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appt = controller.filteredAppointments[index];
                  // Use FadeInUp stagger (SRS-47)
                  return FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: Duration(milliseconds: 50 * index),
                    child: _PatientAppointmentCard(appointment: appt),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PatientAppointmentCard extends GetView<AssignedPatientsController> {
  final AppointmentModel appointment;
  const _PatientAppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final patient = controller.getPatientDetails(appointment.patientId);
        if (patient != null) {
          Get.toNamed(AppRoutes.patientDetail, arguments: {
            'patient': patient,
            'appointment': appointment,
          });
        } else {
          SnackbarHelper.showError('Info', 'Loading patient details, please wait...');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final patient = controller.getPatientDetails(appointment.patientId);
                    return Expanded(
                      child: Text(
                        patient?.name ?? 'Loading...',
                        style: AppTextStyles.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                  _StatusChip(status: appointment.status),
                ],
              ),
              const SizedBox(height: 4),
              Text('ID: ${appointment.patientId}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppDimensions.paddingS),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    appointment.notes ?? 'Scheduled Slot',
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final AppointmentStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case AppointmentStatus.scheduled:
        color = AppColors.primary;
        label = 'Scheduled';
        break;
      case AppointmentStatus.completed:
        color = AppColors.success;
        label = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelled';
        break;
      case AppointmentStatus.noShow:
        color = AppColors.warning;
        label = 'No Show';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label, style: AppTextStyles.labelMedium.copyWith(color: color)),
    );
  }
}
