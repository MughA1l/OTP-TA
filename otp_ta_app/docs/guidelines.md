# 📐 OT Procedures & Tracking App — Architecture & Coding Guidelines

> **Version:** 1.0 | **Date:** June 2026  
> **Architecture:** MVVM (Model — View — ViewModel)  
> **State Management:** GetX (overrides Provider mentioned in SRS/Proposal)  
> **Platform:** Flutter (Single codebase → Android Mobile + Web Portal)

---

## 📌 Table of Contents

1. [Architecture Overview — MVVM with GetX](#architecture)
2. [Folder Structure](#folder-structure)
3. [GetX Layer Responsibilities](#getx-layers)
4. [Naming Conventions](#naming-conventions)
5. [UI/UX Standards](#uiux-standards)
6. [Scroll & Animation Guidelines](#animations)
7. [Responsive Design (Mobile + Web)](#responsive-design)
8. [Firebase Integration Standards](#firebase)
9. [Error Handling Strategy](#error-handling)
10. [Code Quality Standards](#code-quality)

---

## 1. Architecture Overview — MVVM with GetX {#architecture}

```
┌─────────────────────────────────────────────────────────────────────┐
│                          USER INTERFACE                              │
│   View (Widget/Screen) — Only UI code, no business logic            │
│   Uses Obx() to reactively rebuild on controller state change       │
└────────────────────────┬────────────────────────────────────────────┘
                         │ calls methods on
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         VIEWMODEL LAYER                              │
│   GetxController — All business logic, UI state management          │
│   Calls Repository methods, exposes Rx<> observables to the View    │
└────────────────────────┬────────────────────────────────────────────┘
                         │ calls async data operations on
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                                  │
│   Repository — Abstracts all Firebase / API calls                   │
│   Models — Pure Dart data classes (no Flutter imports)              │
└─────────────────────────────────────────────────────────────────────┘
```

### Core Principle
- **View** → knows only the Controller. Zero business logic, zero Firebase calls.
- **Controller (ViewModel)** → knows only the Repository. Zero `BuildContext` usage (except for navigation via GetX routes).
- **Repository** → knows only Firebase/API services. Zero Flutter widgets.
- **Model** → Pure Dart. Zero Flutter, zero GetX imports.

---

## 2. Folder Structure {#folder-structure}

```
lib/
├── core/                               # App-wide configuration & utilities
│   ├── constants/
│   │   ├── app_colors.dart             # All color tokens (see colors.md)
│   │   ├── app_text_styles.dart        # Typography system (Inter font)
│   │   ├── app_dimensions.dart         # Padding, radius, spacing constants
│   │   ├── app_strings.dart            # All user-facing strings (i18n-ready)
│   │   ├── app_assets.dart             # Asset path references (images, icons)
│   │   └── firebase_constants.dart     # Collection names, field name strings
│   ├── theme/
│   │   ├── app_theme.dart              # ThemeData (dark mode) using AppColors
│   │   └── app_text_theme.dart         # TextTheme configuration
│   ├── network/
│   │   └── network_info.dart           # Internet connectivity checker
│   ├── utils/
│   │   ├── validators.dart             # Form validation logic (email, password)
│   │   ├── date_formatter.dart         # Date & time formatting helpers
│   │   ├── snackbar_helper.dart        # GetX snackbar wrappers (success/error)
│   │   ├── pdf_generator.dart          # PDF generation utility (operation reports)
│   │   ├── permission_handler.dart     # Camera/storage permissions handler
│   │   └── responsive_helper.dart      # Screen size breakpoint helpers
│   └── error/
│       ├── failures.dart               # Typed failure classes (AuthFailure, etc.)
│       └── exceptions.dart             # Custom exception classes
│
├── data/                               # Data layer — Firebase & API interactions
│   ├── models/
│   │   ├── user_model.dart             # Shared user base model
│   │   ├── admin_model.dart
│   │   ├── doctor_model.dart
│   │   ├── patient_model.dart
│   │   ├── staff_model.dart
│   │   ├── operation_model.dart        # OT record model
│   │   ├── appointment_model.dart
│   │   ├── prescription_model.dart
│   │   ├── chat_message_model.dart
│   │   ├── notification_model.dart
│   │   └── report_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart        # Firebase Auth operations
│   │   ├── admin_repository.dart
│   │   ├── doctor_repository.dart
│   │   ├── patient_repository.dart
│   │   ├── operation_repository.dart
│   │   ├── appointment_repository.dart
│   │   ├── medication_repository.dart
│   │   ├── chat_repository.dart        # Firestore real-time chat
│   │   ├── notification_repository.dart
│   │   └── report_repository.dart
│   └── local/
│       ├── local_storage.dart          # GetStorage for session persistence
│       └── cache_manager.dart          # Local caching strategy
│
├── controllers/                        # GetX Controllers (ViewModel layer)
│   ├── auth/
│   │   └── auth_controller.dart        # Login, logout, role-based routing
│   ├── admin/
│   │   ├── admin_dashboard_controller.dart
│   │   ├── staff_controller.dart
│   │   ├── doctor_management_controller.dart
│   │   ├── patient_management_controller.dart
│   │   ├── operation_controller.dart
│   │   ├── role_permission_controller.dart
│   │   └── report_controller.dart
│   ├── doctor/
│   │   ├── doctor_dashboard_controller.dart
│   │   ├── appointment_controller.dart
│   │   ├── prescription_controller.dart
│   │   └── patient_list_controller.dart
│   └── patient/
│       ├── patient_dashboard_controller.dart
│       ├── operation_status_controller.dart
│       └── medication_schedule_controller.dart
│
├── views/                              # UI Layer — Screens & Widgets ONLY
│   ├── splash/
│   │   └── splash_screen.dart          # Animated splash with logo
│   ├── onboarding/
│   │   ├── onboarding_screen.dart      # Multi-page onboarding (first launch only)
│   │   └── onboarding_page_model.dart  # Data class for onboarding pages
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── change_password_screen.dart
│   ├── admin_web/                      # Web-only layouts (wide-screen dashboards)
│   │   ├── layouts/
│   │   │   ├── admin_shell.dart        # Shell with side navigation rail
│   │   │   └── admin_sidebar.dart
│   │   ├── dashboard/
│   │   │   └── admin_dashboard_screen.dart
│   │   ├── staff/
│   │   │   ├── staff_list_screen.dart
│   │   │   └── add_edit_staff_screen.dart
│   │   ├── doctors/
│   │   │   ├── doctor_list_screen.dart
│   │   │   ├── add_edit_doctor_screen.dart
│   │   │   └── doctor_availability_screen.dart
│   │   ├── patients/
│   │   │   ├── patient_list_screen.dart
│   │   │   └── patient_detail_screen.dart
│   │   ├── operations/
│   │   │   ├── operation_list_screen.dart
│   │   │   ├── create_operation_screen.dart
│   │   │   ├── assign_team_screen.dart
│   │   │   └── record_outcome_screen.dart
│   │   ├── reports/
│   │   │   ├── analytics_dashboard_screen.dart
│   │   │   ├── doctor_performance_screen.dart
│   │   │   └── patient_recovery_screen.dart
│   │   └── roles/
│   │       └── role_permissions_screen.dart
│   ├── doctor_mobile/                  # Mobile layouts for Doctors
│   │   ├── layouts/
│   │   │   └── doctor_bottom_nav.dart
│   │   ├── dashboard/
│   │   │   └── doctor_dashboard_screen.dart
│   │   ├── patients/
│   │   │   ├── assigned_patients_screen.dart
│   │   │   └── patient_detail_screen.dart
│   │   ├── appointments/
│   │   │   └── appointment_screen.dart
│   │   ├── prescriptions/
│   │   │   └── prescription_screen.dart
│   │   └── profile/
│   │       └── doctor_profile_screen.dart
│   ├── patient_mobile/                 # Mobile layouts for Patients
│   │   ├── layouts/
│   │   │   └── patient_bottom_nav.dart
│   │   ├── dashboard/
│   │   │   └── patient_dashboard_screen.dart
│   │   ├── status/
│   │   │   └── operation_status_screen.dart  # Real-time OT tracking
│   │   ├── medications/
│   │   │   └── medication_schedule_screen.dart
│   │   ├── reports/
│   │   │   └── download_report_screen.dart
│   │   └── profile/
│   │       └── patient_profile_screen.dart
│   ├── chat/                           # Shared chat UI (Doctor + Patient)
│   │   ├── chat_list_screen.dart
│   │   └── chat_room_screen.dart
│   └── notifications/
│       └── notification_center_screen.dart
│
├── shared_widgets/                     # Reusable components (Web + Mobile)
│   ├── buttons/
│   │   ├── primary_button.dart         # Main CTA button with loading state
│   │   ├── secondary_button.dart
│   │   ├── icon_button_widget.dart
│   │   └── emergency_button.dart       # Red pulsing emergency alert button
│   ├── inputs/
│   │   ├── app_text_field.dart         # Custom styled TextField
│   │   ├── app_password_field.dart     # Password field with toggle visibility
│   │   ├── app_dropdown.dart
│   │   └── app_date_picker.dart
│   ├── cards/
│   │   ├── info_card.dart
│   │   ├── patient_card.dart
│   │   ├── doctor_card.dart
│   │   ├── operation_card.dart
│   │   └── stat_card.dart             # Dashboard KPI stat card
│   ├── chips/
│   │   └── status_chip.dart            # OT Status pipeline chip (6 states)
│   ├── loaders/
│   │   ├── shimmer_loader.dart         # Skeleton loading animation
│   │   └── full_screen_loader.dart
│   ├── dialogs/
│   │   ├── confirm_dialog.dart
│   │   └── error_dialog.dart
│   ├── charts/
│   │   ├── bar_chart_widget.dart       # For analytics (fl_chart package)
│   │   └── pie_chart_widget.dart
│   └── misc/
│       ├── app_logo.dart
│       ├── empty_state_widget.dart     # "No data found" illustration
│       └── section_header.dart
│
├── routes/
│   ├── app_routes.dart                 # Route name constants
│   └── app_pages.dart                  # GetX page definitions (GetPage list)
│
├── bindings/                           # GetX dependency injection
│   ├── auth_binding.dart
│   ├── admin_binding.dart
│   ├── doctor_binding.dart
│   └── patient_binding.dart
│
└── main.dart                           # App entry point + GetMaterialApp setup
```

---

## 3. GetX Layer Responsibilities {#getx-layers}

### 3.1 Controllers (ViewModels)

```dart
// ✅ CORRECT — Controller structure
class AuthController extends GetxController {
  // 1. Inject dependency via constructor
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  // 2. Observable state variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // 3. Business logic methods
  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    final result = await _authRepository.signIn(email, password);
    result.fold(
      (failure) => _handleFailure(failure),
      (user) => _handleSuccess(user),
    );
    isLoading.value = false;
  }

  // 4. Private helper methods
  void _handleFailure(Failure failure) {
    errorMessage.value = failure.message;
    SnackbarHelper.showError(failure.message);
  }

  void _handleSuccess(UserModel user) {
    currentUser.value = user;
    _navigateByRole(user.role);
  }

  // 5. Role-based navigation (GetX handles routing — no BuildContext)
  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.admin:       Get.offAllNamed(AppRoutes.adminDashboard);
      case UserRole.doctor:      Get.offAllNamed(AppRoutes.doctorDashboard);
      case UserRole.patient:     Get.offAllNamed(AppRoutes.patientDashboard);
    }
  }
}
```

### 3.2 Views (Screens)

```dart
// ✅ CORRECT — View structure
class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {  // Only wrap the part that changes
        if (controller.isLoading.value) return const FullScreenLoader();
        return _buildLoginForm();
      }),
    );
  }

  Widget _buildLoginForm() { /* UI only */ }
}
```

### 3.3 Bindings (Dependency Injection)

```dart
// Bindings lazy-inject controllers when a route is pushed
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find()),
    );
  }
}
```

### 3.4 Routes

```dart
// app_routes.dart
abstract class AppRoutes {
  static const splash          = '/';
  static const onboarding      = '/onboarding';
  static const login           = '/login';
  static const forgotPassword  = '/forgot-password';
  static const adminDashboard  = '/admin/dashboard';
  static const doctorDashboard = '/doctor/dashboard';
  static const patientDashboard= '/patient/dashboard';
  // ... all routes
}

// app_pages.dart — registered in GetMaterialApp
final List<GetPage> appPages = [
  GetPage(name: AppRoutes.login,    page: () => LoginScreen(),    binding: AuthBinding()),
  GetPage(name: AppRoutes.admin,    page: () => AdminShell(),     binding: AdminBinding()),
  // ...
];
```

---

## 4. Naming Conventions {#naming-conventions}

| Item                   | Convention          | Example                              |
|------------------------|---------------------|--------------------------------------|
| Files                  | `snake_case`        | `doctor_management_controller.dart`  |
| Classes                | `PascalCase`        | `DoctorManagementController`         |
| Variables & Methods    | `camelCase`         | `isLoading`, `fetchPatients()`       |
| Constants              | `camelCase`         | `AppColors.primary`                  |
| GetX Observables       | suffix `.obs`       | `final RxBool isLoading = false.obs` |
| Repository interfaces  | `IRepository`       | `IAuthRepository`                    |
| Repository impl        | `RepositoryImpl`    | `AuthRepositoryImpl`                 |
| Firestore Collections  | `SCREAMING_SNAKE`   | `USERS`, `OPERATIONS`, `CHAT_ROOMS`  |
| Route constants        | `camelCase string`  | `AppRoutes.adminDashboard`           |
| Model `fromMap`        | Always implement    | `UserModel.fromMap(Map<String, dynamic> map)` |
| Model `toMap`          | Always implement    | `userModel.toMap()`                  |

---

## 5. UI/UX Standards {#uiux-standards}

### 5.1 Typography — Inter Font

```dart
// pubspec.yaml dependency
// google_fonts: ^6.1.0

// Usage in AppTextStyles
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static TextStyle displayLarge   = GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle displayMedium  = GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle headlineLarge  = GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle headlineMedium = GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle titleLarge     = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle bodyLarge      = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static TextStyle bodyMedium     = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle bodySmall      = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary);
  static TextStyle labelLarge     = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static TextStyle labelMedium    = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
}
```

### 5.2 Spacing System

```dart
abstract class AppDimensions {
  // Padding
  static const double paddingXS  = 4.0;
  static const double paddingS   = 8.0;
  static const double paddingM   = 16.0;
  static const double paddingL   = 24.0;
  static const double paddingXL  = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusS    = 8.0;
  static const double radiusM    = 12.0;
  static const double radiusL    = 16.0;
  static const double radiusXL   = 24.0;
  static const double radiusFull = 999.0;

  // Elevation (shadow depth)
  static const double elevationLow  = 2.0;
  static const double elevationMid  = 8.0;
  static const double elevationHigh = 16.0;

  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}
```

### 5.3 Splash & Onboarding

- **Splash Screen:**
  - Full dark background (`#080A0E`)
  - App logo fades in with `FadeTransition` (500ms) then scales up with `ScaleTransition` (400ms)
  - Tagline text slides up with `SlideTransition` (300ms, delay 600ms)
  - A subtle particle/dot animation or gradient shimmer in the background
  - After 2.5s → checks auth state → routes to Onboarding (first launch) or Dashboard (returning user)
  - Uses `GetStorage` to detect first launch

- **Onboarding Screen:**
  - 3 pages with `PageView` and smooth horizontal slide transitions
  - Each page: full-bleed animated illustration, large heading, subtitle
  - Page indicator dots with animated active state (width transition)
  - "Skip" button top-right, "Next"/"Get Started" button bottom
  - Scroll animation: content fades in as user scrolls between pages
  - Stores `isFirstLaunch = false` in `GetStorage` on "Get Started"

---

## 6. Scroll & Animation Guidelines {#animations}

> **Rule:** Every screen MUST have at least one meaningful animation. Animations must feel purposeful, not decorative.

### 6.1 Standard Animation Durations

```dart
abstract class AppAnimations {
  static const Duration fast   = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow   = Duration(milliseconds: 500);
  static const Duration xSlow  = Duration(milliseconds: 800);

  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve  = Curves.elasticOut;
  static const Curve snapCurve    = Curves.fastLinearToSlowEaseIn;
}
```

### 6.2 Scroll-Triggered Animations

Use `AnimationController` + `ScrollController` or the `animate_do` package for entry animations as items scroll into view.

```dart
// Pattern: Staggered list items — each item fades + slides up on entry
// Package: animate_do (FadeInUp, SlideInLeft, etc.)

ListView.builder(
  itemBuilder: (context, index) {
    return FadeInUp(
      duration: AppAnimations.normal,
      delay: Duration(milliseconds: index * 80), // stagger
      child: PatientCard(patient: patients[index]),
    );
  },
)
```

### 6.3 Mandatory Animations by Screen

| Screen / Component           | Animation Type                                     |
|------------------------------|----------------------------------------------------|
| **Splash Screen**            | Logo fade-in + scale-up; tagline slide-up          |
| **Onboarding**               | PageView slide; dot indicator width transition     |
| **Login Screen**             | Form fields slide-up staggered (one by one)        |
| **Dashboard (any role)**     | Stat cards count-up animation on mount             |
| **List Screens**             | `FadeInUp` stagger on each list item               |
| **OT Status Pipeline**       | Pulsing glow on "In Surgery" status chip           |
| **Operation Record Created** | Success checkmark lottie/custom animation          |
| **Bottom Nav Bar**           | Icon scale on select; active indicator slide       |
| **Sidebar (Web)**            | Slide-in on first load; item highlight slide       |
| **Loading / Skeleton**       | Shimmer sweep animation on skeleton cards          |
| **Snackbar / Toast**         | Slide-in from bottom, auto-dismiss with fade-out   |
| **Emergency Button**         | Continuous pulsing ring animation                  |
| **Charts (Analytics)**       | Bars grow from 0 to value on mount (`fl_chart`)    |
| **PDF Download**             | Progress indicator with checkmark on completion    |
| **Chat Messages**            | New message slide-up from bottom                   |

### 6.4 Glassmorphism Pattern

```dart
// For premium glass cards (Onboarding, Dashboard headers)
ClipRRect(
  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: /* content */,
    ),
  ),
)
```

---

## 7. Responsive Design (Mobile + Web) {#responsive-design}

### 7.1 Layout Strategy

```dart
// responsive_helper.dart
class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppDimensions.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.mobileBreakpoint &&
      MediaQuery.of(context).size.width < AppDimensions.desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.desktopBreakpoint;
}

// Usage in main.dart — routing by platform
// Admin/Receptionist → admin_web/ layouts (wide sidebar)
// Doctor/Patient     → doctor_mobile/ or patient_mobile/ layouts (bottom nav)
```

### 7.2 Responsive Routing Rule

```dart
// In app_pages.dart or main routing logic:
// Web platform (kIsWeb == true) AND role is Admin/Receptionist → AdminShell (sidebar)
// Mobile platform OR role is Doctor/Patient → respective bottom nav shell

Widget get initialPage {
  if (kIsWeb && userRole == UserRole.admin) return AdminShell();
  if (userRole == UserRole.doctor) return DoctorBottomNav();
  return PatientBottomNav();
}
```

### 7.3 Grid System

```dart
// On web dashboards: 12-column grid
// Use LayoutBuilder + GridView.builder with responsive column count:
int crossAxisCount(BuildContext context) {
  if (ResponsiveHelper.isDesktop(context)) return 4;
  if (ResponsiveHelper.isTablet(context)) return 2;
  return 1;
}
```

---

## 8. Firebase Integration Standards {#firebase}

### 8.1 Firestore Collection Architecture

```
Firestore Database
├── users/                       # All user accounts
│   └── {uid}/
│       ├── role: "admin"|"doctor"|"patient"|"staff"
│       ├── status: "active"|"deactivated"|"suspended"
│       └── profileData: {...}
│
├── doctors/                     # Doctor profiles & specializations
│   └── {doctorId}/
│       ├── profile: {...}
│       ├── availability: [{day, startTime, endTime}]
│       └── specializations: [...]
│
├── patients/                    # Patient profiles
│   └── {patientId}/
│       ├── profile: {...}
│       ├── emergencyContact: {...}
│       └── medicalHistory: {...}
│
├── operations/                  # OT Records
│   └── {operationId}/
│       ├── patientId, doctorId, status
│       ├── surgicalTeam: {primaryDoctor, anaesthesiologist, nurses}
│       ├── outcome: {...}
│       └── auditLog: [{timestamp, changedBy, changes}]
│
├── appointments/                # Scheduled appointments
├── prescriptions/               # Medication prescriptions
├── chat_rooms/                  # Real-time chat
│   └── {roomId}/
│       └── messages/ (sub-collection, ordered by timestamp)
│
├── notifications/               # Notification records
└── reports/                     # Uploaded medical documents (Cloudinary URLs)
```

### 8.2 Firebase Rules Principle (RBAC)

```
// Enforce role-based access:
// - Patients can only read/write their own documents
// - Doctors can read their assigned patients only
// - Admins have full read/write access
// - All writes are authenticated
```

### 8.3 Firebase Coding Pattern

```dart
// Repository implementation pattern
class OperationRepositoryImpl implements IOperationRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'operations';

  @override
  Stream<List<OperationModel>> watchOperations() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => OperationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<Either<Failure, void>> createOperation(OperationModel op) async {
    try {
      await _firestore.collection(_collection).add(op.toMap());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Operation failed'));
    }
  }
}
```

### 8.4 Firebase Auth Standards

- Use `FirebaseAuth.instance.authStateChanges()` stream for persistent session detection
- Implement `onAuthStateChanged` in `AuthController` `onInit()` to redirect appropriately
- Password reset via Firebase's built-in `sendPasswordResetEmail()`
- First login detection → force password change flow (SRS-96)

### 8.5 File Storage (Cloudinary)

- Use `cloudinary_public` package for uploads from Flutter
- Upload endpoint for medical reports: pre-signed URLs or direct unsigned upload to a restricted Cloudinary folder
- Store returned `secure_url` in Firestore under `reports/{patientId}/documents`
- Validate file type (PDF, JPG) and size (≤ 5MB) **client-side BEFORE upload**

---

## 9. Error Handling Strategy {#error-handling}

### 9.1 Failure Hierarchy

```dart
// core/error/failures.dart
abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class FirestoreFailure extends Failure {
  const FirestoreFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message});
}
```

### 9.2 Result Type (Either Pattern)

Use the `dartz` package for functional error handling:

```dart
Future<Either<Failure, UserModel>> signIn(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // fetch user data...
    return Right(userModel);
  } on FirebaseAuthException catch (e) {
    return Left(AuthFailure(message: _mapAuthError(e.code)));
  }
}

String _mapAuthError(String code) {
  return switch (code) {
    'user-not-found'  => 'No account found for this email.',
    'wrong-password'  => 'Invalid Email or Password.',
    'user-disabled'   => 'Your Account Has Been Deactivated. Please Contact Admin.',
    'network-request-failed' => 'No internet connection.',
    _ => 'An unexpected error occurred.',
  };
}
```

### 9.3 GetX Snackbar Wrapper

```dart
// core/utils/snackbar_helper.dart
abstract class SnackbarHelper {
  static void showSuccess(String message) {
    Get.snackbar('Success', message,
      backgroundColor: AppColors.successContainer,
      colorText: AppColors.successLight,
      icon: const Icon(Icons.check_circle, color: AppColors.success),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showError(String message) {
    Get.snackbar('Error', message,
      backgroundColor: AppColors.errorContainer,
      colorText: AppColors.errorLight,
      icon: const Icon(Icons.error_outline, color: AppColors.error),
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
```

---

## 10. Code Quality Standards {#code-quality}

### 10.1 General Rules

- **No business logic in Views.** Views contain only widget composition and UI layout.
- **No `BuildContext` in Controllers.** Use GetX navigation (`Get.toNamed`, `Get.offAllNamed`).
- **No direct Firebase calls in Views.** All Firebase operations go through Repositories.
- **All models must implement `fromMap()` and `toMap()`.** No ad-hoc `map['field']` scattered in controllers.
- **All user-facing strings must be in `app_strings.dart`.** No hardcoded UI text.
- **Every async operation in a controller must set `isLoading = true/false`.**

### 10.2 Recommended Packages

```yaml
dependencies:
  get: ^4.6.6                     # GetX — state, routing, DI
  get_storage: ^2.1.1             # Local persistent storage (session)
  firebase_core: ^3.x.x           # Firebase core
  firebase_auth: ^5.x.x           # Authentication
  cloud_firestore: ^5.x.x         # Database
  firebase_storage: ^12.x.x       # File storage
  firebase_messaging: ^15.x.x     # FCM push notifications
  cloudinary_public: ^0.21.0      # Cloudinary file upload
  dartz: ^0.10.1                  # Either type for error handling
  google_fonts: ^6.1.0            # Inter, Roboto fonts
  fl_chart: ^0.69.0               # Bar + Pie charts for analytics
  animate_do: ^3.3.4              # Scroll & entry animations
  shimmer: ^3.0.0                 # Skeleton loading shimmer
  pdf: ^3.11.1                    # PDF generation for operation reports
  printing: ^5.13.1               # Print/download PDFs
  image_picker: ^1.1.2            # Camera & gallery access
  permission_handler: ^11.3.1     # Platform permissions
  connectivity_plus: ^6.0.5       # Network status
  intl: ^0.19.0                   # Date/time formatting
  cached_network_image: ^3.3.1    # Cached image loading

dev_dependencies:
  flutter_lints: ^4.0.0
  build_runner: ^2.4.9
```

### 10.3 Linting Rules (`analysis_options.yaml`)

Key rules to enforce:
- `always_declare_return_types`
- `prefer_final_fields`
- `avoid_print` (use `debugPrint` during dev, remove for prod)
- `unnecessary_null_checks`
- `prefer_const_constructors`

### 10.4 Security

- Never commit `google-services.json` or `firebase_options.dart` with real credentials to public repos
- Use `.gitignore` to exclude sensitive files
- Store Cloudinary API keys in a `.env` file or Firebase Remote Config
- Implement auto-logout after inactivity (SRS-NonFunctional): use a `GetX` timer in the shell controller

---

*Document Version: 1.0 | OT Procedures & Tracking App | Architecture & Coding Guidelines*
