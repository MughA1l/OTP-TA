import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  // ─── Onboarding Page Data ────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _pages = [
    {
      'title': 'Real-Time OT Tracking',
      'subtitle':
          'Monitor every surgical procedure live. Track patient status from Pre-Op to Recovery with clinical precision.',
      'icon': Icons.monitor_heart_rounded,
      'gradientStart': AppColors.primary,
      'gradientEnd': AppColors.primaryDark,
      'glowColor': AppColors.primary,
    },
    {
      'title': 'Automated Patient Onboarding',
      'subtitle':
          'Generate secure login credentials for patients instantly when their operation is scheduled. Zero paperwork.',
      'icon': Icons.person_add_rounded,
      'gradientStart': AppColors.secondary,
      'gradientEnd': AppColors.secondaryDark,
      'glowColor': AppColors.secondary,
    },
    {
      'title': 'Stay Connected with Your Care Team',
      'subtitle':
          'Real-time chat, medication schedules, and emergency alerts keep the entire surgical team in sync.',
      'icon': Icons.groups_rounded,
      'gradientStart': AppColors.success,
      'gradientEnd': AppColors.successDark,
      'glowColor': AppColors.success,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Animated background radial gradient (changes per page) ──────
          Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.4),
                    radius: 1.2,
                    colors: [
                      (_pages[controller.currentPage.value]['glowColor'] as Color)
                          .withOpacity(0.12),
                      AppColors.background,
                    ],
                  ),
                ),
              )),

          // ─── Main Page Content ────────────────────────────────────────────
          Column(
            children: [
              // Skip button (top-right)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                    vertical: AppDimensions.paddingM,
                  ),
                  child: Obx(() => AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: controller.isLastPage ? 0.0 : 1.0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: controller.isLastPage
                                ? null
                                : controller.skipOnboarding,
                            child: Text(
                              'Skip',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.textLink,
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),

              // ─── PageView ────────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      data: _pages[index],
                      pageIndex: index,
                    );
                  },
                ),
              ),

              // ─── Indicator dots + CTA button ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingL,
                  AppDimensions.paddingM,
                  AppDimensions.paddingL,
                  AppDimensions.paddingXXL,
                ),
                child: Column(
                  children: [
                    // Animated page indicator dots
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => _DotIndicator(
                              isActive: controller.currentPage.value == index,
                              color: (_pages[controller.currentPage.value]
                                  ['glowColor'] as Color),
                            ),
                          ),
                        )),

                    const SizedBox(height: AppDimensions.paddingXL),

                    // Next / Get Started CTA
                    Obx(() => GestureDetector(
                          onTap: controller.nextPage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOutCubic,
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _pages[controller.currentPage.value]
                                      ['gradientStart'] as Color,
                                  _pages[controller.currentPage.value]
                                      ['gradientEnd'] as Color,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusL),
                              boxShadow: [
                                BoxShadow(
                                  color: (_pages[controller.currentPage.value]
                                              ['glowColor'] as Color)
                                          .withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.isLastPage
                                        ? 'Get Started'
                                        : 'Next',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    controller.isLastPage
                                        ? Icons.check_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: AppColors.onPrimary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Single Onboarding Page Widget ──────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final int pageIndex;

  const _OnboardingPage({required this.data, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glassmorphism Icon Container
          FadeInDown(
            key: ValueKey('icon_$pageIndex'),
            duration: const Duration(milliseconds: 600),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: (data['glowColor'] as Color).withOpacity(0.12),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(
                      color: (data['glowColor'] as Color).withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (data['glowColor'] as Color).withOpacity(0.25),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    data['icon'] as IconData,
                    size: 80,
                    color: data['glowColor'] as Color,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXXL),

          // Title
          FadeInUp(
            key: ValueKey('title_$pageIndex'),
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 150),
            child: Text(
              data['title'] as String,
              style: AppTextStyles.displayMedium.copyWith(
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          // Subtitle
          FadeInUp(
            key: ValueKey('subtitle_$pageIndex'),
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 300),
            child: Text(
              data['subtitle'] as String,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.7,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Animated Dot Indicator ──────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _DotIndicator({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : AppColors.borderDefault,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
