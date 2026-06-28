import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/prescription_model.dart';
import '../controllers/prescription_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class MedicationScheduleScreen extends GetView<PrescriptionController> {
  const MedicationScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientId = Get.find<AuthController>().currentUser.value?.uid ?? '';
    final isWeb = ResponsiveHelper.isDesktop(context);

    // Watch prescription streams for the patient
    final Stream<List<PrescriptionModel>> scheduleStream = controller.watchPatientMedications(patientId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Medication Timetable', style: AppTextStyles.headlineMedium),
      ),
      body: StreamBuilder<List<PrescriptionModel>>(
        stream: scheduleStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.medication_liquid_rounded, size: 72, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  Text('No Medication Plans Found', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  Text('Your doctor hasn\'t posted any prescriptions yet.', style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          // Map all medicines from active prescriptions into daily timetable slots
          final prescriptions = snapshot.data!;
          final List<MedicineModel> allActiveMedicines = [];
          final now = DateTime.now();

          for (var presc in prescriptions) {
            for (var med in presc.medicines) {
              // Ensure medicine is active (start <= now <= end)
              if (med.startDate.isBefore(now.add(const Duration(days: 1))) &&
                  med.endDate.isAfter(now.subtract(const Duration(days: 1)))) {
                allActiveMedicines.add(med);
              }
            }
          }

          if (allActiveMedicines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 72, color: AppColors.successLight),
                  const SizedBox(height: 16),
                  Text('No Active Medications Today', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  Text('You are all caught up on your recovery medicine!', style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          // Categorize into timeline slots
          final morningList = <MedicineModel>[];
          final afternoonList = <MedicineModel>[];
          final eveningList = <MedicineModel>[];
          final nightList = <MedicineModel>[];

          for (var med in allActiveMedicines) {
            final freq = med.frequency.toLowerCase();
            if (freq.contains('morning') || freq.contains('breakfast') || freq.contains('once') || freq.contains('1x')) {
              morningList.add(med);
            }
            if (freq.contains('noon') || freq.contains('lunch') || freq.contains('afternoon') || freq.contains('twice') || freq.contains('2x')) {
              afternoonList.add(med);
            }
            if (freq.contains('evening') || freq.contains('dinner') || freq.contains('twice') || freq.contains('thrice') || freq.contains('3x')) {
              eveningList.add(med);
            }
            if (freq.contains('night') || freq.contains('bedtime') || freq.contains('sleep') || freq.contains('thrice') || freq.contains('twice')) {
              nightList.add(med);
            }
            // Fallback for custom or empty frequencies - put in Morning
            if (morningList.isEmpty && afternoonList.isEmpty && eveningList.isEmpty && nightList.isEmpty) {
              morningList.add(med);
            }
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 650 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        'Daily Timetable schedule',
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primaryLight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),

                    // Morning Timeline Slot
                    _buildTimelineSlot('Morning Slot', Icons.wb_sunny_outlined, AppColors.warningLight, morningList),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Afternoon Timeline Slot
                    _buildTimelineSlot('Afternoon Slot', Icons.sunny, AppColors.warning, afternoonList),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Evening Timeline Slot
                    _buildTimelineSlot('Evening Slot', Icons.wb_twilight_outlined, AppColors.secondary, eveningList),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Night Timeline Slot
                    _buildTimelineSlot('Night Slot', Icons.nights_stay_outlined, AppColors.primary, nightList),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineSlot(String title, IconData icon, Color iconColor, List<MedicineModel> medicines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                '${medicines.length}',
                style: AppTextStyles.bodySmall.copyWith(color: iconColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (medicines.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
            ),
            child: Text(
              'No medicines scheduled for this slot.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: medicines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final med = medicines[index];
              return FadeInLeft(
                duration: const Duration(milliseconds: 300),
                delay: Duration(milliseconds: index * 100),
                child: _buildMedicineCard(med, iconColor),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMedicineCard(MedicineModel med, Color themeColor) {
    return Card(
      color: AppColors.surfaceOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.medical_services_outlined, color: themeColor),
            ),
            const SizedBox(width: AppDimensions.paddingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med.name, style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Dosage: ${med.dosage}',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '|   ${med.frequency}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ends: ${DateFormat('MMMM d, yyyy').format(med.endDate)}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorLight),
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
