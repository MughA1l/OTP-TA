import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/patient_dashboard_controller.dart';

class PatientDashboardScreen extends GetView<PatientDashboardController> {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final patient = controller.currentPatient.value;
        final upcomingAppt = controller.upcomingAppointment;
        final today = DateTime.now();

        return Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.8, -0.8),
                    radius: 1.2,
                    colors: [AppColors.primaryContainer, AppColors.background],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header Card ─────────────────────────────────────────────
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.paddingL),
                            decoration: BoxDecoration(
                              color: AppColors.glassBackground,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    patient?.name.isNotEmpty == true ? patient!.name[0].toUpperCase() : 'P',
                                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onPrimary),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.paddingM),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hello, ${patient?.name ?? 'Patient'}',
                                        style: AppTextStyles.headlineMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_getWeekday(today.weekday)}, ${today.day} ${_getMonth(today.month)}',
                                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // ── Upcoming Schedule Stat Card ──────────────────────────────
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 100),
                      child: Text('Upcoming Schedule', style: AppTextStyles.titleLarge),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 150),
                      child: upcomingAppt == null
                          ? _buildEmptyState()
                          : _buildUpcomingAppointmentCard(upcomingAppt),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_available_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: AppDimensions.paddingM),
          Text('No active schedules', style: AppTextStyles.titleLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(
            'You have no upcoming appointments at the moment.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(dynamic appointment) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}',
                    style: AppTextStyles.titleLarge,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                ),
                child: Text('Scheduled', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: AppDimensions.paddingM),
          
          Text('Assigned Doctor', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Obx(() {
            final doc = controller.getDoctorForAppointment(appointment.doctorId);
            if (doc == null) return Text('Loading...', style: AppTextStyles.bodyLarge);
            return Text(
              'Dr. ${doc.name} (${doc.specializations.isNotEmpty ? doc.specializations.first : ''})',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
            );
          }),
          
          const SizedBox(height: AppDimensions.paddingM),
          Text('Time Slot', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(appointment.notes ?? 'Scheduled Slot', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
