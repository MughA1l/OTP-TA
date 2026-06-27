# 🗺️ OT Procedures & Tracking App — Development Roadmap

> **Version:** 1.2 | **Date:** June 2026 (Updated — 100% Serverless Flutter)  
> **Architecture:** Flutter + MVVM + GetX | **Backend:** Firebase (Auth + Firestore) + Cloudinary  
> **Symbols:** `[F]` = Frontend Task | `[B]` = Backend Task

> [!IMPORTANT]
> **Serverless Stack Decision Log:**
> - ❌ `Firebase Storage` → ✅ **Cloudinary** (free tier: 25GB storage)
> - ❌ `Node.js Backend` → ✅ **Removed entirely**. All logic runs in Flutter.
> - ❌ `Backend Emails` → ✅ **EmailJS** called directly via Flutter `http`.
> - ❌ `Cron Jobs (Reminders)` → ✅ **flutter_local_notifications** used directly on device.
> - ❌ `Server FCM` → ✅ **googleapis_auth** embedded in Flutter to call FCM V1 REST API directly.

---

## 📊 Roadmap Overview

```
Phase 1 → Project Foundation & Setup
Phase 2 → Splash Screen & Onboarding
Phase 3 → Security Management (Auth)
Phase 4 → Profile Management
Phase 5 → Doctor Management
Phase 6 → Patient Portal Management
Phase 7 → Operation & Clinical Reporting  ← CORE MODULE
Phase 8 → Medication Management
Phase 9 → Communication Management (Real-time Chat)
Phase 10 → Notifications Management
Phase 11 → Reports & Analytics Management
Phase 12 → Final Polish, Testing & Deployment
```

---

## ✅ Phase 1: Project Foundation & Setup

> **Goal:** Establish the project skeleton, Firebase, and folder structure before writing any feature code.

### 1.1 Firebase Backend Setup

> **Free services only — No Blaze plan required.**

#### 🔥 Firebase Console
- `[B]` Create a new Firebase project in Firebase Console (`otpta-app`)
- `[B]` Enable **Firebase Authentication** → Email/Password provider (✅ Free)
- `[B]` Enable **Cloud Firestore** database → start in test mode, lock rules before deploy (✅ Free tier: 1 GB storage, 50K reads/day, 20K writes/day)
- `[B]` ~~Firebase Storage~~ → **NOT used** — Cloudinary handles all file storage (see below)
- `[B]` Enable **Firebase Cloud Messaging (FCM)** → for push notifications (✅ Completely free, no limits)
  - In Firebase Console → Project Settings → Cloud Messaging → enable **Cloud Messaging API (V1)**
  - Download the **Service Account JSON** (needed by Flutter for `googleapis_auth` FCM HTTP v1)
- `[B]` ~~Firebase Cloud Functions~~ → **NOT used** — handled completely inside Flutter.
- `[B]` Download `google-services.json` (Android) — add to `android/app/`
- `[B]` Run `flutterfire configure` to generate `firebase_options.dart`
- `[B]` Define initial Firestore Security Rules (deny all by default; unlock by role in later phases)
- `[B]` Create Firestore Composite Indexes: operations (by patientId + date), appointments (by doctorId + date)

#### ☁️ Cloudinary Setup (Free — replaces Firebase Storage)
- `[B]` Create a free Cloudinary account at [cloudinary.com](https://cloudinary.com) (25 GB storage + 25 GB bandwidth/month free)
- `[B]` Create two **Upload Presets** in Cloudinary Console:
  - `otpta_reports` — for PDF/JPG medical reports (restrict to `pdf`, `jpg`, max 5MB)
  - `otpta_profiles` — for user profile pictures (restrict to `jpg`, `png`, max 2MB)
- `[B]` Note down: `Cloud Name`, `Upload Preset names` — store in Flutter `.env` or `app_config.dart`
- `[B]` Set Cloudinary folder structure: `otpta/reports/{patientId}/`, `otpta/profiles/{uid}/`

#### 📱 Serverless FCM & Local Notifications (Replaces Render/Cron)
- `[F]` Set up `flutter_local_notifications` in Flutter for all appointment reminders (no cron jobs needed).
- `[F]` Embed Service Account JSON inside Flutter (or in an `.env` file) to use with `googleapis_auth`.
- `[F]` Create `fcm_client_service.dart` to make direct REST API POST requests to FCM v1.

#### 📧 EmailJS Setup (Free — replaces Cloud Functions email trigger)
- `[B]` Create a free [EmailJS](https://emailjs.com) account (200 emails/month free).
- `[B]` Note down: `Service ID`, `Template ID`, and `Public Key`.
- `[F]` Create `email_service.dart` in Flutter to send credentials directly to patients via HTTP POST.

### 1.2 Flutter Project Setup

- `[F]` Initialize project: `flutter create otp_ta_app --platforms=android,web`
- `[F]` Set up the complete folder structure as defined in `guidelines.md`
- `[F]` Add all required packages to `pubspec.yaml`:
  ```yaml
  # Core
  get: ^4.6.6
  get_storage: ^2.1.1
  dartz: ^0.10.1
  # Firebase (Auth + Firestore + FCM only — NO firebase_storage)
  firebase_core: ^3.x.x
  firebase_auth: ^5.x.x
  cloud_firestore: ^5.x.x
  firebase_messaging: ^15.x.x
  # Cloudinary (replaces Firebase Storage)
  cloudinary_public: ^0.21.0
  # UI & Animations
  google_fonts: ^6.1.0
  animate_do: ^3.3.4
  shimmer: ^3.0.0
  fl_chart: ^0.69.0
  # Utilities
  http: ^1.2.1          # for calling Render.com backend APIs
  image_picker: ^1.1.2
  permission_handler: ^11.3.1
  connectivity_plus: ^6.0.5
  pdf: ^3.11.1
  printing: ^5.13.1
  intl: ^0.19.0
  cached_network_image: ^3.3.1
  ```
- `[F]` Create `app_colors.dart` using all tokens from `colors.md`
- `[F]` Create `app_text_styles.dart` (Inter font via `google_fonts`)
- `[F]` Create `app_dimensions.dart` (spacing, radius, breakpoints)
- `[F]` Create `app_strings.dart` (all user-facing strings)
- `[F]` Create `app_assets.dart` (asset path references)
- `[F]` Create `firebase_constants.dart` (Firestore collection name constants)
- `[F]` Create `app_config.dart` — stores Cloudinary cloud name, upload presets, and Render.com base URL
- `[F]` Create `app_theme.dart` (dark `ThemeData` wired to `AppColors`)
- `[F]` Create `app_routes.dart` + `app_pages.dart` (empty routes scaffolded)
- `[F]` Create `failures.dart` + `exceptions.dart` (error hierarchy)
- `[F]` Create `snackbar_helper.dart` (GetX success/error/warning snackbar wrappers)
- `[F]` Configure `main.dart` with `GetMaterialApp`, dark theme, and initial route
- `[F]` Create `responsive_helper.dart` (mobile/tablet/desktop breakpoint helpers)
- `[F]` Initialize `GetStorage` for local session persistence
- `[F]` Set up `.gitignore` to exclude `firebase_options.dart`, `.env`, `service-account.json`, and sensitive files

### 1.3 Serverless Flutter Services Setup

> All backend functionalities (push notifications, emails, scheduled cron jobs) have been moved directly into the Flutter app to maintain a 100% free, zero-maintenance architecture.

- `[F]` Create `lib/core/services/fcm_client_service.dart`:
  - Uses `googleapis_auth` to generate OAuth2 tokens from the Service Account.
  - Sends direct HTTP POST requests to FCM v1 for Chat and Status updates.
- `[F]` Create `lib/core/services/email_service.dart`:
  - Uses `http` to post to EmailJS API.
  - Sends temporary passwords to patients when an operation is scheduled.
- `[F]` Create `lib/core/services/local_notification_service.dart`:
  - Uses `flutter_local_notifications` and `timezone` to schedule 24h and 2h reminders locally on the patient's device without a server.

---

## ✅ Phase 2: Foundational UI — Splash & Onboarding

> **Goal:** Create a stunning first impression and guide first-time users.

### ✅ 2.1 Splash Screen

- `[x] [F]` Create `splash_screen.dart` with full dark background (`AppColors.background`)
- `[x] [F]` Implement app logo with `FadeTransition` (500ms) + `ScaleTransition` (400ms, after fade)
- `[x] [F]` Add tagline text with `SlideTransition` upward (300ms, delay 600ms)
- `[x] [F]` Add subtle animated background gradient or particle shimmer effect
- `[x] [F]` Create `SplashController` with `onInit()` logic:
  - Check `GetStorage` for `isFirstLaunch` → route to Onboarding if `true`
  - Check `FirebaseAuth.instance.currentUser` → route to correct Dashboard if logged in
  - Otherwise → route to Login screen
- `[x] [F]` Register `SplashController` in `SplashBinding`

### ✅ 2.2 Onboarding Screen (First-Time Users Only)

- `[x] [B]` No backend dependency — purely local (`GetStorage` flag)
- `[x] [F]` Create `onboarding_screen.dart` with `PageView` (3 pages)
- `[x] [F]` Design 3 onboarding pages:
  - **Page 1:** "Real-Time OT Tracking" — Surgical precision illustration
  - **Page 2:** "Automated Patient Onboarding" — Credential generation illustration
  - **Page 3:** "Stay Connected with Your Care Team" — Chat & medication illustration
- `[x] [F]` Add animated page indicator dots (active dot width expands smoothly)
- `[x] [F]` Add staggered `FadeInUp` animation on each page's text content
- `[x] [F]` Add "Skip" button (top-right) + "Next" / "Get Started" (bottom CTA)
- `[x] [F]` On "Get Started": set `GetStorage().write('isFirstLaunch', false)` → navigate to Login

---

## ✅ Phase 3: Security Management (Authentication)

### ✅ 3.1 Backend Setup

- `[x] [B]` Confirm Firebase Auth Email/Password enabled
- `[x] [B]` Create `users` Firestore collection schema: `{uid, email, role, status, createdAt, fcmToken, isFirstLogin, tokenExpiry}`
- `[x] [B]` Write Firestore Security Rule: only authenticated users can read their own doc
- `[x] [B]` (Cloud Function) Write `onUserCreated` Cloud Function trigger: sets default user doc with role

### ✅ 3.2 Auth Repository & Controller

- `[x] [F]` Create `IAuthRepository` interface with method signatures
- `[x] [B]`/`[F]` Implement `AuthRepositoryImpl`:
  - `signIn(email, password)` → Firebase Auth + fetch user role from Firestore
  - `signOut()` → Firebase Auth sign out + clear GetStorage session
  - `sendPasswordResetEmail(email)` → Firebase Auth reset email
  - `updatePassword(old, new)` → re-authenticate + update
  - `fetchCurrentUserData()` → Firestore `users/{uid}` snapshot
- `[x] [F]` Create `AuthController` with observables: `isLoading`, `errorMessage`, `currentUser`
- `[x] [F]` Implement role-based routing in `AuthController` (`_navigateByRole()`)
- `[x] [F]` Register binding in `AuthBinding`

### ✅ 3.3 Login Screen (Shared — Web + Mobile)

- `[x] [F]` Create `login_screen.dart` with dark glassmorphism card design
- `[x] [F]` App logo + animated tagline at top
- `[x] [F]` Email `AppTextField` + Password `AppPasswordField` (toggle visibility)
- `[x] [F]` "Sign In" `PrimaryButton` — shows loading spinner via `Obx()`
- `[x] [F]` "Forgot Password?" `TextButton` link
- `[x] [F]` Implement inline form validation (`validators.dart`)
- `[x] [F]` Add staggered `FadeInUp` animation: logo → email → password → button (each +100ms delay)
- `[x] [F]` Display GetX error snackbar on failure (SRS-4)
- `[x] [F]` Handle "Account Deactivated" state with distinct error message (SRS-32)

### ✅ 3.4 Forgot Password Screen

- `[x] [F]` Create `forgot_password_screen.dart`
- `[x] [F]` Email input field + "Send Reset Link" button
- `[x] [F]` On success: show informational snackbar + navigate back to Login (SRS-13)
- `[x] [F]` On failure (email not found): show error snackbar (SRS-10)

### ✅ 3.5 Change Password Screen (Settings)

- `[x] [F]` Create `change_password_screen.dart` (accessible from profile settings for all roles)
- `[x] [F]` Three fields: Old Password, New Password, Confirm New Password
- `[x] [F]` Validate security policy client-side before calling repository (SRS-15, SRS-16)
- `[x] [F]` On success: show "Password Updated Successfully" snackbar (SRS-16)
- `[x] [B]`/`[x] [F]` Re-authenticate user with old password before updating (security requirement)

---

## ✅ Phase 4: Profile Management

### ✅ 4.1 Backend Setup

- `[x] [B]` Create `staff` Firestore collection schema: `{staffId, name, email, phone, role, shiftAllocations, accessPermissions, createdAt}`
- `[x] [B]` Create `patients` Firestore collection schema: `{patientId, name, phone, address, medicalHistory, emergencyContact, profilePicUrl, createdAt}`
- `[x] [B]` Write Firestore Security Rule: patients can only update their own basic info fields

### ✅ 4.2 Staff Profile (Admin Web)

- `[x] [B]`/`[x] [F]` Implement `StaffRepositoryImpl`: `createStaff()`, `updateStaff()`, `fetchAllStaff()`
- `[x] [F]` Create `StaffController` with: `staffList`, `isLoading`, `createStaff()`, `updateStaff()`
- `[x] [F]` Build `staff_list_screen.dart` (Web):
  - DataTable or animated list with search/filter bar
  - `FadeInUp` stagger on list items
- `[x] [F]` Build `add_edit_staff_screen.dart` (Web):
  - Form: Name, Email, Phone, Job Role (Dropdown), Shift Allocation
  - Inline validation; "Save" button with loading state
  - Success snackbar "Staff Profile Created Successfully" (SRS-21)
  - Role-based permission auto-assignment display

### ✅ 4.3 Patient Profile (Admin/Receptionist Web + Patient Mobile)

- `[x] [B]`/`[x] [F]` Implement `PatientRepositoryImpl`: `createPatient()`, `updatePatient()`, `fetchPatient(id)`
- `[x] [F]` Create `PatientManagementController`
- `[x] [F]` Build `patient_list_screen.dart` (Web): searchable, filterable list with `PatientCard`
- `[x] [F]` Build registration form (Web): Personal data, Medical History, Emergency Contact fields
  - Unique Patient ID auto-generated and displayed on success (SRS-25)
  - "Patient Profile Created Successfully" snackbar (SRS-27)
- `[x] [F]` Build `patient_profile_screen.dart` (Mobile — Patient):
  - View: Name, Phone, Address, Profile Picture
  - Edit: Only phone, address, profile picture (restricted — SRS-28)
  - Profile picture upload via `image_picker` + Cloudinary

### ✅ 4.4 Manage Account Status

- `[x] [F]` Add account status toggle (Active / Deactivated / Suspended) to user detail screens (Web Admin)
- `[x] [B]`/`[x] [F]` `updateAccountStatus(uid, status)` method in repository
- `[x] [F]` Login flow checks `status` field before granting session (SRS-31, SRS-32)

### ✅ 4.5 Role Permissions (Admin Web)

- `[x] [B]` Create `role_permissions` Firestore collection: `{role, allowedModules: []}`
- `[x] [B]`/`[x] [F]` Implement `RolePermissionRepositoryImpl`
- `[x] [F]` Build `role_permissions_screen.dart` (Web):
  - List of roles; tap to open checklist of module permissions
  - Toggle switches for each module; "Save Permissions" button
  - Success snackbar "Permissions Updated Successfully" (SRS-82 approach)

---

## Phase 5: Doctor Management

### ✅ 5.1 Backend Setup

- `[x] [B]` Create `doctors` Firestore collection schema: `{doctorId, name, email, phone, qualifications, specializations[], pmdc, experience, availabilitySlots[], createdAt}`
- `[x] [B]` Create `appointments` collection schema: `{appointmentId, doctorId, patientId, dateTime, status, createdAt}`
- `[x] [B]` Firestore Rule: Doctors can only edit their own profile; Admins have full access

### 5.2 Doctor Repository & Controller

- `[B]`/`[F]` Implement `DoctorRepositoryImpl`: CRUD + `watchDoctorList()`, `updateAvailability()`
- `[F]` Create `DoctorManagementController` (Admin) + `DoctorDashboardController` (Doctor)

### 5.3 Add/Edit Doctor Profile (Admin Web)

- `[F]` Build `add_edit_doctor_screen.dart` (Web):
  - Fields: Name, Email, Phone, PMDC Number, Qualifications, Specializations (multi-chip input)
  - Validation + "Doctor Profile Added Successfully" snackbar (SRS-35)

### 5.4 Doctor Availability & Duty Timings

- `[B]`/`[F]` `updateAvailability(doctorId, slots)` with conflict detection logic
- `[F]` Build `doctor_availability_screen.dart`:
  - Weekly calendar grid showing shift slots
  - "Mark as On Leave" date picker
  - Conflict error if overlapping shifts detected (SRS-41)

### 5.5 Appointment Management (Admin/Receptionist Web)

- `[B]`/`[F]` Implement `AppointmentRepositoryImpl`: `bookAppointment()`, `reschedule()`, `cancel()`
- `[F]` Create `AppointmentController`
- `[F]` Build appointment booking form: Doctor selector (checks real-time availability) + date/time picker
- `[F]` Status chip: Pending / Confirmed / Cancelled / Completed (SRS-43)
- `[F]` Cancellation immediately frees time slot (SRS-44)

### 5.6 Assigned Patients (Doctor Mobile)

- `[F]` Build `assigned_patients_screen.dart` (Mobile):
  - Today's patient list with `FadeInUp` stagger
  - Filter by date, search by name (SRS-47)
  - Each card: Patient ID, Name, Appointment Time, Status chip
- `[F]` Build `patient_detail_screen.dart` (Doctor Mobile): full patient profile view

### 5.7 Doctor Workload Tracking (Admin Web Dashboard)

- `[B]` Firestore query: count operations per doctor per day
- `[F]` Stat cards on Admin Dashboard: appointments count per doctor
- `[F]` Visual flag/warning badge if > 25 patients/day (SRS-49) using `colorWarning`

---

## ✅ Phase 6: Patient Portal Management

### 6.1 Patient Dashboard (Mobile)

- `[F]` Build `patient_dashboard_screen.dart` (Mobile):
  - Glassmorphism header card: "Hello, [Patient Name]" + date
  - Stat cards: Upcoming Schedule, Current OT Status, Assigned Doctor
  - "No active schedules" empty state widget if no operations (SRS-51)
  - All cards animate in with staggered `FadeInUp` (SRS-52 — dynamic updates)
- `[B]`/`[F]` `PatientDashboardController` watches real-time Firestore streams

### 6.2 Real-Time OT Status Tracking

- `[F]` Build `operation_status_screen.dart` (Mobile):
  - Vertical stepper UI: Pre-Op → In Surgery → Recovery Room → Completed
  - **"In Surgery" step:** Animated pulsing teal glow (`colorSecondaryLight`) + live badge
  - Progress line animates between steps as status updates
  - Status labels use `StatusChip` widget from `shared_widgets/chips/`
  - Auto-refreshes via Firestore `snapshots()` stream (SRS-53, SRS-54)

### 6.3 View Assigned Doctor

- `[F]` Doctor card on patient dashboard:
  - Shows: Name, Photo, Specialty, PMDC Number, Experience
  - Hides: Personal mobile number (SRS-56)
  - "Chat" button → navigates to chat room

### 6.4 Download Operation Report

- `[B]` Report URL stored in Firestore (Cloudinary `secure_url`) — approved by doctor
- `[F]` "Download Report" button with download progress indicator
- `[F]` On success: "Report Downloaded Successfully" snackbar (SRS-59)
- `[F]` Use `pdf` + `printing` package to open/download report

### 6.5 Check-up History

- `[F]` Build `check_up_history_screen.dart` (Mobile — Patient):
  - Chronological list of past appointments (SRS-60)
  - Search by date range or doctor name (SRS-61)
  - Tap on record → detail view with doctor notes + prescriptions (SRS-62)
  - Infinite scroll pagination (SRS-80 pattern applied here too)

---

## ✅ Phase 7: Operation & Clinical Reporting ← CORE MODULE

> This is the heart of the app. All other modules connect to this.

### 7.1 Backend Setup

- `[B]` Create `operations` Firestore collection schema (full schema):
  ```
  {
    operationId, patientId, patientName, surgeryType, otRoom,
    scheduledDate, scheduledTime, status (Scheduled|PreOp|InSurgery|Recovery|Completed|Cancelled),
    surgicalTeam: { primaryDoctorId, anaesthesiologistId, nursingStaff: [] },
    outcome: { notes, complications, patientCondition, submittedAt, submittedBy },
    credentialsGenerated: bool,
    reportUrls: [],
    auditLog: [{ timestamp, changedBy, action, changes }],
    createdAt, updatedAt
  }
  ```
- `[B]`/`[F]` **Operation Status Notification (replaces Cloud Function):**
  - When `OperationController.updateOperationStatus()` successfully writes to Firestore,
  - It calls `POST /api/notify/single` on Render.com server with patient's FCM token + new status
  - Render.com server sends FCM HTTP v1 push to patient's device (SRS-100)
- `[B]`/`[F]` **Automated Patient Credentials (replaces Cloud Function, SRS-73, SRS-74):**
  - When `recordOutcome()` is called and operation is marked "Scheduled", Flutter controller calls
  - `POST /api/email/credentials` on Render.com server
  - Render.com uses **Resend** API to email temporary credentials to patient
  - Credentials link contains a deep-link with 24h expiry (SRS-95) managed via Firestore `tokenExpiry` field
- `[B]` Firestore Indexes: operations by status, by doctorId, by patientId, by date

### 7.2 Operation Repository & Controller

- `[B]`/`[F]` Implement `OperationRepositoryImpl`:
  - `createOperation()`, `assignSurgicalTeam()`, `updateSurgicalTeam()`
  - `updateOperationStatus(id, status)`, `recordOutcome(id, outcome)`
  - `watchPatientOperationStatus(patientId)` → real-time stream
  - `fetchOperationHistory(filters)` with pagination
  - `uploadMedicalReport(file, operationId)` → Cloudinary + Firestore
- `[F]` Create `OperationController`

### 7.3 Create Operation Record (Admin Web)

- `[F]` Build `create_operation_screen.dart` (Web):
  - Patient selector (searchable dropdown from patients collection)
  - Surgery Type input, OT Room selector, Date + Time pickers
  - "Create Record" `PrimaryButton`
  - On success: "Operation Record Created Successfully" snackbar (SRS-64)
  - Controller then auto-navigates to "Assign Team" step

### 7.4 Assign / Update Surgical Team (Admin Web)

- `[F]` Build `assign_team_screen.dart` (Web):
  - Primary Doctor selector (checks availability against `doctors/availability`)
  - Anaesthesiologist selector
  - Nursing staff multi-select
  - Real-time conflict validation — red error if unavailable (SRS-66)
  - "Assign Team" button → saves and sends notification to team members (SRS-69)
  - "Update Team" flow (SRS-67, SRS-68, SRS-70): shows audit log of who changed what

### 7.5 Record Operation Outcome (Doctor Mobile)

- `[F]` Build `record_outcome_screen.dart` (Doctor Mobile + Web):
  - Fields: Surgical Notes, Complications (if any), Patient Condition post-op
  - "Submit Outcome" button → updates operation status to "Completed" (SRS-72)
  - On submit → `OperationController` calls `POST /api/email/credentials` on Render.com server to trigger patient credential generation (SRS-73)

### 7.6 Upload Medical Reports (Doctor/Staff)

- `[F]` "Upload Report" button on operation detail screen
- `[F]` `image_picker` for camera/gallery, file picker for PDF
- `[F]` Client-side validation: type (PDF/JPG only), size (≤ 5MB) (SRS-76, SRS-77)
- `[F]` Progress indicator during Cloudinary upload
- `[B]`/`[F]` Store returned URL in `operations/{operationId}/reportUrls[]`
- `[F]` "Invalid File or Size Exceeded" error snackbar (SRS-78)

### 7.7 View Operation History (Admin/Doctor Web)

- `[F]` Build `operation_list_screen.dart` (Web):
  - Filterable list: by date, surgeon, patient ID, status (SRS-79)
  - Infinite scroll with shimmer skeleton loading (SRS-80)
  - Each row: `OperationCard` with status chip, patient name, surgeon, date
  - Tap → full operation detail view with audit log

---

## ✅ Phase 8: Medication Management

### 8.1 Backend Setup

- `[B]` Create `prescriptions` Firestore collection:
  ```
  {
    prescriptionId, operationId, patientId, doctorId,
    medicines: [{ name, dosage, frequency, startDate, endDate }],
    auditLog: [{ timestamp, oldDosage, newDosage, changedBy }],
    createdAt, updatedAt
  }
  ```
- `[B]` Firestore Rule: Only the assigned doctor can create/update; patient can only read

### 8.2 Add & Update Prescription (Doctor Mobile)

- `[B]`/`[F]` Implement `MedicationRepositoryImpl`: `addPrescription()`, `updateDosage()`, `fetchSchedule(patientId)`
- `[F]` Create `PrescriptionController`
- `[F]` Build `prescription_screen.dart` (Doctor Mobile):
  - Dynamic form: Add multiple medicines (drug name, dosage, frequency, duration)
  - "Add More Medicine" expandable row
  - Validation: all mandatory fields (SRS-82)
  - "Prescription Added Successfully" snackbar (SRS-83)
  - Edit mode: update dosage — auto-logs old vs new to audit (SRS-85)

### 8.3 View Medication Schedule (Patient Mobile)

- `[F]` Build `medication_schedule_screen.dart` (Patient Mobile):
  - Daily timetable: Morning / Afternoon / Evening / Night timeline
  - Medicine cards with name, dosage, time — clearly formatted (SRS-86)
  - `FadeInLeft` animation on each medicine card

---

## ✅ Phase 9: Communication Management (Real-Time Chat)

### 9.1 Backend Setup

- `[B]` Create `chat_rooms` Firestore collection:
  ```
  {
    roomId (patientId_doctorId), participants: [uid1, uid2],
    lastMessage, lastMessageTime, hasEmergency: bool
  }
  ```
- `[B]` Create `messages` sub-collection under each room:
  ```
  { messageId, senderId, text, status (Sent|Delivered|Read), timestamp, sharedFiles: [] }
  ```
- `[B]` Firestore Rule: Only participants of a chat room can read/write messages (SRS-88)
- `[B]` **Emergency Alert (replaces Cloud Function):**
  - Flutter calls `POST /api/notify/emergency` on Render.com server with list of team member FCM tokens
  - Render.com sends FCM HTTP v1 high-priority push to all surgical/ICU team members (SRS-92)
  - Firestore `chat_rooms/{roomId}/hasEmergency` is set to `true` by Flutter directly

### 9.2 Chat Repository & Controller

- `[B]`/`[F]` Implement `ChatRepositoryImpl`:
  - `sendMessage()`, `watchMessages(roomId)` → real-time stream
  - `markAsRead(messageId)`, `searchMessages(query)` (SRS-90)
  - `triggerEmergencyAlert(roomId)` (SRS-92)
- `[F]` Create `ChatController`

### 9.3 Chat List Screen

- `[F]` Build `chat_list_screen.dart` (Doctor Mobile + Web):
  - List of active chat rooms with last message preview
  - Unread badge count per room
  - `FadeInUp` stagger on list items

### 9.4 Chat Room Screen

- `[F]` Build `chat_room_screen.dart` (Shared):
  - Real-time message bubbles — sent (right, blue) / received (left, surface)
  - New messages slide up from bottom (`SlideInUp` animation)
  - Message status icons: Sent ✓ / Delivered ✓✓ / Read ✓✓ (blue) (SRS-91)
  - Timestamp displayed beside each message
  - Search bar within chat (SRS-90)
  - **Emergency Alert Button:** pulsing red button at bottom (SRS-92)

### 9.5 Emergency Alert

- `[F]` Build `EmergencyButton` widget with continuous pulsing ring animation
- `[F]` On tap: confirmation dialog → trigger `triggerEmergencyAlert()`
- `[B]`/`[F]` Receiving staff sees high-priority FCM notification + in-app "Acknowledge" button (SRS-93)
- `[F]` "Acknowledge" updates alert status in Firestore; sender sees confirmation

---

## ✅ Phase 10: Notifications Management

### 10.1 Backend Setup

- `[B]` Configure FCM in Firebase Console:
  - Enable **Cloud Messaging API (V1)** in Project Settings → Cloud Messaging tab
  - For Web: generate VAPID key pair in FCM Console (used for web push)
  - Download **Service Account JSON** → upload to Render.com as environment variable (used by Render server for FCM HTTP v1 auth)
- `[B]` Create `notifications` Firestore collection:
  ```
  { notificationId, userId, fcmToken, title, body, type, isRead, timestamp }
  ```
- `[B]` Store user's FCM device token in Firestore `users/{uid}/fcmToken` field (updated each login by Flutter)
- `[B]` **Checkup Reminders (replaces Cloud Function scheduled trigger, SRS-97):**
  - cron-job.org → every 30 minutes → calls `GET /api/reminders/check` on Render.com
  - Render.com server queries Firestore for appointments due in ±2h or ±24h
  - Sends FCM HTTP v1 push to matching patients via `firebase-admin` SDK
  - Notification includes: doctor name, time, room number (SRS-98)
- `[B]` **Operation Status Notification (replaces Cloud Function, SRS-100):**
  - Triggered by Flutter controller (not a server trigger) → calls `POST /api/notify/single`
  - See Phase 7.1 for details
- `[B]` **Account Credentials Email (replaces Cloud Function, SRS-94, SRS-95):**
  - Triggered by Flutter controller → calls `POST /api/email/credentials` on Render.com
  - Render.com uses Resend SDK to send email with temporary password
  - 24h link expiry is managed via `tokenExpiry: Timestamp` field in Firestore `users/{uid}`
  - On first login, Flutter checks `tokenExpiry` and forces password change (SRS-96)

### 10.2 In-App Notification Center

- `[B]`/`[F]` Implement `NotificationRepositoryImpl`: `watchNotifications(userId)`, `markAsRead()`, `clearAll()`
- `[F]` Create `NotificationController`
- `[F]` Build `notification_center_screen.dart`:
  - Chronological notification list (SRS-101)
  - Unread badge counter on notification icon in nav bar (SRS-102)
  - Tap to mark as read; "Clear All" button (SRS-103)
  - `FadeInDown` animation on each new notification arrival
  - Reminder details shown: doctor name, appointment time, room number (SRS-98)

---

## ✅ Phase 11: Reports & Analytics Management

### 11.1 Backend Setup

- `[B]` Design Firestore queries for analytics (aggregations):
  - Total operations by date range, by surgery type, by OT room
  - Success rate: `count(status == 'Completed') / count(all)`
  - Doctor performance: operations completed, avg duration, punctuality
  - Recovery analytics: recovery time, readmission rates
- `[B]` For large dataset performance: write a Render.com endpoint `GET /api/analytics/precompute` that runs Firestore aggregation queries and caches results in a Firestore `analytics_cache` collection (updated nightly via cron-job.org)

### 11.2 Analytics Dashboard (Admin Web)

- `[B]`/`[F]` Implement `ReportRepositoryImpl`: `fetchOperationAnalytics(filters)`, `fetchDoctorPerformance(doctorId)`, `fetchRecoveryAnalytics(filters)`
- `[F]` Create `ReportController`
- `[F]` Build `analytics_dashboard_screen.dart` (Admin Web):
  - Date range filter: Weekly / Monthly / Custom (SRS-105)
  - `PieChartWidget` — surgery type breakdown (SRS-106)
  - `BarChartWidget` — operations per day/week (bars grow from 0 on mount)
  - KPI stat cards: Total Ops, Success Rate, Avg Duration — count-up animation
  - All charts animate in with `FadeInUp` + data grows from zero (fl_chart)

### 11.3 Doctor Performance Report (Admin + Doctor)

- `[F]` Build `doctor_performance_screen.dart` (Web):
  - Completed operations, punctuality score, avg operation duration (SRS-109)
  - Doctor can only see their own report; Admin sees all (SRS-108)
  - Bar chart of operations per week

### 11.4 Patient Recovery Analytics (Admin Web)

- `[F]` Build `patient_recovery_screen.dart` (Web):
  - Recovery time distribution chart (SRS-110)
  - Readmission rate card
  - Filter by surgical procedure or age demographic (SRS-111)
  - Charts auto-update as new outcomes are submitted (SRS-112, live Firestore stream)

### 11.5 PDF Report Generation & Print

- `[F]` Implement `pdf_generator.dart`:
  - Generate Operation Summary PDF (patient name, surgery, team, outcome, date)
  - Generate Doctor Performance PDF summary
  - Use `pdf` package to build layout, `printing` package to download/print
- `[F]` "Download PDF" + "Print" buttons on each report screen

---

## ✅ Phase 12: Final Polish, Testing & Deployment

### 12.1 UI/UX Polish

- `[F]` Review all screens for animation consistency (refer to Animation Guidelines)
- `[F]` Add skeleton shimmer loaders to every list/data screen during loading
- `[F]` Implement `empty_state_widget.dart` on all lists (clear illustration + message)
- `[F]` Ensure all snackbars use `SnackbarHelper` (no raw `ScaffoldMessenger`)
- `[F]` Review responsive layout on: Android phone, Android tablet, Web 1366×768, Web 1920×1080
- `[F]` Implement auto-logout after inactivity (timer in shell controllers)
- `[F]` Confirm all string literals moved to `app_strings.dart`
- `[F]` Add `Hero` transitions between list cards and detail screens for smooth navigation
- `[F]` Optimize image loading with `CachedNetworkImage` on all profile pictures

### 12.2 Security Hardening

- `[B]` Lock Firestore Security Rules (remove test mode, implement full RBAC rules)
- `[B]` Set up Firebase App Check for API abuse prevention
- `[B]` Review all Cloudinary upload presets (restrict to allowed file types only)
- `[B]` Set FCM server key restrictions
- `[B]` Enable Firebase Audit Logs

### 12.3 Testing

- `[F]` Unit tests for all `validators.dart` functions
- `[F]` Unit tests for all Repository `fromMap()`/`toMap()` model parsing
- `[F]` Widget tests for critical shared widgets: `AppTextField`, `PrimaryButton`, `StatusChip`
- `[F]` Integration test: Full sign-in flow (email → role-based routing)
- `[F]` Integration test: Create operation → assign team → update status → patient sees update
- `[B]` Test all Render.com endpoints locally using Postman or REST Client before deploying
- `[B]` Use `firebase emulators:start` to test Firestore rules and Auth locally
- `[F]` Test on minimum spec Android device (Android 6.0, API 23)
- `[F]` Test web portal on Chrome, Firefox, and Edge (SRS-2.4.1)

### 12.4 Deployment

- `[B]` Deploy Firestore Security Rules to production: `firebase deploy --only firestore:rules`
- `[B]` Push Render.com backend to production via GitHub → Render auto-deploys on push to `main`
- `[B]` Verify all cron-job.org schedules are active and pointing to production Render.com URL
- `[B]` Verify Resend email domain is configured for production sending
- `[F]` Build Android APK/AAB: `flutter build apk --release` / `flutter build appbundle --release`
- `[F]` Build Web: `flutter build web --release`
- `[B]` Deploy web build to Firebase Hosting: `firebase deploy --only hosting`
- `[B]` Configure custom domain on Firebase Hosting (if applicable)
- `[F]` Prepare Play Store listing (screenshots, description, privacy policy)

---

## 📋 Module Completion Checklist

| Phase | Module                        | Backend | Frontend | Status    |
|-------|-------------------------------|---------|----------|-----------|
| 1     | Project Foundation            | ☑       | ☑        | Completed |
| 2     | Splash & Onboarding           | —       | ☐        | Pending |
| 3     | Security / Auth               | ☐       | ☐        | Pending |
| 4     | Profile Management            | ☐       | ☐        | Pending |
| 5     | Doctor Management             | ☐       | ☐        | Pending |
| 6     | Patient Portal                | ☐       | ☐        | Pending |
| 7     | Operation & Clinical Reporting| ☐       | ☐        | Pending |
| 8     | Medication Management         | ☐       | ☐        | Pending |
| 9     | Communication (Chat)          | ☐       | ☐        | Pending |
| 10    | Notifications                 | ☐       | ☐        | Pending |
| 11    | Reports & Analytics           | ☐       | ☐        | Pending |
| 12    | Polish, Testing & Deploy      | ☐       | ☐        | Pending |

---

## 🔗 SRS Cross-Reference Index

| SRS ID     | Covered In Phase |
|------------|------------------|
| SRS-1 to 4  | Phase 3 (Login)  |
| SRS-5 to 9  | Phase 3 (SignUp) |
| SRS-10 to 13| Phase 3 (Forgot Password) |
| SRS-14 to 16| Phase 3 (Change Password) |
| SRS-17 to 18| Phase 4 (Role Permissions) |
| SRS-19 to 23| Phase 4 (Staff Profile) |
| SRS-24 to 28| Phase 4 (Patient Profile) |
| SRS-29 to 30| Phase 4 (View User Profiles) |
| SRS-31 to 32| Phase 4 (Account Status) |
| SRS-33 to 38| Phase 5 (Add/Edit Doctor) |
| SRS-39 to 41| Phase 5 (Availability) |
| SRS-42 to 44| Phase 5 (Appointments) |
| SRS-45 to 47| Phase 5 (Assigned Patients) |
| SRS-48 to 49| Phase 5 (Doctor Workload) |
| SRS-50 to 52| Phase 6 (Patient Dashboard) |
| SRS-53 to 54| Phase 6 (Real-time Status) |
| SRS-55 to 57| Phase 6 (View Doctor) |
| SRS-58 to 59| Phase 6 (Download Report) |
| SRS-60 to 62| Phase 6 (Check-up History) |
| SRS-63 to 64| Phase 7 (Create Operation) |
| SRS-65 to 66| Phase 7 (Assign Team) |
| SRS-67 to 70| Phase 7 (Update Team) |
| SRS-71 to 72| Phase 7 (Record Outcome) |
| SRS-73 to 74| Phase 7 + Phase 10 (Credentials) |
| SRS-75 to 78| Phase 7 (Upload Reports) |
| SRS-79 to 80| Phase 7 (Operation History) |
| SRS-81 to 83| Phase 8 (Add Prescription) |
| SRS-84 to 85| Phase 8 (Update Dosage) |
| SRS-86      | Phase 8 (View Schedule) |
| SRS-87 to 88| Phase 9 (Initiate Chat) |
| SRS-89 to 91| Phase 9 (Chat History) |
| SRS-92 to 93| Phase 9 (Emergency Alerts) |
| SRS-94 to 96| Phase 10 (Account Credentials) |
| SRS-97 to 99| Phase 10 (Checkup Reminders) |
| SRS-100     | Phase 10 (Push Notifications) |
| SRS-101 to 103| Phase 10 (Notification History) |
| SRS-104 to 106| Phase 11 (Operation Reports) |
| SRS-107 to 109| Phase 11 (Doctor Performance) |
| SRS-110 to 112| Phase 11 (Recovery Analytics) |

---

*Document Version: 1.0 | OT Procedures & Tracking App | Development Roadmap*
