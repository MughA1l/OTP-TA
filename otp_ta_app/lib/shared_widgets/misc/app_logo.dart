import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

/// Reusable App Logo widget used on Splash, Login, and headers
class AppLogo extends StatelessWidget {
  final double iconSize;
  final bool showText;
  final bool showTagline;

  const AppLogo({
    super.key,
    this.iconSize = 56,
    this.showText = true,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon container with glow
        Container(
          padding: EdgeInsets.all(iconSize * 0.22),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Icon(
            Icons.medical_services_rounded,
            size: iconSize,
            color: AppColors.primary,
          ),
        ),

        if (showText) ...[
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'OTP & TA',
            style: AppTextStyles.headlineLarge.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],

        if (showTagline) ...[
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            'OT Procedures & Tracking',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
