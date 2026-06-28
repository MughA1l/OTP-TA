import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../data/models/prescription_model.dart';
import '../controllers/prescription_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final PrescriptionController controller = Get.find<PrescriptionController>();
  final formKey = GlobalKey<FormState>();

  final RxList<MedicineFormEntry> medicineEntries = <MedicineFormEntry>[].obs;
  final Rx<PrescriptionModel?> existingPrescription = Rx<PrescriptionModel?>(
    null,
  );

  String operationId = '';
  String patientId = '';
  String doctorId = '';
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      operationId = args['operationId'] as String? ?? '';
      patientId = args['patientId'] as String? ?? '';
      doctorId = args['doctorId'] as String? ?? '';
      final PrescriptionModel? presc =
          args['prescription'] as PrescriptionModel?;

      if (presc != null) {
        existingPrescription.value = presc;
        isEditMode = true;
        for (var med in presc.medicines) {
          medicineEntries.add(MedicineFormEntry.fromModel(med));
        }
      } else {
        // Start with 1 empty medicine card
        medicineEntries.add(MedicineFormEntry());
      }
    } else {
      medicineEntries.add(MedicineFormEntry());
    }
  }

  void _addNewMedicineEntry() {
    medicineEntries.add(MedicineFormEntry());
  }

  void _removeMedicineEntry(int index) {
    if (medicineEntries.length > 1) {
      medicineEntries.removeAt(index);
    }
  }

  Future<void> submitPrescription() async {
    if (!formKey.currentState!.validate()) return;

    final medicines = medicineEntries.map((entry) => entry.toModel()).toList();

    if (isEditMode && existingPrescription.value != null) {
      // Edit mode: compare dosages to log to audit trail
      final oldPresc = existingPrescription.value!;
      final oldDosages = oldPresc.medicines
          .map((m) => '${m.name}: ${m.dosage}')
          .join(', ');
      final newDosages = medicines
          .map((m) => '${m.name}: ${m.dosage}')
          .join(', ');

      if (oldDosages == newDosages) {
        Get.snackbar(
          'No Changes',
          'No changes were detected in the prescription dosages.',
          backgroundColor: AppColors.warning,
          colorText: Colors.black,
        );
        return;
      }

      await controller.updatePrescriptionDosage(
        prescriptionId: oldPresc.prescriptionId,
        medicines: medicines,
        oldDosage: oldDosages,
        newDosage: newDosages,
      );
    } else {
      // Create mode
      final newPrescription = PrescriptionModel(
        prescriptionId: '',
        operationId: operationId,
        patientId: patientId,
        doctorId: doctorId.isNotEmpty
            ? doctorId
            : (Get.find<AuthController>().currentUser.value?.uid ?? ''),
        medicines: medicines,
        auditLog: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await controller.createPrescription(newPrescription);
    }
  }

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
        title: Text(
          isEditMode ? 'Edit Prescription' : 'Add Prescription',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 650 : double.infinity,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      isEditMode
                          ? 'Modify Prescription Dosages'
                          : 'Record New Postoperative Prescription',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.primaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL),

                  // Dynamic list of medicine forms
                  Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: medicineEntries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final entry = medicineEntries[index];
                        return FadeInUp(
                          duration: const Duration(milliseconds: 300),
                          child: _buildMedicineCard(entry, index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  // "Add More Medicine" Button
                  if (!isEditMode)
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 100),
                      child: TextButton.icon(
                        onPressed: _addNewMedicineEntry,
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.secondary,
                        ),
                        label: Text(
                          'Add More Medicine',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.paddingXL),

                  // Submit Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 150),
                    child: Obx(
                      () => PrimaryButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : submitPrescription,
                        label: isEditMode
                            ? 'Update Prescription'
                            : 'Save Prescription',
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL),

                  // Audit logs list at the bottom in edit mode
                  Obx(() {
                    final presc = existingPrescription.value;
                    if (presc == null || presc.auditLog.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: AppColors.glassBorder),
                        const SizedBox(height: AppDimensions.paddingL),
                        Text(
                          'Prescription Modifications History',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: AppDimensions.paddingM),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: presc.auditLog.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final log = presc.auditLog[index];
                            return Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingM,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusM,
                                ),
                                border: Border.all(
                                  color: AppColors.glassBorder.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Modified By: ${log.changedBy}',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryLight,
                                            ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'MMM d, yyyy HH:mm',
                                        ).format(log.timestamp),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Old Dosages: ${log.oldDosage}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.errorLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'New Dosages: ${log.newDosage}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.successLight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(MedicineFormEntry entry, int index) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medicine #${index + 1}',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
              if (medicineEntries.length > 1 && !isEditMode)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                  onPressed: () => _removeMedicineEntry(index),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),

          // Medicine Name input
          AppTextField(
            controller: entry.nameCtrl,
            label: 'Drug Name',
            hint: 'e.g. Paracetamol, Amoxicillin',
            prefixIcon: Icons.medication_outlined,
            enabled: !isEditMode, // Name cannot be edited, only dosage
            validator: (val) =>
                Validators.validateRequired(val, fieldName: 'Drug Name'),
          ),
          const SizedBox(height: AppDimensions.paddingM),

          // Dosage input
          AppTextField(
            controller: entry.dosageCtrl,
            label: 'Dosage / Strength',
            hint: 'e.g. 500mg, 1 Capsule',
            prefixIcon: Icons.scale_outlined,
            validator: (val) =>
                Validators.validateRequired(val, fieldName: 'Dosage'),
          ),
          const SizedBox(height: AppDimensions.paddingM),

          // Frequency input
          AppTextField(
            controller: entry.frequencyCtrl,
            label: 'Frequency',
            hint: 'e.g. Twice daily, Once at night',
            prefixIcon: Icons.repeat_outlined,
            enabled: !isEditMode,
            validator: (val) =>
                Validators.validateRequired(val, fieldName: 'Frequency'),
          ),
          const SizedBox(height: AppDimensions.paddingM),

          // Start Date & End Date Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isEditMode
                      ? null
                      : () => _selectDate(context, entry, isStart: true),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: entry.startDateCtrl,
                      label: 'Start Date',
                      hint: 'YYYY-MM-DD',
                      prefixIcon: Icons.calendar_today_outlined,
                      validator: (val) => Validators.validateRequired(
                        val,
                        fieldName: 'Start Date',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: isEditMode
                      ? null
                      : () => _selectDate(context, entry, isStart: false),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: entry.endDateCtrl,
                      label: 'End Date',
                      hint: 'YYYY-MM-DD',
                      prefixIcon: Icons.event_busy_outlined,
                      validator: (val) => Validators.validateRequired(
                        val,
                        fieldName: 'End Date',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    MedicineFormEntry entry, {
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStart) {
        entry.startDate = picked;
        entry.startDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      } else {
        entry.endDate = picked;
        entry.endDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }
  }
}

/// Helper model for dynamic form state management
class MedicineFormEntry {
  final TextEditingController nameCtrl;
  final TextEditingController dosageCtrl;
  final TextEditingController frequencyCtrl;
  final TextEditingController startDateCtrl;
  final TextEditingController endDateCtrl;

  DateTime startDate;
  DateTime endDate;

  MedicineFormEntry({
    String name = '',
    String dosage = '',
    String frequency = '',
    DateTime? start,
    DateTime? end,
  }) : nameCtrl = TextEditingController(text: name),
       dosageCtrl = TextEditingController(text: dosage),
       frequencyCtrl = TextEditingController(text: frequency),
       startDateCtrl = TextEditingController(
         text: start != null ? DateFormat('yyyy-MM-dd').format(start) : '',
       ),
       endDateCtrl = TextEditingController(
         text: end != null ? DateFormat('yyyy-MM-dd').format(end) : '',
       ),
       startDate = start ?? DateTime.now(),
       endDate = end ?? DateTime.now().add(const Duration(days: 7));

  factory MedicineFormEntry.fromModel(MedicineModel med) {
    return MedicineFormEntry(
      name: med.name,
      dosage: med.dosage,
      frequency: med.frequency,
      start: med.startDate,
      end: med.endDate,
    );
  }

  MedicineModel toModel() {
    return MedicineModel(
      name: nameCtrl.text.trim(),
      dosage: dosageCtrl.text.trim(),
      frequency: frequencyCtrl.text.trim(),
      startDate: startDate,
      endDate: endDate,
    );
  }
}
