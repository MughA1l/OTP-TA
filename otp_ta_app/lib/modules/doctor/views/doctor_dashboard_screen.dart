import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Doctor Dashboard', style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () => authController.signOut(),
          ),
          const SizedBox(width: AppDimensions.paddingM),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Greeting Header ──────────────────────────────────────────────
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Card(
                color: AppColors.surfaceElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  side: const BorderSide(color: AppColors.glassBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          currentUser?.displayName != null &&
                                  currentUser!.displayName!.isNotEmpty
                              ? currentUser.displayName![0].toUpperCase()
                              : 'D',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, Dr. ${currentUser?.displayName ?? 'Doctor'}',
                              style: AppTextStyles.headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Role: Surgeon / Care Specialist',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // ── Quick Actions Grid ───────────────────────────────────────────
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Dashboard Quick Actions',
                style: AppTextStyles.titleLarge,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),

            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 150),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppDimensions.paddingM,
                mainAxisSpacing: AppDimensions.paddingM,
                childAspectRatio: 1.5,
                children: [
                  _DashboardBtn(
                    label: 'Manage Availability',
                    icon: Icons.event_available_rounded,
                    color: AppColors.primaryLight,
                    onTap: () => Get.toNamed(AppRoutes.doctorAvailability),
                  ),
                  _DashboardBtn(
                    label: 'Performance Metrics',
                    icon: Icons.analytics_rounded,
                    color: Colors.amberAccent,
                    onTap: () => Get.toNamed(AppRoutes.doctorPerformance),
                  ),
                  _DashboardBtn(
                    label: 'Patient Chats',
                    icon: Icons.chat_bubble_outline_rounded,
                    color: AppColors.secondaryLight,
                    onTap: () => Get.toNamed(AppRoutes.chatList),
                  ),
                  _DashboardBtn(
                    label: 'Notifications',
                    icon: Icons.notifications_none_rounded,
                    color: AppColors.successLight,
                    onTap: () => Get.toNamed(AppRoutes.notificationCenter),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
