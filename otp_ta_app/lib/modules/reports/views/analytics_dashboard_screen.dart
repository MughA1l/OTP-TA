import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../routes/app_routes.dart';
import '../controllers/report_controller.dart';

class AnalyticsDashboardScreen extends GetView<ReportController> {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 1,
        title: Text('OT Analytics & Reports', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.healing_rounded, color: AppColors.secondaryLight, size: 20),
            label: Text('Patient Recovery', style: TextStyle(color: AppColors.secondaryLight)),
            onPressed: () => Get.toNamed(AppRoutes.patientRecovery),
          ),
          const SizedBox(width: AppDimensions.paddingM),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Timeframe & Filter Bar ────────────────────────────────────
                FadeInDown(
                  duration: const Duration(milliseconds: 350),
                  child: _buildFilterBar(context),
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // ── KPI Stat Cards Grid ──────────────────────────────────────
                Obx(() {
                  final data = controller.analytics.value;
                  final totalOps = data?.totalOperations ?? 0;
                  final successRate = data?.successRate ?? 0.0;
                  final avgDuration = data?.avgDurationMinutes ?? 0.0;

                  return GridView.count(
                    crossAxisCount: isDesktop ? 3 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppDimensions.paddingL,
                    mainAxisSpacing: AppDimensions.paddingL,
                    childAspectRatio: isDesktop ? 2.5 : 3.0,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        child: _KpiStatCard(
                          title: 'Total Operations',
                          value: '$totalOps',
                          icon: Icons.personal_injury_rounded,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 50),
                        child: _KpiStatCard(
                          title: 'Success Rate',
                          value: '${successRate.toStringAsFixed(1)}%',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 100),
                        child: _KpiStatCard(
                          title: 'Avg Op Duration',
                          value: '${avgDuration.toStringAsFixed(0)} min',
                          icon: Icons.timer_rounded,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: AppDimensions.paddingXL),

                // ── Charts Grid ──────────────────────────────────────────────
                Obx(() {
                  final data = controller.analytics.value;
                  if (data == null || controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: isDesktop ? 2 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppDimensions.paddingL,
                    mainAxisSpacing: AppDimensions.paddingL,
                    childAspectRatio: isDesktop ? 1.4 : 1.0,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: _SurgeryTypePieChart(typeData: data.operationsBySurgeryType),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 100),
                        child: _DailyOpsBarChart(dateData: data.operationsByDate),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Card(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Timeframe Segmented buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSegmentButton('weekly', 'Weekly'),
                _buildSegmentButton('monthly', 'Monthly'),
                _buildSegmentButton('custom', 'Custom Range'),
              ],
            ),

            // Custom date picker buttons (visible when timeframe is custom)
            Obx(() {
              if (controller.selectedTimeframe.value != 'custom') return const SizedBox.shrink();
              final startStr = controller.startDate.value != null ? DateFormat('MM/dd/yyyy').format(controller.startDate.value!) : 'Start';
              final endStr = controller.endDate.value != null ? DateFormat('MM/dd/yyyy').format(controller.endDate.value!) : 'End';

              return TextButton.icon(
                icon: const Icon(Icons.date_range_rounded, color: AppColors.primaryLight),
                label: Text('$startStr - $endStr', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryLight)),
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2025),
                    lastDate: DateTime.now().add(const Duration(days: 305)),
                    initialDateRange: controller.startDate.value != null && controller.endDate.value != null
                        ? DateTimeRange(start: controller.startDate.value!, end: controller.endDate.value!)
                        : null,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            surface: AppColors.surfaceElevated,
                            onSurface: AppColors.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    controller.setCustomDates(picked.start, picked.end);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String value, String label) {
    return Obx(() {
      final isSelected = controller.selectedTimeframe.value == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              controller.changeTimeframe(value);
            }
          },
          selectedColor: AppColors.primary.withOpacity(0.3),
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: isSelected ? AppColors.primaryLight : AppColors.glassBorder,
          ),
          labelStyle: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
          ),
        ),
      );
    });
  }
}

class _KpiStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceElevated,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppDimensions.paddingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 4),
                  // Animate stat text value
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, val, child) {
                      return Text(
                        value,
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
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

class _SurgeryTypePieChart extends StatelessWidget {
  final Map<String, int> typeData;

  const _SurgeryTypePieChart({required this.typeData});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primaryLight,
      AppColors.secondaryLight,
      Colors.amberAccent,
      Colors.redAccent,
      Colors.purpleAccent,
    ];

    int total = typeData.values.fold(0, (sum, val) => sum + val);

    final List<PieChartSectionData> sections = [];
    final List<Widget> legends = [];

    int index = 0;
    typeData.forEach((type, count) {
      final color = colors[index % colors.length];
      final percentage = total > 0 ? (count / total) * 100 : 0.0;
      
      sections.add(
        PieChartSectionData(
          color: color,
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      legends.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$type ($count)',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
      index++;
    });

    return Card(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Surgery Type Breakdown', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sections: sections.isEmpty
                            ? [
                                PieChartSectionData(
                                  color: Colors.grey,
                                  value: 1,
                                  title: 'N/A',
                                  radius: 60,
                                )
                              ]
                            : sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ListView(
                      shrinkWrap: true,
                      children: legends,
                    ),
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

class _DailyOpsBarChart extends StatefulWidget {
  final Map<String, int> dateData;

  const _DailyOpsBarChart({required this.dateData});

  @override
  State<_DailyOpsBarChart> createState() => _DailyOpsBarChartState();
}

class _DailyOpsBarChartState extends State<_DailyOpsBarChart> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant _DailyOpsBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animController.reset();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort dates chronologically
    final sortedKeys = widget.dateData.keys.toList()..sort();
    
    // Take last 7 data points
    final displayKeys = sortedKeys.length > 7 ? sortedKeys.sublist(sortedKeys.length - 7) : sortedKeys;

    final List<BarChartGroupData> barGroups = [];
    int xIndex = 0;
    
    for (var key in displayKeys) {
      final count = widget.dateData[key] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: xIndex,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: AppColors.secondaryLight,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 10,
                color: AppColors.surfaceOverlay,
              ),
            ),
          ],
        ),
      );
      xIndex++;
    }

    return Card(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operations Trend', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  // Apply growth animation from zero
                  final animatedGroups = barGroups.map((g) {
                    return BarChartGroupData(
                      x: g.x,
                      barRods: g.barRods.map((r) {
                        return BarChartRodData(
                          toY: r.toY * _scaleAnimation.value,
                          color: r.color,
                          width: r.width,
                          borderRadius: r.borderRadius,
                          backDrawRodData: r.backDrawRodData,
                        );
                      }).toList(),
                    );
                  }).toList();

                  return BarChart(
                    BarChartData(
                      barGroups: animatedGroups,
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) {
                              return Text(
                                val.toInt().toString(),
                                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx >= 0 && idx < displayKeys.length) {
                                // Show day part of date
                                final parts = displayKeys[idx].split('-');
                                if (parts.length == 3) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      '${parts[1]}/${parts[2]}',
                                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                                    ),
                                  );
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
