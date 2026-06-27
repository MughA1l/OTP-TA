import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../controllers/role_permission_controller.dart';

class RolePermissionsScreen extends GetView<RolePermissionController> {
  const RolePermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Role Permissions', style: AppTextStyles.headlineMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.rolePermissions.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.rolePermissions.isEmpty) {
          return Center(
            child: Text('No roles found.', style: AppTextStyles.bodyLarge),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          itemCount: controller.rolePermissions.length,
          itemBuilder: (context, index) {
            final rolePerm = controller.rolePermissions[index];
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 * index),
              child: _buildRoleCard(rolePerm, context),
            );
          },
        );
      }),
    );
  }

  Widget _buildRoleCard(rolePerm, BuildContext context) {
    // Local state for the expansion tile checkboxes
    final RxList<String> currentAllowed = List<String>.from(rolePerm.allowedModules).obs;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: ExpansionTile(
            collapsedIconColor: AppColors.primary,
            iconColor: AppColors.primary,
            title: Text(
              rolePerm.role.toUpperCase(),
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
            ),
            subtitle: Obx(() => Text(
              '${currentAllowed.length} modules allowed',
              style: AppTextStyles.bodyMedium,
            )),
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.glassBorder)),
                ),
                child: Column(
                  children: [
                    ...controller.allModules.map((module) {
                      return Obx(() {
                        final isAllowed = currentAllowed.contains(module);
                        return CheckboxListTile(
                          title: Text(module, style: AppTextStyles.bodyLarge),
                          value: isAllowed,
                          activeColor: AppColors.primary,
                          checkColor: AppColors.onPrimary,
                          side: const BorderSide(color: AppColors.textSecondary),
                          onChanged: (val) {
                            if (val == true) {
                              currentAllowed.add(module);
                            } else {
                              currentAllowed.remove(module);
                            }
                          },
                        );
                      });
                    }),
                    const SizedBox(height: AppDimensions.paddingL),
                    Obx(() => PrimaryButton(
                      label: 'Save Permissions',
                      icon: Icons.security_rounded,
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        controller.savePermissions(rolePerm.role, currentAllowed.toList());
                      },
                    )),
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
