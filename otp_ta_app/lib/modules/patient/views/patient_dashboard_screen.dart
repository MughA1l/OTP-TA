import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/patient_dashboard_controller.dart';
import '../../../routes/app_routes.dart';

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
                    const SizedBox(height: AppDimensions.paddingXL),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 200),
                      child: Text('Quick Actions', style: AppTextStyles.titleLarge),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 250),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Get.toNamed(AppRoutes.checkUpHistory),
                              icon: const Icon(Icons.history_rounded),
                              label: const Text('Check-up History'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                foregroundColor: AppColors.primaryLight,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                  side: const BorderSide(color: AppColors.glassBorder),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
          
          const SizedBox(height: AppDimensions.paddingM),
          Text('Assigned Doctor', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Obx(() {
            final doc = controller.getDoctorForAppointment(appointment.doctorId);
            if (doc == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryContainer,
                        backgroundImage: doc.profilePicUrl != null && doc.profilePicUrl!.isNotEmpty
                            ? NetworkImage(doc.profilePicUrl!)
                            : null,
                        child: doc.profilePicUrl == null || doc.profilePicUrl!.isEmpty
                            ? Text(doc.name[0].toUpperCase(), style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary))
                            : null,
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dr. ${doc.name}', style: AppTextStyles.titleLarge),
                            Text(
                              doc.specializations.isNotEmpty ? doc.specializations.join(', ') : 'General',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigate to Chat Room
                          // Get.toNamed(AppRoutes.chatRoom, arguments: {'doctorId': doc.doctorId});
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                        tooltip: 'Chat with Doctor',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DoctorStat(label: 'PMDC', value: doc.pmdc.isNotEmpty ? doc.pmdc : 'N/A'),
                      _DoctorStat(label: 'Experience', value: doc.experience.isNotEmpty ? doc.experience : 'N/A'),
                    ],
                  ),
                  // Note: Personal mobile number intentionally hidden (SRS-56)
                ],
              ),
            );
          }),
          
          const SizedBox(height: AppDimensions.paddingL),
          Text('Time Slot', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(appointment.notes ?? 'Scheduled Slot', style: AppTextStyles.bodyLarge),
          
          const SizedBox(height: AppDimensions.paddingL),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navigate to tracking screen (ideally passing the operationId tied to this appointment)
                // For demo, we just navigate to the screen
                Get.toNamed(AppRoutes.operationTracking);
              },
              icon: const Icon(Icons.monitor_heart_outlined, color: AppColors.secondary),
              label: Text('Track Live OT Status', style: AppTextStyles.labelLarge.copyWith(color: AppColors.secondary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
              ),
            ),
          ),
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

class _DoctorStat extends StatelessWidget {
  final String label;
  final String value;

  const _DoctorStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

