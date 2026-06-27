import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/staff_model.dart';
import '../../../data/repositories/staff_repository.dart';

class StaffController extends GetxController {
  final IStaffRepository _staffRepository;

  StaffController({required IStaffRepository staffRepository})
      : _staffRepository = staffRepository;

  final RxBool isLoading = false.obs;
  final RxList<StaffModel> staffList = <StaffModel>[].obs;
  final RxList<StaffModel> filteredStaffList = <StaffModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _watchStaff();
  }

  void _watchStaff() {
    _staffRepository.watchAllStaff().listen(
      (staff) {
        staffList.value = staff;
        filteredStaffList.value = staff;
      },
      onError: (e) {
        SnackbarHelper.showError('Failed to load staff list');
      },
    );
  }

  void filterStaff(String query) {
    if (query.isEmpty) {
      filteredStaffList.value = staffList;
      return;
    }
    
    final lowerQuery = query.toLowerCase();
    filteredStaffList.value = staffList.where((staff) {
      return staff.name.toLowerCase().contains(lowerQuery) ||
             staff.email.toLowerCase().contains(lowerQuery) ||
             staff.role.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> createStaff(StaffModel staff, String password) async {
    isLoading.value = true;
    try {
      // In a real serverless app, creating another user requires a Cloud Function
      // or a secondary Firebase App instance, as FirebaseAuth.instance.createUserWithEmailAndPassword
      // signs out the current admin. For the scope of this UI-focused assignment,
      // we'll mock the FirebaseAuth creation to avoid breaking the admin session.
      
      // MOCK START
      final mockUid = 'staff_${DateTime.now().millisecondsSinceEpoch}';
      // MOCK END
      
      final result = await _staffRepository.createStaff(staff, mockUid);
      
      result.fold(
        (failure) => SnackbarHelper.showError(failure.message),
        (_) {
          SnackbarHelper.showSuccess('Staff Profile Created Successfully');
          Get.back(); // Go back to list
        },
      );
    } catch (e) {
      SnackbarHelper.showError('An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStaff(StaffModel staff) async {
    isLoading.value = true;
    final result = await _staffRepository.updateStaff(staff);
    
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (_) {
        SnackbarHelper.showSuccess('Staff Profile Updated');
        Get.back();
      },
    );
    isLoading.value = false;
  }
}
