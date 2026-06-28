abstract class AppStrings {
  // Common UI Strings
  static const String appName = 'OT Procedures & Tracking';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';

  // Validation Messages
  static const String errorEmptyField = 'This field cannot be empty';
  static const String errorInvalidEmail = 'Please enter a valid email';
  static const String errorShortPassword =
      'Password must be at least 8 characters';
  static const String sessionExpiredTitle = 'Session Expired';
  static const String sessionExpiredMessage =
      'Your session has expired. Please sign in again to continue securely.';

  // Dashboard & Roles
  static const String adminDashboard = 'Admin Dashboard';
  static const String doctorDashboard = 'Doctor Dashboard';
  static const String patientDashboard = 'Patient Dashboard';
}
