import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared_widgets/chips/status_chip.dart';
import '../controllers/operation_tracking_controller.dart';

class OperationStatusScreen extends GetView<OperationTrackingController> {
  const OperationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Live OT Tracking', style: AppTextStyles.headlineMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final operation = controller.currentOperation.value;
        if (operation == null) {
          return Center(
            child: Text(
              'No active operation found.',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
          );
        }

        final activeIndex = controller.currentStepIndex;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.glassBackground,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      Text('Operation ID', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(operation.operationId.toUpperCase(), style: AppTextStyles.titleLarge),
                      const SizedBox(height: AppDimensions.paddingM),
                      const Divider(color: AppColors.glassBorder),
                      const SizedBox(height: AppDimensions.paddingM),
                      Text(
                        'Last Updated: ${operation.updatedAt.hour.toString().padLeft(2, '0')}:${operation.updatedAt.minute.toString().padLeft(2, '0')}',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),

              // Vertical Stepper
              Padding(
                padding: const EdgeInsets.only(left: AppDimensions.paddingL),
                child: Column(
                  children: [
                    _StepperItem(
                      index: 0,
                      activeIndex: activeIndex,
                      title: 'Pre-Op Preparation',
                      description: 'Patient is being prepared for surgery.',
                      chipColor: AppColors.primary,
                      isLast: false,
                    ),
                    _StepperItem(
                      index: 1,
                      activeIndex: activeIndex,
                      title: 'In Surgery',
                      description: 'The operation is currently in progress.',
                      chipColor: AppColors.secondary,
                      isLast: false,
                    ),
                    _StepperItem(
                      index: 2,
                      activeIndex: activeIndex,
                      title: 'Recovery Room',
                      description: 'Patient has been moved to recovery.',
                      chipColor: AppColors.warning,
                      isLast: false,
                    ),
                    _StepperItem(
                      index: 3,
                      activeIndex: activeIndex,
                      title: 'Completed',
                      description: 'The operation procedure is fully complete.',
                      chipColor: AppColors.success,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              // SRS-59: Download Report Button
              if (operation.reportUrl != null && operation.reportUrl!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingXXL),
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  child: Obx(() => ElevatedButton.icon(
                    onPressed: controller.isDownloading.value
                        ? null
                        : () => controller.downloadReport(operation.reportUrl!),
                    icon: controller.isDownloading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                          )
                        : const Icon(Icons.picture_as_pdf_outlined),
                    label: Text(
                      controller.isDownloading.value ? 'Downloading...' : 'Download Report',
                      style: AppTextStyles.labelLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
                    ),
                  )),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _StepperItem extends StatelessWidget {
  final int index;
  final int activeIndex;
  final String title;
  final String description;
  final Color chipColor;
  final bool isLast;

  const _StepperItem({
    required this.index,
    required this.activeIndex,
    required this.title,
    required this.description,
    required this.chipColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < activeIndex;
    final isActive = index == activeIndex;
    final isFuture = index > activeIndex;

    Color nodeColor = isFuture ? AppColors.glassBorder : chipColor;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Node and Line
          Column(
            children: [
              // Node
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? nodeColor : (isCompleted ? nodeColor : AppColors.surfaceOverlay),
                  border: Border.all(
                    color: nodeColor,
                    width: isActive || isCompleted ? 0 : 2,
                  ),
                  boxShadow: isActive && index == 1 // In Surgery pulse (SRS-53)
                      ? [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 4,
                          )
                        ]
                      : [],
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: AppColors.onPrimary)
                    : (isActive ? _PulsingInnerCircle(color: AppColors.onPrimary) : null),
              ),
              // Line
              if (!isLast)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 2,
                    color: isCompleted ? chipColor : AppColors.glassBorder,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingL),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isFuture ? AppColors.textSecondary : AppColors.textPrimary,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: AppDimensions.paddingM),
                        StatusChip(label: 'Live', color: chipColor),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingInnerCircle extends StatefulWidget {
  final Color color;
  const _PulsingInnerCircle({required this.color});

  @override
  _PulsingInnerCircleState createState() => _PulsingInnerCircleState();
}

class _PulsingInnerCircleState extends State<_PulsingInnerCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
        ),
      ),
    );
  }
}
