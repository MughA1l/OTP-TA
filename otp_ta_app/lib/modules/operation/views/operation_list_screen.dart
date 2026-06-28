import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../shared_widgets/inputs/app_dropdown.dart';
import '../../../data/models/operation_model.dart';
import '../controllers/operation_controller.dart';

class OperationListScreen extends StatefulWidget {
  const OperationListScreen({super.key});

  @override
  State<OperationListScreen> createState() => _OperationListScreenState();
}

class _OperationListScreenState extends State<OperationListScreen> {
  final OperationController controller = Get.find<OperationController>();
  final ScrollController scrollController = ScrollController();

  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final Rx<String?> selectedStatus = Rx<String?>(null);
  final Rx<String?> selectedDoctorId = Rx<String?>(null);
  final patientIdCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applyFilters(isInitial: true);
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    patientIdCtrl.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      controller.fetchHistory(filters: _getFilterMap());
    }
  }

  Map<String, dynamic> _getFilterMap() {
    return {
      if (selectedStatus.value != null) 'status': selectedStatus.value,
      if (selectedDoctorId.value != null) 'doctorId': selectedDoctorId.value,
      if (patientIdCtrl.text.trim().isNotEmpty) 'patientId': patientIdCtrl.text.trim(),
      if (selectedDateRange.value != null) ...{
        'dateRangeStart': selectedDateRange.value!.start,
        'dateRangeEnd': selectedDateRange.value!.end,
      }
    };
  }

  void _applyFilters({bool isInitial = false}) {
    controller.fetchHistory(isRefresh: true, filters: _getFilterMap());
  }

  void _clearFilters() {
    selectedDateRange.value = null;
    selectedStatus.value = null;
    selectedDoctorId.value = null;
    patientIdCtrl.clear();
    _applyFilters();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      selectedDateRange.value = picked;
      _applyFilters();
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
        title: Text('Operation Records Directory', style: AppTextStyles.headlineMedium),
        actions: [
          // Clear Filters button
          IconButton(
            icon: const Icon(Icons.filter_alt_off_outlined, color: AppColors.textSecondary),
            onPressed: _clearFilters,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Panel at the top
          _buildFilterPanel(context, isWeb),
          
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.operationsList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: _buildShimmerSkeleton(),
                );
              }

              if (controller.operationsList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.assignment_late_outlined, size: 64, color: AppColors.textTertiary),
                      const SizedBox(height: 16),
                      Text('No operations matches filters.', style: AppTextStyles.titleLarge),
                      const SizedBox(height: 8),
                      Text('Try adjusting or clearing your filters.', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _applyFilters(),
                color: AppColors.primary,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  itemCount: controller.operationsList.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.operationsList.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    }

                    final op = controller.operationsList[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: _buildOperationCard(op),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context, bool isWeb) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingS),
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
            children: [
              const Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Search Filters', style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Search by Patient ID
              SizedBox(
                width: isWeb ? 220 : double.infinity,
                child: AppTextField(
                  controller: patientIdCtrl,
                  label: 'Patient ID',
                  hint: 'Search patient...',
                  prefixIcon: Icons.search,
                  onChanged: (_) => _applyFilters(),
                ),
              ),

              // Filter by Status
              SizedBox(
                width: isWeb ? 200 : double.infinity,
                child: AppDropdown<String>(
                  value: selectedStatus.value,
                  label: 'Status',
                  hint: 'Choose status',
                  prefixIcon: Icons.info_outline,
                  items: OperationStatus.values.map((status) {
                    return DropdownMenuItem<String>(
                      value: status.name,
                      child: Text(status.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedStatus.value = val;
                    _applyFilters();
                  },
                ),
              ),

              // Filter by Doctor
              SizedBox(
                width: isWeb ? 220 : double.infinity,
                child: AppDropdown<String>(
                  value: selectedDoctorId.value,
                  label: 'Surgeon',
                  hint: 'Choose Surgeon',
                  prefixIcon: Icons.healing_outlined,
                  items: controller.doctorList.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc.doctorId,
                      child: Text(doc.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedDoctorId.value = val;
                    _applyFilters();
                  },
                ),
              ),

              // Date Range Picker Button
              SizedBox(
                width: isWeb ? 200 : double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () => _selectDateRange(context),
                  icon: const Icon(Icons.calendar_month_outlined, color: AppColors.textPrimary),
                  label: Text(
                    selectedDateRange.value == null
                        ? 'Date Range'
                        : '${DateFormat('MM/dd').format(selectedDateRange.value!.start)} - ${DateFormat('MM/dd').format(selectedDateRange.value!.end)}',
                    style: AppTextStyles.labelLarge,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderDefault),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOperationCard(OperationModel op) {
    final leadDoc = controller.doctorList.firstWhereOrNull((d) => d.doctorId == op.surgicalTeam.primaryDoctorId);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      color: AppColors.surfaceOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/operation-detail', arguments: op.operationId),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      op.surgeryType,
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryLight),
                    ),
                  ),
                  // Status chip
                  _buildStatusChip(op.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('Patient: ${op.patientName}', style: AppTextStyles.bodyLarge),
              const SizedBox(height: 4),
              Text(
                'Surgeon: ${leadDoc != null ? leadDoc.name : 'Not Assigned'}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scheduled: ${DateFormat('MMM d, yyyy').format(op.scheduledDate)} at ${op.scheduledTime}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OperationStatus status) {
    Color color;
    switch (status) {
      case OperationStatus.scheduled:
        color = AppColors.warning;
        break;
      case OperationStatus.preOp:
        color = AppColors.secondaryLight;
        break;
      case OperationStatus.inSurgery:
        color = AppColors.primaryLight;
        break;
      case OperationStatus.recovery:
        color = AppColors.primary;
        break;
      case OperationStatus.completed:
        color = AppColors.success;
        break;
      case OperationStatus.cancelled:
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildShimmerSkeleton() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceElevated,
          highlightColor: AppColors.surfaceOverlay,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
          ),
        );
      },
    );
  }
}
