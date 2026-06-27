import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/doctor_model.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../appointment/controllers/appointment_controller.dart';

class BookAppointmentScreen extends GetView<AppointmentController> {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientIdCtrl = TextEditingController();
    final isWeb = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Book Appointment', style: AppTextStyles.headlineMedium),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.5, -0.5),
                  radius: 1.0,
                  colors: [AppColors.primaryContainer, AppColors.background],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWeb ? 620 : double.infinity),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingXL),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Patient ID ────────────────────────────────
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              child: AppTextField(
                                controller: patientIdCtrl,
                                label: 'Patient ID',
                                hint: 'Enter Patient ID (e.g. PT-0123)',
                                prefixIcon: Icons.person_search_outlined,
                                validator: Validators.validateRequired,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingL),

                            // ── Doctor Selector ───────────────────────────
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 80),
                              child: Text('Select Doctor', style: AppTextStyles.titleLarge),
                            ),
                            const SizedBox(height: AppDimensions.paddingM),
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 120),
                              child: Obx(() {
                                if (controller.doctorList.isEmpty) {
                                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                                }
                                return DropdownButtonFormField<DoctorModel>(
                                  dropdownColor: AppColors.surface,
                                  style: AppTextStyles.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Doctor',
                                    labelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
                                    prefixIcon: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                      borderSide: const BorderSide(color: AppColors.glassBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                      borderSide: const BorderSide(color: AppColors.glassBorder),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                    ),
                                  ),
                                  items: controller.doctorList.map((doc) {
                                    return DropdownMenuItem<DoctorModel>(
                                      value: doc,
                                      child: Text(
                                        '${doc.name} — ${doc.specializations.join(', ')}',
                                        style: AppTextStyles.bodyLarge,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: controller.selectDoctor,
                                );
                              }),
                            ),
                            const SizedBox(height: AppDimensions.paddingL),

                            // ── Date Picker ───────────────────────────────
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 200),
                              child: Text('Select Date', style: AppTextStyles.titleLarge),
                            ),
                            const SizedBox(height: AppDimensions.paddingM),
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 240),
                              child: Obx(() => GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().add(const Duration(days: 1)),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 90)),
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
                                    controller.selectedDate.value = picked;
                                    controller.selectedSlot.value = null;
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                                  decoration: BoxDecoration(
                                    color: AppColors.glassBackground,
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                    border: Border.all(color: AppColors.glassBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
                                      const SizedBox(width: AppDimensions.paddingM),
                                      Text(
                                        controller.selectedDate.value == null
                                            ? 'Tap to pick a date'
                                            : '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: controller.selectedDate.value == null
                                              ? AppColors.textSecondary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                            const SizedBox(height: AppDimensions.paddingL),

                            // ── Available Slots ───────────────────────────
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 300),
                              child: Text('Available Time Slots', style: AppTextStyles.titleLarge),
                            ),
                            const SizedBox(height: AppDimensions.paddingM),
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 340),
                              child: Obx(() {
                                final slots = controller.availableSlots;
                                if (controller.selectedDoctor.value == null || controller.selectedDate.value == null) {
                                  return Text(
                                    'Select a doctor and date to see available slots.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  );
                                }
                                if (slots.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.event_busy_rounded, color: AppColors.error),
                                        const SizedBox(width: AppDimensions.paddingM),
                                        Expanded(
                                          child: Text(
                                            'No available slots for selected date.',
                                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Wrap(
                                  spacing: AppDimensions.paddingS,
                                  runSpacing: AppDimensions.paddingS,
                                  children: slots.map((slot) {
                                    final isSelected = controller.selectedSlot.value == slot;
                                    return GestureDetector(
                                      onTap: () => controller.selectedSlot.value = slot,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppDimensions.paddingL,
                                          vertical: AppDimensions.paddingS,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primary : Colors.transparent,
                                          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                                          border: Border.all(
                                            color: isSelected ? AppColors.primary : AppColors.glassBorder,
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        child: Text(
                                          slot.split('|').last, // show only time block label
                                          style: AppTextStyles.labelLarge.copyWith(
                                            color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ),
                            const SizedBox(height: AppDimensions.paddingXXL),

                            // ── Book Button ───────────────────────────────
                            FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: const Duration(milliseconds: 420),
                              child: Obx(() => PrimaryButton(
                                label: 'Confirm Appointment',
                                icon: Icons.check_circle_outline_rounded,
                                isLoading: controller.isLoading.value,
                                onPressed: () {
                                  if (patientIdCtrl.text.trim().isEmpty) {
                                    SnackbarHelper.showError('Please enter the patient ID.');
                                    return;
                                  }
                                  controller.bookAppointment(patientIdCtrl.text.trim());
                                },
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
