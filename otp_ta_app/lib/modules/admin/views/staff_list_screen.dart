import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../controllers/staff_controller.dart';
import '../../../routes/app_routes.dart';

class StaffListScreen extends GetView<StaffController> {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Staff Directory', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(
                AppRoutes.addEditStaff,
              ), // We'll add this route later
              icon: const Icon(Icons.add, color: AppColors.onPrimary),
              label: Text(
                'Add Staff',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
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
        child: Column(
          children: [
            // Search Bar
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: AppTextField(
                controller: searchCtrl,
                label: 'Search Staff',
                hint: 'Name, Email, or Role',
                prefixIcon: Icons.search_rounded,
                onChanged: controller.filterStaff,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),

            // List
            Expanded(
              child: Obx(() {
                if (controller.filteredStaffList.isEmpty) {
                  return Center(
                    child: Text(
                      'No staff members found.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredStaffList.length,
                  itemBuilder: (context, index) {
                    final staff = controller.filteredStaffList[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: 50 * index),
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: AppDimensions.paddingM,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                            AppDimensions.paddingM,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryContainer,
                            child: Text(
                              staff.name.isNotEmpty
                                  ? staff.name[0].toUpperCase()
                                  : '?',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            staff.name,
                            style: AppTextStyles.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                staff.email,
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  staff.role.toUpperCase(),
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              // Pass existing staff data to edit screen
                              Get.toNamed(
                                AppRoutes.addEditStaff,
                                arguments: staff,
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
