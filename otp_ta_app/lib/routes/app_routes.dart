abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const forgotPassword = '/forgot-password';
  static const changePassword = '/change-password';

  // Dashboards
  static const adminDashboard = '/admin-dashboard';
  static const doctorDashboard = '/doctor-dashboard';
  static const patientDashboard = '/patient-dashboard';
  static const operationTracking = '/operation-tracking';

  // Admin Module
  static const staffList = '/staff-list';
  static const addEditStaff = '/add-edit-staff';
  static const patientList = '/patient-list';
  static const addPatient = '/add-patient';
  static const rolePermissions = '/role-permissions';
  static const doctorList = '/doctor-list';
  static const addEditDoctor = '/add-edit-doctor';
  static const doctorAvailability = '/doctor-availability';
  static const appointmentList = '/appointment-list';
  static const bookAppointment = '/book-appointment';
  static const assignedPatients = '/assigned-patients';
  static const patientDetail = '/patient-detail';
  
  // Patient Module
  static const patientProfile = '/patient-profile';
}
