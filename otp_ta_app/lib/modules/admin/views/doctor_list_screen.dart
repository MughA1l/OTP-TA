import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../doctor/controllers/doctor_management_controller.dart';
import '../../../data/models/doctor_model.dart';
import '../../../routes/app_routes.dart';

class DoctorListScreen extends GetView<DoctorManagementController> {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Doctors Directory', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.addEditDoctor),
              icon: const Icon(Icons.person_add_rounded, color: AppColors.onPrimary),
              label: Text(
                'Add Doctor',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.onPrimary),
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
            // Search bar
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: AppTextField(
                controller: searchCtrl,
                label: 'Search Doctors',
                hint: 'Name, Specialization, or PMDC No.',
                prefixIcon: Icons.search_rounded,
                onChanged: controller.filterDoctors,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),

            // List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.filteredDoctorList.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (controller.filteredDoctorList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medical_services_outlined, color: AppColors.textSecondary, size: 64),
                        const SizedBox(height: AppDimensions.paddingM),
                        Text(
                          'No doctors found.',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredDoctorList.length,
                  itemBuilder: (context, index) {
                    final doctor = controller.filteredDoctorList[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: 50 * index),
                      child: _DoctorCard(doctor: doctor),
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

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.paddingM),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryContainer,
          radius: 28,
          child: Text(
            doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : 'D',
            style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
          ),
        ),
        title: Text(doctor.name, style: AppTextStyles.titleLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              doctor.specializations.join(' • '),
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.badge_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('PMDC: ${doctor.pmdc}', style: AppTextStyles.bodyMedium),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          onPressed: () => Get.toNamed(AppRoutes.addEditDoctor, arguments: doctor),
        ),
        onTap: () => Get.toNamed(AppRoutes.addEditDoctor, arguments: doctor),
      ),
    );
  }
}
