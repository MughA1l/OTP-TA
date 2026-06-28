import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/doctor_model.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../doctor/controllers/doctor_management_controller.dart';

class DoctorAvailabilityScreen extends GetView<DoctorManagementController> {
  const DoctorAvailabilityScreen({super.key});

  // Predefined shift slots for the weekly grid
  static const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _timeBlocks = [
    'Morning (8am–12pm)',
    'Afternoon (12pm–4pm)',
    'Evening (4pm–8pm)',
  ];

  @override
  Widget build(BuildContext context) {
    final DoctorModel doctor = Get.arguments as DoctorModel;
    final isWeb = ResponsiveHelper.isDesktop(context);

    // Load leaves on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLeaveDates(doctor.doctorId);
      controller.fetchDoctorProfile(doctor.doctorId);
    });

    final selectedSlots = doctor.availabilitySlots.toSet().obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Availability & Duty Timings',
              style: AppTextStyles.headlineMedium,
            ),
            Text(
              doctor.name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 800 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Weekly Slot Grid ──────────────────────────────────────
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: _buildGlassCard(
                    title: 'Weekly Shift Grid',
                    subtitle: 'Tap a cell to toggle availability',
                    child: Obx(
                      () => Column(
                        children: _timeBlocks.map((block) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.paddingM,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  block,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingS),
                                Wrap(
                                  spacing: AppDimensions.paddingS,
                                  runSpacing: AppDimensions.paddingS,
                                  children: _weekDays.map((day) {
                                    final slotKey = '$day|$block';
                                    final isSelected = selectedSlots.contains(
                                      slotKey,
                                    );
                                    return GestureDetector(
                                      onTap: () {
                                        if (isSelected) {
                                          selectedSlots.remove(slotKey);
                                        } else {
                                          selectedSlots.add(slotKey);
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        width: 60,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary.withValues(
                                                  alpha: 0.85,
                                                )
                                              : AppColors.glassBackground,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusS,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.glassBorder,
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          day,
                                          style: AppTextStyles.labelLarge
                                              .copyWith(
                                                color: isSelected
                                                    ? AppColors.onPrimary
                                                    : AppColors.textSecondary,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),

                // Save Availability Button
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 100),
                  child: Obx(
                    () => PrimaryButton(
                      label: 'Save Availability',
                      icon: Icons.save_rounded,
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        controller.saveAvailabilitySlots(
                          doctor.doctorId,
                          selectedSlots.toList(),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // ── Mark On Leave ─────────────────────────────────────────
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 200),
                  child: _buildGlassCard(
                    title: 'Mark as On Leave',
                    subtitle: 'Select a date to mark doctor as unavailable',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
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
                              final iso = picked
                                  .toIso8601String()
                                  .split('T')
                                  .first;
                              controller.markOnLeave(doctor.doctorId, iso);
                            }
                          },
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.onPrimary,
                          ),
                          label: Text(
                            'Pick Leave Date',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warning,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingM),

                        // Current leave dates list
                        Obx(() {
                          if (controller.leaveDates.isEmpty) {
                            return Text(
                              'No leave dates marked.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            );
                          }
                          return Wrap(
                            spacing: AppDimensions.paddingS,
                            runSpacing: AppDimensions.paddingS,
                            children: controller.leaveDates.map((date) {
                              return Chip(
                                label: Text(
                                  date,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                                backgroundColor: AppColors.warning.withValues(
                                  alpha: 0.8,
                                ),
                                deleteIcon: const Icon(
                                  Icons.close,
                                  color: AppColors.onPrimary,
                                  size: 16,
                                ),
                                onDeleted: () => controller.removeLeaveDate(
                                  doctor.doctorId,
                                  date,
                                ),
                                side: BorderSide.none,
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
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
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
