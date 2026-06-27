import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/appointment_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/appointment_controller.dart';

class AppointmentListScreen extends GetView<AppointmentController> {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Appointments', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.bookAppointment),
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.onPrimary),
              label: Text('Book', style: AppTextStyles.labelLarge.copyWith(color: AppColors.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Obx(() {
          if (controller.isLoading.value && controller.allAppointments.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (controller.allAppointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note_rounded, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text('No appointments yet.', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.allAppointments.length,
            itemBuilder: (context, index) {
              final appt = controller.allAppointments[index];
              return FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: 50 * index),
                child: _AppointmentCard(appointment: appt),
              );
            },
          );
        }),
      ),
    );
  }
}

// ── Appointment Card ──────────────────────────────────────────────────────────

class _AppointmentCard extends GetView<AppointmentController> {
  final AppointmentModel appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient: ${appointment.patientId}',
                        style: AppTextStyles.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dr. ${appointment.doctorId}',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: appointment.status),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}  ${appointment.notes ?? ''}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            // Action row
            if (appointment.status == AppointmentStatus.scheduled) ...[
              Row(
                children: [
                  _actionButton(
                    label: 'Reschedule',
                    icon: Icons.edit_calendar_rounded,
                    color: AppColors.warning,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: appointment.dateTime.isAfter(DateTime.now())
                            ? appointment.dateTime
                            : DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
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
                        controller.reschedule(appointment.appointmentId, picked);
                      }
                    },
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  _actionButton(
                    label: 'Cancel',
                    icon: Icons.cancel_outlined,
                    color: AppColors.error,
                    onTap: () => Get.dialog(_CancelConfirmDialog(
                      onConfirm: () => controller.cancel(appointment.appointmentId),
                    )),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  _actionButton(
                    label: 'Completed',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                    onTap: () => controller.updateStatus(appointment.appointmentId, AppointmentStatus.completed),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingXS,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.labelMedium.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Status Chip ───────────────────────────────────────────────────────────────

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

// ── Cancel Confirm Dialog ─────────────────────────────────────────────────────

class _CancelConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _CancelConfirmDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Cancel Appointment', style: AppTextStyles.titleLarge),
      content: Text('This will free up the time slot immediately. Are you sure?', style: AppTextStyles.bodyLarge),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('No', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: Text('Yes, Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.onPrimary)),
        ),
      ],
    );
  }
}
