import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../routes/app_routes.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardScreen extends GetView<AdminDashboardController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Admin Dashboard', style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            onPressed: () => Get.toNamed(AppRoutes.rolePermissions),
          ),
          const SizedBox(width: AppDimensions.paddingM),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Stat Cards ──────────────────────────────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: Wrap(
                  spacing: AppDimensions.paddingL,
                  runSpacing: AppDimensions.paddingL,
                  children: [
                    _StatCard(
                      title: 'Total Doctors',
                      value: controller.totalDoctors.toString(),
                      icon: Icons.medical_services_outlined,
                      color: AppColors.primary,
                    ),
                    _StatCard(
                      title: "Today's Appointments",
                      value: controller.totalAppointmentsToday.toString(),
                      icon: Icons.event_available_outlined,
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // ── Quick Actions ─────────────────────────────────────────────
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                child: Text('Quick Actions', style: AppTextStyles.titleLarge),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 150),
                child: Wrap(
                  spacing: AppDimensions.paddingM,
                  runSpacing: AppDimensions.paddingM,
                  children: [
                    _QuickActionBtn(
                      label: 'Manage Doctors',
                      icon: Icons.people_outline,
                      onTap: () => Get.toNamed(AppRoutes.doctorList),
                    ),
                    _QuickActionBtn(
                      label: 'Appointments',
                      icon: Icons.calendar_month_outlined,
                      onTap: () => Get.toNamed(AppRoutes.appointmentList),
                    ),
                    _QuickActionBtn(
                      label: 'Manage Staff',
                      icon: Icons.admin_panel_settings_outlined,
                      onTap: () => Get.toNamed(AppRoutes.staffList),
                    ),
                    _QuickActionBtn(
                      label: 'Manage Patients',
                      icon: Icons.accessible_forward_outlined,
                      onTap: () => Get.toNamed(AppRoutes.patientList),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),

              // ── Workload Tracking ─────────────────────────────────────────
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: Text('Doctor Workload Tracking (Today)', style: AppTextStyles.titleLarge),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 250),
                child: Container(
                  width: isDesktop ? 800 : double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.glassBackground,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.doctors.length,
                    separatorBuilder: (_, __) => const Divider(color: AppColors.glassBorder, height: 1),
                    itemBuilder: (context, index) {
                      final doc = controller.doctors[index];
                      final workload = controller.getDoctorWorkloadToday(doc.doctorId);
                      
                      // SRS-49: Warning badge if > 25 patients/day
                      final isOverloaded = workload > 25;

                      return ListTile(
                        contentPadding: const EdgeInsets.all(AppDimensions.paddingM),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            doc.name.isNotEmpty ? doc.name[0].toUpperCase() : 'D',
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                          ),
                        ),
                        title: Text(doc.name, style: AppTextStyles.titleLarge),
                        subtitle: Text(doc.specializations.join(', '), style: AppTextStyles.bodyMedium),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isOverloaded ? AppColors.warning.withOpacity(0.15) : AppColors.surfaceOverlay,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                            border: Border.all(
                              color: isOverloaded ? AppColors.warning : AppColors.glassBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$workload Patients',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isOverloaded ? AppColors.warning : AppColors.textPrimary,
                                ),
                              ),
                              if (isOverloaded) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 16),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
