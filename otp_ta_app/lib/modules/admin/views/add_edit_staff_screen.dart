import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/staff_model.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../shared_widgets/inputs/app_password_field.dart';
import '../../../shared_widgets/inputs/app_dropdown.dart';
import '../controllers/staff_controller.dart';

class AddEditStaffScreen extends GetView<StaffController> {
  const AddEditStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StaffModel? existingStaff = Get.arguments;
    final isEditing = existingStaff != null;

    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existingStaff?.name);
    final emailCtrl = TextEditingController(text: existingStaff?.email);
    final phoneCtrl = TextEditingController(text: existingStaff?.phone);
    final passwordCtrl = TextEditingController();
    
    // Using Rx for the dropdown to update UI
    final roleValue = (existingStaff?.role ?? 'doctor').obs;

    final isWeb = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEditing ? 'Edit Staff Profile' : 'Add New Staff',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.6),
                  radius: 1.0,
                  colors: [
                    AppColors.primaryContainer,
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 600 : double.infinity,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingXL),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                          border: Border.all(color: AppColors.glassBorder, width: 1),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                child: AppTextField(
                                  controller: nameCtrl,
                                  label: 'Full Name',
                                  prefixIcon: Icons.person_outline,
                                  validator: Validators.validateRequired,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),
                              
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 100),
                                child: AppTextField(
                                  controller: emailCtrl,
                                  label: 'Email Address',
                                  prefixIcon: Icons.email_outlined,
                                  validator: Validators.validateEmail,
                                  enabled: !isEditing, // Prevent email change after creation for simplicity
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 200),
                                child: AppTextField(
                                  controller: phoneCtrl,
                                  label: 'Phone Number',
                                  prefixIcon: Icons.phone_outlined,
                                  validator: Validators.validatePhone,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 300),
                                child: Obx(() => AppDropdown<String>(
                                  value: roleValue.value,
                                  label: 'Job Role',
                                  prefixIcon: Icons.work_outline,
                                  items: const [
                                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                                    DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
                                    DropdownMenuItem(value: 'receptionist', child: Text('Receptionist')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) roleValue.value = val;
                                  },
                                )),
                              ),
                              const SizedBox(height: AppDimensions.paddingM),

                              // Show password field only when creating new staff
                              if (!isEditing) ...[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  delay: const Duration(milliseconds: 400),
                                  child: AppPasswordField(
                                    controller: passwordCtrl,
                                    label: 'Initial Password',
                                    validator: Validators.validatePassword,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingM),
                              ],

                              // Permission hints based on role
                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 450),
                                child: Container(
                                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                  ),
                                  child: Obx(() {
                                    String hints = '';
                                    if (roleValue.value == 'admin') {
                                      hints = '• Full system access\n• Manage staff and patients\n• System settings';
                                    } else if (roleValue.value == 'doctor') {
                                      hints = '• View/Update assigned patients\n• Manage operation notes\n• Cannot manage other staff';
                                    } else {
                                      hints = '• Register new patients\n• Schedule appointments\n• View reports';
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Auto-assigned Permissions:', style: AppTextStyles.labelLarge),
                                        const SizedBox(height: AppDimensions.paddingXS),
                                        Text(hints, style: AppTextStyles.bodyMedium),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingL),

                              // Account Status Toggle for Admin (SRS-31)
                              if (isEditing) ...[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 400),
                                  delay: const Duration(milliseconds: 480),
                                  child: AppDropdown<String>(
                                    // Mocked initial value for now since we didn't fetch status in watchAllStaff
                                    value: 'active',
                                    label: 'Account Status',
                                    prefixIcon: Icons.manage_accounts_rounded,
                                    items: const [
                                      DropdownMenuItem(value: 'active', child: Text('Active')),
                                      DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                                      DropdownMenuItem(value: 'deactivated', child: Text('Deactivated')),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        controller.updateAccountStatus(existingStaff.staffId, val);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingL),
                              ],

                              const SizedBox(height: AppDimensions.paddingXL),

                              FadeInUp(
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 500),
                                child: Obx(() => PrimaryButton(
                                  label: isEditing ? 'Save Changes' : 'Create Staff Profile',
                                  isLoading: controller.isLoading.value,
                                  icon: Icons.save_rounded,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      final updatedStaff = StaffModel(
                                        staffId: isEditing ? existingStaff.staffId : '', // ID is assigned by controller/repo if new
                                        name: nameCtrl.text,
                                        email: emailCtrl.text,
                                        phone: phoneCtrl.text,
                                        role: roleValue.value,
                                        createdAt: isEditing ? existingStaff.createdAt : DateTime.now(),
                                      );

                                      if (isEditing) {
                                        controller.updateStaff(updatedStaff);
                                      } else {
                                        controller.createStaff(updatedStaff, passwordCtrl.text);
                                      }
                                    }
                                  },
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
