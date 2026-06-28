import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/notification_controller.dart';

class NotificationCenterScreen extends GetView<NotificationController> {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Notifications', style: AppTextStyles.headlineMedium),
        actions: [
          Obx(() {
            if (controller.notifications.isEmpty) {
              return const SizedBox.shrink();
            }
            return TextButton(
              onPressed: () => controller.clearAll(),
              child: Text(
                'Clear All',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.errorLight,
                ),
              ),
            );
          }),
          const SizedBox(width: AppDimensions.paddingM),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (controller.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off_outlined,
                      size: 72,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text('All Caught Up!', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'You have no new notifications.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              itemCount: controller.notifications.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppDimensions.paddingM),
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];

                return FadeInDown(
                  duration: const Duration(milliseconds: 350),
                  child: _NotificationCard(
                    notification: notification,
                    onTap: () {
                      if (!notification.isRead) {
                        controller.markAsRead(notification.notificationId);
                      }
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    final timeString = DateFormat(
      'MMM d, h:mm a',
    ).format(notification.timestamp);
    final isCheckup = notification.type == 'checkup_reminder';

    IconData iconData = Icons.notifications_rounded;
    Color iconColor = AppColors.primaryLight;

    if (isCheckup) {
      iconData = Icons.event_note_rounded;
      iconColor = AppColors.secondaryLight;
    } else if (notification.type == 'operation_status') {
      iconData = Icons.local_hospital_rounded;
      iconColor = AppColors.secondary;
    } else if (notification.type == 'chat') {
      iconData = Icons.chat_rounded;
      iconColor = Colors.greenAccent;
    }

    return Card(
      color: isUnread ? AppColors.surfaceOverlay : AppColors.surfaceElevated,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: BorderSide(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.glassBorder,
          width: 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual indicator for unread status
              if (isUnread)
                Container(
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                ),

              // Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppDimensions.paddingL),

              // Text details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.title,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          timeString,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isUnread
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (isCheckup) ...[
                      const SizedBox(height: 8),
                      // Helper banner showing formatted items for appointment details
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOverlay,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_rounded,
                                  size: 14,
                                  color: AppColors.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Doctor',
                                  style: AppTextStyles.labelMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppColors.secondaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Scheduled',
                                  style: AppTextStyles.labelMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.meeting_room_rounded,
                                  size: 14,
                                  color: Colors.amberAccent,
                                ),
                                const SizedBox(width: 4),
                                Text('Room', style: AppTextStyles.labelMedium),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
