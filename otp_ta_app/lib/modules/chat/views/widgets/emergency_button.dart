import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmergencyButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isTriggered;

  const EmergencyButton({
    super.key,
    required this.onTap,
    this.isTriggered = false,
  });

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isTriggered ? AppColors.error : Colors.redAccent.shade700;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Pulsing Ring
            Container(
              width: 56 * _pulseAnimation.value,
              height: 56 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity((2.0 - _pulseAnimation.value) / 3),
              ),
            ),
            // Inner Pulsing Ring
            Container(
              width: 48 * _pulseAnimation.value,
              height: 48 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity((2.0 - _pulseAnimation.value) / 2),
              ),
            ),
            // Main Button
            GestureDetector(
              onTap: () {
                _showConfirmationDialog(context);
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
            const SizedBox(width: 8),
            Text('Trigger Emergency?', style: AppTextStyles.titleLarge.copyWith(color: AppColors.error)),
          ],
        ),
        content: Text(
          'This will immediately send a high-priority push notification and SMS dispatch to the entire surgical/ICU team. Are you sure?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.back();
              widget.onTap();
            },
            child: Text('TRIGGER', style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
