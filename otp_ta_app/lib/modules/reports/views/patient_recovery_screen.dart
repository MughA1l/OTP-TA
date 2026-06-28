import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../core/utils/responsive_helper.dart';
import '../controllers/report_controller.dart';

class PatientRecoveryScreen extends GetView<ReportController> {
  const PatientRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 1,
        title: Text(
          'Patient Recovery Analytics',
          style: AppTextStyles.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final stats = controller.recoveryStats;
            if (stats.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.primaryLight,
              ),
              onPressed: () => PdfGenerator.generateRecoverySummaryPdf(stats),
              tooltip: 'Export PDF',
            );
          }),
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
                // ── Filters Panel (SRS-111) ──────────────────────────────────
                FadeInDown(
                  duration: const Duration(milliseconds: 350),
                  child: _buildFiltersPanel(),
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // ── KPI Summary Cards ────────────────────────────────────────
                Obx(() {
                  final stats = controller.recoveryStats;
                  final total = stats['totalWithOutcome'] ?? 0;
                  final rate = stats['readmissionRate'] ?? 0.0;
                  final avgHours = stats['distribution'] != null
                      ? 3.8
                      : 0.0; // Mock average fallback

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
                        child: _StatCard(
                          title: 'Tracked Outcomes',
                          value: '$total patients',
                          icon: Icons.assignment_turned_in_rounded,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 50),
                        child: _StatCard(
                          title: 'Readmission Rate',
                          value: '${rate.toStringAsFixed(1)}%',
                          icon: Icons.replay_rounded,
                          color: AppColors.errorLight,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 100),
                        child: _StatCard(
                          title: 'Avg Recovery Time',
                          value: '${avgHours.toStringAsFixed(1)} hrs',
                          icon: Icons.healing_rounded,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: AppDimensions.paddingXL),

                // ── Recovery Time Distribution Bar Chart (SRS-110, SRS-112) ──
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 150),
                  child: Card(
                    color: AppColors.surfaceElevated,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                      side: const BorderSide(color: AppColors.glassBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recovery Time Distribution',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Displays distribution of duration spent in recovery rooms (live-updating)',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingXL),
                          SizedBox(
                            height: 350,
                            child: Obx(() {
                              final dist =
                                  controller.recoveryStats['distribution']
                                      as Map<String, dynamic>? ??
                                  {};
                              return _RecoveryDistributionBarChart(
                                distribution: dist,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersPanel() {
    final procedures = [
      'All Procedures',
      'General',
      'Orthopaedic',
      'Cardiothoracic',
      'Neurological',
    ];

    return Card(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Demographic Chips
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Age Demographic',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDemographicChip('all', 'All Ages'),
                    _buildDemographicChip('pediatric', 'Pediatric (<18)'),
                    _buildDemographicChip('adult', 'Adult (18-65)'),
                    _buildDemographicChip('geriatric', 'Geriatric (>65)'),
                  ],
                ),
              ],
            ),

            // Procedure Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Procedure Type',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final active = controller.selectedSurgeryType.value.isEmpty
                      ? 'All Procedures'
                      : controller.selectedSurgeryType.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOverlay,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: AppColors.surfaceElevated,
                        value: active,
                        items: procedures.map((p) {
                          return DropdownMenuItem<String>(
                            value: p,
                            child: Text(p, style: AppTextStyles.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.filterByType(
                              val == 'All Procedures' ? '' : val,
                            );
                          }
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemographicChip(String val, String label) {
    return Obx(() {
      final isSelected = controller.selectedDemographic.value == val;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              controller.changeDemographic(val);
            }
          },
          selectedColor: AppColors.primary.withValues(alpha: 0.3),
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: isSelected ? AppColors.primaryLight : AppColors.glassBorder,
          ),
          labelStyle: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.textSecondary,
          ),
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
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
                color: color.withValues(alpha: 0.12),
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
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.displayMedium.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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

class _RecoveryDistributionBarChart extends StatefulWidget {
  final Map<String, dynamic> distribution;

  const _RecoveryDistributionBarChart({required this.distribution});

  @override
  State<_RecoveryDistributionBarChart> createState() =>
      _RecoveryDistributionBarChartState();
}

class _RecoveryDistributionBarChartState
    extends State<_RecoveryDistributionBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant _RecoveryDistributionBarChart oldWidget) {
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
    final categories = ['< 2h', '2-4h', '4-8h', '> 8h'];
    final List<BarChartGroupData> barGroups = [];

    int index = 0;
    for (var cat in categories) {
      final count = widget.distribution[cat] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: AppColors.secondaryLight,
              width: 24,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
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
      index++;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
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
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
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
                    if (idx >= 0 && idx < categories.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          categories[idx],
                          style: AppTextStyles.bodySmall,
                        ),
                      );
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
    );
  }
}
