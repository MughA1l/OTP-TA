import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_dropdown.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../data/models/operation_model.dart';
import '../controllers/operation_controller.dart';

class AssignTeamScreen extends StatefulWidget {
  const AssignTeamScreen({super.key});

  @override
  State<AssignTeamScreen> createState() => _AssignTeamScreenState();
}

class _AssignTeamScreenState extends State<AssignTeamScreen> {
  final OperationController controller = Get.find<OperationController>();
  final formKey = GlobalKey<FormState>();
  final auditChangesCtrl = TextEditingController();

  final Rx<OperationModel?> operation = Rx<OperationModel?>(null);
  final RxString selectedPrimaryDoctorId = ''.obs;
  final RxString selectedAnaesthesiologistId = ''.obs;
  final RxList<String> selectedNurses = <String>[].obs;

  // Real-time validation message observables
  final RxString doctorConflictMsg = ''.obs;
  final RxString anaesthesiologistConflictMsg = ''.obs;

  bool isUpdateFlow = false;

  @override
  void initState() {
    super.initState();
    final operationId = Get.arguments as String?;
    if (operationId != null) {
      _loadOperation(operationId);
    }
  }

  Future<void> _loadOperation(String operationId) async {
    _fetchFreshOperation(operationId);
  }

  void _fetchFreshOperation(String operationId) {
    controller.watchPatientOperation('').listen((_) {}); // trigger listener
    // Query doc directly
    FirebaseFirestore.instance
        .collection('operations')
        .doc(operationId)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            final op = OperationModel.fromMap(doc.data()!, doc.id);
            operation.value = op;
            controller.selectedOperation.value = op;

            // Populate initial values if already assigned (Update Flow)
            if (op.surgicalTeam.primaryDoctorId.isNotEmpty) {
              isUpdateFlow = true;
              selectedPrimaryDoctorId.value = op.surgicalTeam.primaryDoctorId;
              selectedAnaesthesiologistId.value =
                  op.surgicalTeam.anaesthesiologistId;
              selectedNurses.assignAll(op.surgicalTeam.nursingStaff);
              _validateAvailability();
            }
          }
        });
  }

  void _validateAvailability() {
    final op = operation.value;
    if (op == null) return;

    // 1. Primary Doctor Validation
    if (selectedPrimaryDoctorId.value.isNotEmpty) {
      final doc = controller.doctorList.firstWhereOrNull(
        (d) => d.doctorId == selectedPrimaryDoctorId.value,
      );
      if (doc != null) {
        if (!controller.isDoctorScheduledSlotValid(doc, op.scheduledDate)) {
          doctorConflictMsg.value =
              'Warning: This day is outside the surgeon\'s availability slots.';
        } else if (!controller.isDoctorAvailable(
          doc.doctorId,
          op.scheduledDate,
        )) {
          doctorConflictMsg.value =
              'Conflict: Surgeon has another overlapping active surgery at this time.';
        } else {
          doctorConflictMsg.value = '';
        }
      }
    } else {
      doctorConflictMsg.value = '';
    }

    // 2. Anaesthesiologist Validation
    if (selectedAnaesthesiologistId.value.isNotEmpty) {
      final doc = controller.doctorList.firstWhereOrNull(
        (d) => d.doctorId == selectedAnaesthesiologistId.value,
      );
      if (doc != null) {
        if (selectedAnaesthesiologistId.value ==
            selectedPrimaryDoctorId.value) {
          anaesthesiologistConflictMsg.value =
              'Conflict: Anaesthesiologist cannot be the same as Primary Surgeon.';
        } else if (!controller.isDoctorAvailable(
          doc.doctorId,
          op.scheduledDate,
        )) {
          anaesthesiologistConflictMsg.value =
              'Conflict: Doctor has another overlapping active surgery at this time.';
        } else {
          anaesthesiologistConflictMsg.value = '';
        }
      }
    } else {
      anaesthesiologistConflictMsg.value = '';
    }
  }

  Future<void> submitAssignment() async {
    final op = operation.value;
    if (op == null) return;

    if (formKey.currentState!.validate() &&
        selectedPrimaryDoctorId.value.isNotEmpty &&
        selectedAnaesthesiologistId.value.isNotEmpty) {
      // Ensure no blocking conflicts
      if (doctorConflictMsg.value.contains('Conflict') ||
          anaesthesiologistConflictMsg.value.contains('Conflict')) {
        Get.snackbar(
          'Conflict Error',
          'Please resolve schedule conflicts before saving.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      final team = SurgicalTeamModel(
        primaryDoctorId: selectedPrimaryDoctorId.value,
        anaesthesiologistId: selectedAnaesthesiologistId.value,
        nursingStaff: selectedNurses.toList(),
      );

      if (isUpdateFlow) {
        if (auditChangesCtrl.text.trim().isEmpty) {
          Get.snackbar(
            'Action Required',
            'Please specify details of surgical team modifications for audit log.',
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
          return;
        }
        await controller.updateSurgicalTeam(
          op.operationId,
          team,
          auditChangesCtrl.text.trim(),
        );
      } else {
        await controller.assignSurgicalTeam(op.operationId, team);
      }
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
          isUpdateFlow ? 'Update Surgical Team' : 'Assign Surgical Team',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: Obx(() {
        final op = operation.value;
        if (op == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final filteredNurses = controller.staffList
            .where(
              (staff) =>
                  staff.role.toLowerCase().contains('nurse') ||
                  staff.role.toLowerCase().contains('nursing'),
            )
            .toList();

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 600 : double.infinity,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Operation Metadata Card
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingL),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusL,
                          ),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Operation: ${op.surgeryType}',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Patient: ${op.patientName}',
                              style: AppTextStyles.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'OT Room: ${op.otRoom}',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Scheduled: ${DateFormat('EEEE, MMM d, yyyy').format(op.scheduledDate)} at ${op.scheduledTime}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Primary Doctor Dropdown Selector
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppDropdown<String>(
                            value: selectedPrimaryDoctorId.value.isEmpty
                                ? null
                                : selectedPrimaryDoctorId.value,
                            label: 'Primary Surgeon',
                            hint: 'Choose Surgeon',
                            prefixIcon: Icons.healing_outlined,
                            items: controller.doctorList.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc.doctorId,
                                child: Text(
                                  '${doc.name} — ${doc.specializations.join(', ')}',
                                ),
                              );
                            }).toList(),
                            onChanged: (id) {
                              selectedPrimaryDoctorId.value = id ?? '';
                              _validateAvailability();
                            },
                          ),
                          if (doctorConflictMsg.value.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              doctorConflictMsg.value,
                              style: AppTextStyles.bodySmall.copyWith(
                                color:
                                    doctorConflictMsg.value.startsWith(
                                      'Conflict',
                                    )
                                    ? AppColors.error
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Anaesthesiologist Selector
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppDropdown<String>(
                            value: selectedAnaesthesiologistId.value.isEmpty
                                ? null
                                : selectedAnaesthesiologistId.value,
                            label: 'Anaesthesiologist',
                            hint: 'Choose Anaesthesiologist',
                            prefixIcon: Icons.opacity_outlined,
                            items: controller.doctorList.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc.doctorId,
                                child: Text('${doc.name} — Anaesthesia'),
                              );
                            }).toList(),
                            onChanged: (id) {
                              selectedAnaesthesiologistId.value = id ?? '';
                              _validateAvailability();
                            },
                          ),
                          if (anaesthesiologistConflictMsg
                              .value
                              .isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              anaesthesiologistConflictMsg.value,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Nursing Staff Multi-Select (Wrapping filter chips)
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Nursing Staff',
                            style: AppTextStyles.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          if (filteredNurses.isEmpty)
                            Text(
                              'No nursing staff found in staff directory.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: filteredNurses.map((nurse) {
                                final isSelected = selectedNurses.contains(
                                  nurse.name,
                                );
                                return FilterChip(
                                  label: Text(nurse.name),
                                  selected: isSelected,
                                  selectedColor: AppColors.primaryContainer,
                                  checkmarkColor: AppColors.primaryLight,
                                  backgroundColor: AppColors.surfaceElevated,
                                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primaryLight
                                        : AppColors.textSecondary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusS,
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.glassBorder,
                                    ),
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      selectedNurses.add(nurse.name);
                                    } else {
                                      selectedNurses.remove(nurse.name);
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Update Audit Description Input
                    if (isUpdateFlow) ...[
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 250),
                        child: AppTextField(
                          controller: auditChangesCtrl,
                          label: 'Changes Description',
                          hint: 'Describe reason for team modification...',
                          prefixIcon: Icons.edit_note_outlined,
                          maxLines: 2,
                          validator: (val) => Validators.validateRequired(
                            val,
                            fieldName: 'Changes Description',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXL),
                    ],

                    // Submit Assignment Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 300),
                      child: PrimaryButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : submitAssignment,
                        label: isUpdateFlow ? 'Update Team' : 'Assign Team',
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),

                    // Audit Log History View
                    if (op.auditLog.isNotEmpty) ...[
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 350),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: AppColors.glassBorder),
                            const SizedBox(height: AppDimensions.paddingM),
                            Text(
                              'Audit Log Modification History',
                              style: AppTextStyles.labelLarge,
                            ),
                            const SizedBox(height: AppDimensions.paddingM),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: op.auditLog.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final log = op.auditLog[index];
                                return Container(
                                  padding: const EdgeInsets.all(
                                    AppDimensions.paddingM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface.withValues(
                                      alpha: 0.5,
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Action: ${log.action}',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.secondaryLight,
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
                                      const SizedBox(height: 4),
                                      Text(
                                        'Modified By: ${log.changedBy}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Details: ${log.changes}',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
