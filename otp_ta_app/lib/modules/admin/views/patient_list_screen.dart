import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../patient/controllers/patient_management_controller.dart';
import '../../../routes/app_routes.dart';

class PatientListScreen extends GetView<PatientManagementController> {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOverlay,
        elevation: 0,
        title: Text('Patients Directory', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.addPatient),
              icon: const Icon(Icons.person_add_rounded, color: AppColors.onPrimary),
              label: Text(
                'Register Patient',
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
            // Search Bar
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: AppTextField(
                controller: searchCtrl,
                label: 'Search Patients',
                hint: 'Name, Phone, or Patient ID',
                prefixIcon: Icons.search_rounded,
                onChanged: controller.filterPatients,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            
            // List
            Expanded(
              child: Obx(() {
                if (controller.filteredPatientList.isEmpty) {
                  return Center(
                    child: Text(
                      'No patients found.',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredPatientList.length,
                  itemBuilder: (context, index) {
                    final patient = controller.filteredPatientList[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: 50 * index),
                      child: Container(
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
                            child: Text(
                              patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                            ),
                          ),
                          title: Text(patient.name, style: AppTextStyles.titleLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('ID: ${patient.patientId}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text('Phone: ${patient.phone}', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary, size: 16),
                          onTap: () {
                            // View patient details (can use the patient_profile_screen.dart for admin read-only view)
                          },
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
