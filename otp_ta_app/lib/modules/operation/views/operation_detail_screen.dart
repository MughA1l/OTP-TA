import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../data/models/operation_model.dart';
import '../controllers/operation_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class OperationDetailScreen extends StatefulWidget {
  const OperationDetailScreen({super.key});

  @override
  State<OperationDetailScreen> createState() => _OperationDetailScreenState();
}

class _OperationDetailScreenState extends State<OperationDetailScreen> {
  final OperationController controller = Get.find<OperationController>();
  final Rx<OperationModel?> operation = Rx<OperationModel?>(null);

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
        operation.value = OperationModel.fromMap(doc.data()!, doc.id);
      }
    });
  }

  Future<void> _pickAndUploadReport() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final op = operation.value;
      if (op != null) {
        await controller.uploadMedicalReport(file, op.operationId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveHelper.isDesktop(context);
    final authCtrl = Get.find<AuthController>();
    final userRole = authCtrl.currentUser.value?.role.name ?? 'patient';
    final isMedicalStaff = userRole == 'admin' || userRole == 'doctor';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Operation Details', style: AppTextStyles.headlineMedium),
      ),
      body: Stack(
        children: [
          Obx(() {
            final op = operation.value;
            if (op == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 700 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Card
                      FadeInDown(
                        duration: const Duration(milliseconds: 400),
                        child: _buildHeaderCard(op),
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                      // Surgical Team Section
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 100),
                        child: _buildTeamCard(op),
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                      // Outcome Section
                      if (op.outcome != null)
                        FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          delay: const Duration(milliseconds: 150),
                          child: _buildOutcomeCard(op.outcome!),
                        ),
                      const SizedBox(height: AppDimensions.paddingL),

                      // Medical Reports Section
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 200),
                        child: _buildReportsCard(op, isMedicalStaff),
                      ),
                      const SizedBox(height: AppDimensions.paddingXL),

                      // Actions section for doctors/admins
                      if (isMedicalStaff)
                        FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          delay: const Duration(milliseconds: 250),
                          child: _buildActionButtons(op, userRole),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Glassmorphic Upload Spinner Overlay (SRS-78)
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    child: Container(
                      width: 250,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOverlay.withOpacity(0.8),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Uploading Report...',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sending secure file to Cloudinary',
                            style: AppTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(OperationModel op) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  op.surgeryType,
                  style: AppTextStyles.displayMedium.copyWith(color: AppColors.primaryLight),
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(op.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  border: Border.all(color: _getStatusColor(op.status).withOpacity(0.5)),
                ),
                child: Text(
                  op.status.name.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _getStatusColor(op.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Patient Name', value: op.patientName),
          _InfoRow(label: 'OT Room', value: op.otRoom),
          _InfoRow(
            label: 'Scheduled',
            value: '${DateFormat('EEEE, MMMM d, yyyy').format(op.scheduledDate)} at ${op.scheduledTime}',
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(OperationModel op) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Surgical Team', style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 8),
          Obx(() {
            final leadDoc = controller.doctorList.firstWhereOrNull((d) => d.doctorId == op.surgicalTeam.primaryDoctorId);
            final anaDoc = controller.doctorList.firstWhereOrNull((d) => d.doctorId == op.surgicalTeam.anaesthesiologistId);

            return Column(
              children: [
                _InfoRow(label: 'Lead Surgeon', value: leadDoc != null ? leadDoc.name : 'Not Assigned'),
                _InfoRow(label: 'Anaesthesiologist', value: anaDoc != null ? anaDoc.name : 'Not Assigned'),
                _InfoRow(
                  label: 'Nursing Staff',
                  value: op.surgicalTeam.nursingStaff.isNotEmpty ? op.surgicalTeam.nursingStaff.join(', ') : 'None Assigned',
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOutcomeCard(OperationOutcomeModel outcome) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text('Surgery Outcome', style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 8),
          _InfoRow(label: 'Outcome Status', value: outcome.patientCondition),
          _InfoRow(label: 'Complications', value: outcome.complications),
          _InfoRow(label: 'Recovery Notes', value: outcome.notes),
          _InfoRow(
            label: 'Recorded On',
            value: DateFormat('MMM d, yyyy HH:mm').format(outcome.submittedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsCard(OperationModel op, bool isMedicalStaff) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf_outlined, color: AppColors.errorLight),
                  const SizedBox(width: 8),
                  Text('Medical Reports', style: AppTextStyles.titleLarge),
                ],
              ),
              if (isMedicalStaff)
                IconButton(
                  icon: const Icon(Icons.upload_file_outlined, color: AppColors.primaryLight),
                  onPressed: _pickAndUploadReport,
                  tooltip: 'Upload New Report',
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 8),
          if (op.reportUrls.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No reports uploaded yet.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: op.reportUrls.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final url = op.reportUrls[index];
                return InkWell(
                  onTap: () {
                    // Open URL in browser
                    Get.to(() => Scaffold(
                          appBar: AppBar(title: const Text('Medical Report')),
                          body: Center(
                            child: Image.network(
                              url,
                              errorBuilder: (_, __, ___) => const Text('Could not load image preview.'),
                            ),
                          ),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Report_${index + 1}.jpg',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryLight),
                          ),
                        ),
                        const Icon(Icons.open_in_new, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OperationModel op, String role) {
    return Column(
      children: [
        if (op.status != OperationStatus.completed && op.outcome == null && role == 'doctor') ...[
          PrimaryButton(
            label: 'Record Outcome',
            icon: Icons.assignment_turned_in_outlined,
            onPressed: () => Get.toNamed('/record-outcome', arguments: op.operationId),
          ),
          const SizedBox(height: 12),
        ],
        if (role == 'admin')
          PrimaryButton(
            label: 'Update Surgical Team',
            icon: Icons.edit_attributes_outlined,
            onPressed: () => Get.toNamed('/assign-team', arguments: op.operationId),
          ),
      ],
    );
  }

  Color _getStatusColor(OperationStatus status) {
    switch (status) {
      case OperationStatus.scheduled:
        return AppColors.warning;
      case OperationStatus.preOp:
        return AppColors.secondaryLight;
      case OperationStatus.inSurgery:
        return AppColors.primaryLight;
      case OperationStatus.recovery:
        return AppColors.primary;
      case OperationStatus.completed:
        return AppColors.success;
      case OperationStatus.cancelled:
        return AppColors.error;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyLarge),
          ),
        ],
      ),
    );
  }
}
