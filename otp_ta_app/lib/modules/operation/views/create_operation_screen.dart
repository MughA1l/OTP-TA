import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../shared_widgets/buttons/primary_button.dart';
import '../../../shared_widgets/inputs/app_text_field.dart';
import '../../../shared_widgets/inputs/app_dropdown.dart';
import '../../../data/models/operation_model.dart';
import '../../../data/models/patient_model.dart';
import '../controllers/operation_controller.dart';

class CreateOperationScreen extends GetView<OperationController> {
  const CreateOperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final surgeryTypeCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();

    final Rx<PatientModel?> selectedPatient = Rx<PatientModel?>(null);
    final Rx<String?> selectedRoom = Rx<String?>(null);
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
    final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

    final isWeb = ResponsiveHelper.isDesktop(context);

    Future<void> selectDate(BuildContext context) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                onPrimary: AppColors.onPrimary,
                surface: AppColors.surface,
                onSurface: AppColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        selectedDate.value = picked;
        dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    Future<void> selectTime(BuildContext context) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                onPrimary: AppColors.onPrimary,
                surface: AppColors.surface,
                onSurface: AppColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        selectedTime.value = picked;
        if (context.mounted) {
          timeCtrl.text = picked.format(context);
        }
      }
    }

    Future<void> submitForm() async {
      if (formKey.currentState!.validate() &&
          selectedPatient.value != null &&
          selectedRoom.value != null &&
          selectedDate.value != null &&
          selectedTime.value != null) {
        final combinedDateTime = DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
          selectedTime.value!.hour,
          selectedTime.value!.minute,
        );

        final newOperation = OperationModel(
          operationId: '',
          patientId: selectedPatient
              .value!
              .uid, // The user's UID for fetching user doc
          patientName: selectedPatient.value!.name,
          surgeryType: surgeryTypeCtrl.text.trim(),
          otRoom: selectedRoom.value!,
          scheduledDate: combinedDateTime,
          scheduledTime: timeCtrl.text,
          status: OperationStatus.scheduled,
          surgicalTeam: SurgicalTeamModel(
            primaryDoctorId: '',
            anaesthesiologistId: '',
            nursingStaff: [],
          ),
          credentialsGenerated: false,
          reportUrls: [],
          auditLog: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await controller.createOperation(newOperation);
      } else if (selectedPatient.value == null) {
        Get.snackbar(
          'Selection Required',
          'Please select a patient from the list.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      } else if (selectedRoom.value == null) {
        Get.snackbar(
          'Selection Required',
          'Please select an OT Room.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Schedule Operation', style: AppTextStyles.headlineMedium),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 550 : double.infinity,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'Create New Operation Record',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.primaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL),

                  // Searchable Patient AutoComplete Dropdown
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 100),
                    child: Obx(() {
                      if (controller.patientList.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      return Autocomplete<PatientModel>(
                        displayStringForOption: (patient) =>
                            '${patient.name} (${patient.patientId})',
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return controller.patientList;
                          }
                          return controller.patientList.where((
                            PatientModel patient,
                          ) {
                            return patient.name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                ) ||
                                patient.patientId.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                );
                          });
                        },
                        fieldViewBuilder:
                            (
                              context,
                              textEditingController,
                              focusNode,
                              onFieldSubmitted,
                            ) {
                              return AppTextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                label: 'Select Patient',
                                hint: 'Type patient name or ID...',
                                prefixIcon: Icons.person_search_outlined,
                                validator: (val) {
                                  if (selectedPatient.value == null) {
                                    return 'Patient is required.';
                                  }
                                  return null;
                                },
                              );
                            },
                        onSelected: (PatientModel selection) {
                          selectedPatient.value = selection;
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  // Surgery Type Input
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 150),
                    child: AppTextField(
                      controller: surgeryTypeCtrl,
                      label: 'Surgery Type',
                      hint: 'e.g., General Laparoscopy, Bypass',
                      prefixIcon: Icons.medical_services_outlined,
                      validator: (val) => Validators.validateRequired(
                        val,
                        fieldName: 'Surgery Type',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  // OT Room Selector Dropdown
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 200),
                    child: Obx(
                      () => AppDropdown<String>(
                        value: selectedRoom.value,
                        label: 'OT Room Room',
                        hint: 'Choose operating room',
                        prefixIcon: Icons.meeting_room_outlined,
                        items:
                            [
                              'Room A',
                              'Room B',
                              'Room C',
                              'Room D',
                              'Room E',
                            ].map((room) {
                              return DropdownMenuItem<String>(
                                value: room,
                                child: Text(room),
                              );
                            }).toList(),
                        onChanged: (room) => selectedRoom.value = room,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  // Scheduled Date Picker
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 250),
                    child: GestureDetector(
                      onTap: () => selectDate(context),
                      child: AbsorbPointer(
                        child: AppTextField(
                          controller: dateCtrl,
                          label: 'Scheduled Date',
                          hint: 'YYYY-MM-DD',
                          prefixIcon: Icons.calendar_today_outlined,
                          validator: (val) => Validators.validateRequired(
                            val,
                            fieldName: 'Scheduled Date',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  // Scheduled Time Picker
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: () => selectTime(context),
                      child: AbsorbPointer(
                        child: AppTextField(
                          controller: timeCtrl,
                          label: 'Scheduled Time',
                          hint: 'HH:MM AM/PM',
                          prefixIcon: Icons.access_time_outlined,
                          validator: (val) => Validators.validateRequired(
                            val,
                            fieldName: 'Scheduled Time',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL),

                  // Create Record Submit Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 350),
                    child: Obx(
                      () => PrimaryButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : submitForm,
                        label: 'Create Record',
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
