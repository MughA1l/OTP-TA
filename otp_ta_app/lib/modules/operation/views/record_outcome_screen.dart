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
import '../../auth/controllers/auth_controller.dart';

class RecordOutcomeScreen extends StatefulWidget {
  const RecordOutcomeScreen({super.key});

  @override
  State<RecordOutcomeScreen> createState() => _RecordOutcomeScreenState();
}

class _RecordOutcomeScreenState extends State<RecordOutcomeScreen> {
  final OperationController controller = Get.find<OperationController>();
  final formKey = GlobalKey<FormState>();
  final complicationsCtrl = TextEditingController();
  final recoveryNotesCtrl = TextEditingController();

  final Rx<OperationModel?> operation = Rx<OperationModel?>(null);
  final Rx<String?> selectedOutcome = Rx<String?>(null);

  @override
  void initState() {
    super.initState();
    final operationId = Get.arguments as String?;
    if (operationId != null) {
      _fetchFreshOperation(operationId);
    }
  }

  void _fetchFreshOperation(String operationId) {
    FirebaseFirestore.instance.collection('operations').doc(operationId).snapshots().listen((doc) {
      if (doc.exists) {
        final op = OperationModel.fromMap(doc.data()!, doc.id);
        operation.value = op;
        controller.selectedOperation.value = op;

        // Prepopulate if outcome already exists
        if (op.outcome != null) {
          selectedOutcome.value = op.outcome!.patientCondition;
          complicationsCtrl.text = op.outcome!.complications;
          recoveryNotesCtrl.text = op.outcome!.notes;
        }
      }
    });
  }

  Future<void> submitOutcome() async {
    final op = operation.value;
    if (op == null) return;

    if (formKey.currentState!.validate() && selectedOutcome.value != null) {
      final currentUserId = Get.find<AuthController>().currentUser.value?.uid ?? 'Doctor';

      final outcomeModel = OperationOutcomeModel(
        notes: recoveryNotesCtrl.text.trim(),
        complications: complicationsCtrl.text.trim(),
        patientCondition: selectedOutcome.value!,
        submittedAt: DateTime.now(),
        submittedBy: currentUserId,
      );

      await controller.recordOutcome(op.operationId, outcomeModel);
    } else if (selectedOutcome.value == null) {
      Get.snackbar(
        'Selection Required',
        'Please select the operation outcome category.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Record Outcome', style: AppTextStyles.headlineMedium),
      ),
      body: Obx(() {
        final op = operation.value;
        if (op == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 550 : double.infinity,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Operation Brief Card
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingL),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              op.surgeryType,
                              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryLight),
                            ),
                            const SizedBox(height: 8),
                            Text('Patient: ${op.patientName}', style: AppTextStyles.bodyLarge),
                            const SizedBox(height: 4),
                            Text('OT Room: ${op.otRoom}', style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${DateFormat('MMMM d, yyyy').format(op.scheduledDate)} at ${op.scheduledTime}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Outcome Selector Dropdown
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 100),
                      child: AppDropdown<String>(
                        value: selectedOutcome.value,
                        label: 'Operation Outcome Status',
                        hint: 'Select Outcome',
                        prefixIcon: Icons.poll_outlined,
                        items: [
                          'Successful',
                          'Unsuccessful',
                          'Minor Complications',
                          'Major Complications',
                        ].map((outcome) {
                          return DropdownMenuItem<String>(
                            value: outcome,
                            child: Text(outcome),
                          );
                        }).toList(),
                        onChanged: (val) => selectedOutcome.value = val,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Complications Notes TextField
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 150),
                      child: AppTextField(
                        controller: complicationsCtrl,
                        label: 'Complications Notes',
                        hint: 'Describe any complications or type "None"...',
                        prefixIcon: Icons.warning_amber_outlined,
                        maxLines: 3,
                        validator: (val) => Validators.validateRequired(val, fieldName: 'Complications Notes'),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Postoperative Recovery Notes TextField
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 200),
                      child: AppTextField(
                        controller: recoveryNotesCtrl,
                        label: 'Postoperative Instructions',
                        hint: 'Describe recovery instructions, dietary care, etc...',
                        prefixIcon: Icons.healing_outlined,
                        maxLines: 4,
                        validator: (val) => Validators.validateRequired(val, fieldName: 'Postoperative Instructions'),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXL),

                    // Submit Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 250),
                      child: PrimaryButton(
                        onPressed: controller.isLoading.value ? null : submitOutcome,
                        label: 'Submit Outcome',
                        isLoading: controller.isLoading.value,
                      ),
                    ),
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
