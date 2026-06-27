# 🎨 OT Procedures & Tracking App — Design System: Colors

> **Theme:** Strict Dark Mode  
> **Philosophy:** Premium Healthcare UI — Authoritative, Clinical, and Trustworthy.  
> A dark background reduces eye strain in clinical settings (OT rooms, ICUs), creates strong contrast for critical data, and evokes the premium, high-tech feel of a modern healthcare platform.

---

## 🌑 Core Background Colors

These form the layered depth of the UI — the "canvas" upon which all components are placed.

| Token Name               | Hex Code    | Usage Context                                                                   |
|--------------------------|-------------|---------------------------------------------------------------------------------|
| `colorBackground`        | `#080A0E`   | **Base background** of all screens. Near-pure black with a subtle cool tint.    |
| `colorSurface`           | `#101318`   | **Card/Container background.** Slightly lighter than base — creates card depth. |
| `colorSurfaceElevated`   | `#181C24`   | **Elevated surfaces** (modals, bottom sheets, dialogs). One step above surface.  |
| `colorSurfaceOverlay`    | `#1E2330`   | **Input fields, dropdowns, table rows.** Higher elevation interactive containers.|

---

## 💙 Primary Color — Surgical Blue (Action & Identity)

The primary accent color. Represents precision, clarity, and trust — core values in healthcare. Used for all primary interactive elements.

| Token Name                  | Hex Code    | Usage Context                                                                   |
|-----------------------------|-------------|---------------------------------------------------------------------------------|
| `colorPrimary`              | `#1A7FFA`   | **Primary buttons, CTAs, active navigation icons, progress bars.**              |
| `colorPrimaryLight`         | `#4DA3FF`   | **Hover states, selected chips, ripple effects.** Lighter variant.              |
| `colorPrimaryDark`          | `#0F5CBF`   | **Pressed/focused states** on buttons. Darker variant for depth feedback.       |
| `colorPrimaryContainer`     | `#0D2040`   | **Background of primary-themed containers** (e.g., selected nav item backdrop). |
| `colorOnPrimary`            | `#FFFFFF`   | **Text/icon color ON top of `colorPrimary`.** Always white for contrast.        |

> **Dart Token:**
> ```dart
> static const Color colorPrimary = Color(0xFF1A7FFA);
> ```

---

## 🩵 Secondary Color — Teal Aqua (Status & Information)

A calming, clinical teal that complements the blue. Used for informational status indicators, secondary actions, and highlights.

| Token Name                   | Hex Code    | Usage Context                                                                      |
|------------------------------|-------------|------------------------------------------------------------------------------------|
| `colorSecondary`             | `#00C4B4`   | **Secondary buttons, status tags (e.g., "In Recovery"), info highlights.**         |
| `colorSecondaryLight`        | `#3DFFE4`   | **Glowing accent for real-time status pulse animations** (e.g., live OT tracking). |
| `colorSecondaryDark`         | `#008A7D`   | **Pressed/hover state** for secondary interactive elements.                        |
| `colorSecondaryContainer`    | `#002A27`   | **Background of secondary-themed chips, tags, and info banners.**                  |
| `colorOnSecondary`           | `#000000`   | **Text/icon color ON top of `colorSecondary`.** Black for maximum contrast.        |

> **Dart Token:**
> ```dart
> static const Color colorSecondary = Color(0xFF00C4B4);
> ```

---

## ✅ Semantic: Success — Vital Green (Positive Outcomes)

Represents successful operations, completed surgeries, active accounts, and confirmed states.

| Token Name               | Hex Code    | Usage Context                                                                       |
|--------------------------|-------------|-------------------------------------------------------------------------------------|
| `colorSuccess`           | `#22C55E`   | **"Operation Successful" banner, registered messages, active account badges.**      |
| `colorSuccessLight`      | `#4ADE80`   | **Glow/shimmer on success animations** (e.g., post-surgery credential generation). |
| `colorSuccessDark`       | `#16A34A`   | **Darker success for body text within success banners.**                            |
| `colorSuccessContainer`  | `#052E16`   | **Background of success snackbars, toast messages, and status chips.**              |
| `colorOnSuccess`         | `#FFFFFF`   | **Text/icon color ON top of `colorSuccess`.**                                       |

---

## ⚠️ Semantic: Warning — Amber (Caution & Alerts)

Used for pending states, workload warnings, appointment reminders, and non-critical alerts.

| Token Name               | Hex Code    | Usage Context                                                                       |
|--------------------------|-------------|-------------------------------------------------------------------------------------|
| `colorWarning`           | `#F59E0B`   | **"Pending" status, doctor workload threshold warning, appointment reminders.**     |
| `colorWarningLight`      | `#FCD34D`   | **Light amber for icon accents** within warning cards.                              |
| `colorWarningDark`       | `#B45309`   | **Darker text within warning banners.**                                             |
| `colorWarningContainer`  | `#2A1800`   | **Background of warning snackbars, high-workload flags.**                           |
| `colorOnWarning`         | `#000000`   | **Text/icon color ON top of `colorWarning`.**                                       |

---

## 🔴 Semantic: Error — Crimson Red (Failures & Emergencies)

Reserved exclusively for errors, invalid inputs, access denied states, and the **Emergency Alert** feature.

| Token Name               | Hex Code    | Usage Context                                                                       |
|--------------------------|-------------|-------------------------------------------------------------------------------------|
| `colorError`             | `#EF4444`   | **Form validation errors, failed actions, "Access Denied" messages.**               |
| `colorErrorEmergency`    | `#FF2020`   | **Emergency Alert button.** More saturated red to signal critical urgency.          |
| `colorErrorLight`        | `#FCA5A5`   | **Error text color within dark error containers.**                                  |
| `colorErrorDark`         | `#B91C1C`   | **Pressed state on error/delete buttons.**                                          |
| `colorErrorContainer`    | `#2A0909`   | **Background of error snackbars, invalid field highlights.**                        |
| `colorOnError`           | `#FFFFFF`   | **Text/icon color ON top of `colorError`.**                                         |

---

## 🔵 Semantic: Info — Sky Blue (Informational)

Used for informational tooltips, help banners, and non-critical system messages.

| Token Name               | Hex Code    | Usage Context                                                                       |
|--------------------------|-------------|-------------------------------------------------------------------------------------|
| `colorInfo`              | `#3B82F6`   | **Info banners, "Account verification sent" messages, tooltip backgrounds.**        |
| `colorInfoContainer`     | `#0C1A3A`   | **Background of informational cards and notification chips.**                       |
| `colorOnInfo`            | `#FFFFFF`   | **Text/icon color ON top of `colorInfo`.**                                          |

---

## 📝 Typography Colors

| Token Name               | Hex Code    | Usage Context                                                                    |
|--------------------------|-------------|----------------------------------------------------------------------------------|
| `colorTextPrimary`       | `#F0F4FF`   | **Primary headings, screen titles, key values.** Slightly cool-toned white.      |
| `colorTextSecondary`     | `#9AA5C0`   | **Subtitles, labels, metadata, helper text.** Muted slate-blue.                  |
| `colorTextTertiary`      | `#5A6480`   | **Disabled text, placeholder text, timestamps.** Very muted for low hierarchy.   |
| `colorTextInverse`       | `#080A0E`   | **Text placed on light/primary colored backgrounds.**                            |
| `colorTextLink`          | `#4DA3FF`   | **Hyperlinks, "Forgot Password", "View Details" text buttons.**                  |

---

## 🖊️ Border & Divider Colors

| Token Name               | Hex Code    | Usage Context                                                                    |
|--------------------------|-------------|----------------------------------------------------------------------------------|
| `colorBorderSubtle`      | `#1E2535`   | **Default card borders, dividers between list items.** Nearly invisible.         |
| `colorBorderDefault`     | `#2A3350`   | **Input field borders, form container outlines.**                                |
| `colorBorderFocused`     | `#1A7FFA`   | **Input field border when focused.** Matches `colorPrimary`.                    |
| `colorBorderError`       | `#EF4444`   | **Input field border when in error state.** Matches `colorError`.               |

---

## 🌈 OT Status Chip Colors (Surgical Pipeline)

These are specialized colors for the real-time OT status pipeline — the app's most unique feature.

| Status Token                  | Background  | Foreground   | Label             |
|-------------------------------|-------------|--------------|-------------------|
| `colorStatusScheduled`        | `#1E2F4D`   | `#4DA3FF`    | Scheduled         |
| `colorStatusPreOp`            | `#2A1F00`   | `#FCD34D`    | Pre-Operative     |
| `colorStatusInSurgery`        | `#002626`   | `#3DFFE4`    | In Surgery ● Live |
| `colorStatusRecovery`         | `#001A14`   | `#22C55E`    | Recovery Room     |
| `colorStatusCompleted`        | `#0A200F`   | `#4ADE80`    | Completed         |
| `colorStatusCancelled`        | `#1F0A0A`   | `#FCA5A5`    | Cancelled         |

---

## ✨ Glassmorphism & Overlay

| Token Name                  | Value                     | Usage Context                                                          |
|-----------------------------|---------------------------|------------------------------------------------------------------------|
| `colorGlassBorder`          | `rgba(255,255,255, 0.08)` | **Border of glass cards.** Subtle white tint.                          |
| `colorGlassBackground`      | `rgba(16, 19, 24, 0.70)`  | **Fill of glass panels** with `BackdropFilter blur: 24`.               |
| `colorShimmerBase`          | `#1A1E2A`                 | **Skeleton loader base color** during data fetching.                   |
| `colorShimmerHighlight`     | `#252B3B`                 | **Shimmer highlight color** — subtle gradient sweep animation.         |
| `colorScrim`                | `rgba(0, 0, 0, 0.65)`     | **Modal/bottom sheet backdrop overlay.**                               |

---

## 🎯 Complete Dart Color Constants — `app_colors.dart`

> Copy this into `lib/core/constants/app_colors.dart`

```dart
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
```

---

## 📐 Design Tokens Quick Reference

| Category       | Primary Hex   | Light Hex    | Dark Hex     | Container Hex |
|----------------|---------------|--------------|--------------|---------------|
| **Background** | `#080A0E`     | `#101318`    | `#181C24`    | `#1E2330`     |
| **Primary**    | `#1A7FFA`     | `#4DA3FF`    | `#0F5CBF`    | `#0D2040`     |
| **Secondary**  | `#00C4B4`     | `#3DFFE4`    | `#008A7D`    | `#002A27`     |
| **Success**    | `#22C55E`     | `#4ADE80`    | `#16A34A`    | `#052E16`     |
| **Warning**    | `#F59E0B`     | `#FCD34D`    | `#B45309`    | `#2A1800`     |
| **Error**      | `#EF4444`     | `#FCA5A5`    | `#B91C1C`    | `#2A0909`     |
| **Info**       | `#3B82F6`     | —            | —            | `#0C1A3A`     |

---

*Document Version: 1.0 | OT Procedures & Tracking App | Healthcare Design System*
