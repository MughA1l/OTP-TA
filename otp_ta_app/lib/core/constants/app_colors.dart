import 'package:flutter/material.dart';

/// OT Procedures & Tracking App — Design System: Color Tokens
/// Theme: Strict Dark Mode | Premium Healthcare
abstract class AppColors {
  // ─── Background ───────────────────────────────────────────────────────────
  static const Color background        = Color(0xFF080A0E);
  static const Color surface           = Color(0xFF101318);
  static const Color surfaceElevated   = Color(0xFF181C24);
  static const Color surfaceOverlay    = Color(0xFF1E2330);

  // ─── Primary: Surgical Blue ───────────────────────────────────────────────
  static const Color primary           = Color(0xFF1A7FFA);
  static const Color primaryLight      = Color(0xFF4DA3FF);
  static const Color primaryDark       = Color(0xFF0F5CBF);
  static const Color primaryContainer  = Color(0xFF0D2040);
  static const Color onPrimary         = Color(0xFFFFFFFF);

  // ─── Secondary: Teal Aqua ─────────────────────────────────────────────────
  static const Color secondary         = Color(0xFF00C4B4);
  static const Color secondaryLight    = Color(0xFF3DFFE4);
  static const Color secondaryDark     = Color(0xFF008A7D);
  static const Color secondaryContainer= Color(0xFF002A27);
  static const Color onSecondary       = Color(0xFF000000);

  // ─── Success: Vital Green ─────────────────────────────────────────────────
  static const Color success           = Color(0xFF22C55E);
  static const Color successLight      = Color(0xFF4ADE80);
  static const Color successDark       = Color(0xFF16A34A);
  static const Color successContainer  = Color(0xFF052E16);
  static const Color onSuccess         = Color(0xFFFFFFFF);

  // ─── Warning: Amber ───────────────────────────────────────────────────────
  static const Color warning           = Color(0xFFF59E0B);
  static const Color warningLight      = Color(0xFFFCD34D);
  static const Color warningDark       = Color(0xFFB45309);
  static const Color warningContainer  = Color(0xFF2A1800);
  static const Color onWarning         = Color(0xFF000000);

  // ─── Error: Crimson Red ───────────────────────────────────────────────────
  static const Color error             = Color(0xFFEF4444);
  static const Color errorEmergency    = Color(0xFFFF2020);
  static const Color errorLight        = Color(0xFFFCA5A5);
  static const Color errorDark         = Color(0xFFB91C1C);
  static const Color errorContainer    = Color(0xFF2A0909);
  static const Color onError           = Color(0xFFFFFFFF);

  // ─── Info: Sky Blue ───────────────────────────────────────────────────────
  static const Color info              = Color(0xFF3B82F6);
  static const Color infoContainer     = Color(0xFF0C1A3A);
  static const Color onInfo            = Color(0xFFFFFFFF);

  // ─── Typography ───────────────────────────────────────────────────────────
  static const Color textPrimary       = Color(0xFFF0F4FF);
  static const Color textSecondary     = Color(0xFF9AA5C0);
  static const Color textTertiary      = Color(0xFF5A6480);
  static const Color textInverse       = Color(0xFF080A0E);
  static const Color textLink          = Color(0xFF4DA3FF);

  // ─── Borders ──────────────────────────────────────────────────────────────
  static const Color borderSubtle      = Color(0xFF1E2535);
  static const Color borderDefault     = Color(0xFF2A3350);
  static const Color borderFocused     = Color(0xFF1A7FFA);
  static const Color borderError       = Color(0xFFEF4444);

  // ─── OT Status Pipeline ───────────────────────────────────────────────────
  static const Color statusScheduledBg = Color(0xFF1E2F4D);
  static const Color statusScheduledFg = Color(0xFF4DA3FF);
  static const Color statusPreOpBg     = Color(0xFF2A1F00);
  static const Color statusPreOpFg     = Color(0xFFFCD34D);
  static const Color statusInSurgeryBg = Color(0xFF002626);
  static const Color statusInSurgeryFg = Color(0xFF3DFFE4);
  static const Color statusRecoveryBg  = Color(0xFF001A14);
  static const Color statusRecoveryFg  = Color(0xFF22C55E);
  static const Color statusCompletedBg = Color(0xFF0A200F);
  static const Color statusCompletedFg = Color(0xFF4ADE80);
  static const Color statusCancelledBg = Color(0xFF1F0A0A);
  static const Color statusCancelledFg = Color(0xFFFCA5A5);

  // ─── Glass & Overlays ─────────────────────────────────────────────────────
  static const Color glassBorder       = Color(0x14FFFFFF);
  static const Color glassBackground   = Color(0xB3101318);
  static const Color shimmerBase       = Color(0xFF1A1E2A);
  static const Color shimmerHighlight  = Color(0xFF252B3B);
  static const Color scrim             = Color(0xA6000000);
}
