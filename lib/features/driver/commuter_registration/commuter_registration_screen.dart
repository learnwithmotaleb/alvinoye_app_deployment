import 'dart:convert';

import 'package:delivery_app/features/driver/commuter_registration/controller/commuter_registration_controller.dart';
import 'package:delivery_app/features/driver/commuter_registration/models/record_location.dart';
import 'package:delivery_app/features/driver/commuter_registration/widgets/image_picker_box.dart';
import 'package:delivery_app/helper/location_picker_helper/location_picker_helper.dart';
import 'package:delivery_app/features/driver/commuter_registration/widgets/selected_image_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dropdown/custom_dropdown_field.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

class CommuterRegistrationScreen extends StatefulWidget {
  const CommuterRegistrationScreen({super.key});

  @override
  State<CommuterRegistrationScreen> createState() =>
      _CommuterRegistrationScreenState();
}

class _CommuterRegistrationScreenState
    extends State<CommuterRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = .new();
  final TextEditingController _toController = .new();
  final TextEditingController _carNumberController = .new();
  final TextEditingController _stopsController = .new();
  final TextEditingController _dailyCommuteTimeController = .new();
  final TextEditingController _availableForDeliveryController = .new();
  final TextEditingController _maxParcelWeightController = .new();
  final TextEditingController _preferredPickUpPointsController = .new();
  final TextEditingController _notesController = .new();
  final TextEditingController _driverLicenceNumberController = .new();
  final TextEditingController _bankNameController = .new();
  final TextEditingController _accountNumberController = .new();
  final TextEditingController _accountHolderNameController = .new();
  final ValueNotifier<String?> _selectedVehicleType = ValueNotifier(null);
  final List<String> _vehicleTypes = ['Car', 'Bike', 'Truck', 'Van'];

  final selectedFromLocation = ValueNotifier<RecordLocation>(
    RecordLocation(LatLng(0.0, 0.0), ""),
  );
  final selectedToLocation = ValueNotifier<RecordLocation>(
    RecordLocation(LatLng(0.0, 0.0), ""),
  );

  final CommuterRegistrationController controller = Get.put(
    CommuterRegistrationController(),
  );
  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _carNumberController.dispose();
    _stopsController.dispose();
    _dailyCommuteTimeController.dispose();
    _availableForDeliveryController.dispose();
    _maxParcelWeightController.dispose();
    _preferredPickUpPointsController.dispose();
    _notesController.dispose();
    _driverLicenceNumberController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderNameController.dispose();
    _selectedVehicleType.dispose();
    selectedFromLocation.dispose();
    selectedToLocation.dispose();
    Get.delete<CommuterRegistrationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.professionalInfo.tr),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  readOnly: true,
                  onTap: () {
                    openLocationPicker(
                      context: context,
                      isFromField: true,
                      fromLocation: selectedFromLocation,
                      toLocation: selectedToLocation,
                      fromController: _fromController,
                      toController: _toController,
                    );
                  },
                  title: AppStrings.from.tr,
                  hintText: AppStrings.enterYourFrom.tr,
                  controller: _fromController,
                ),
                Gap(16.h),

                CustomTextField(
                  readOnly: true,
                  onTap: () {
                    openLocationPicker(
                      context: context,
                      isFromField: false,
                      fromLocation: selectedFromLocation,
                      toLocation: selectedToLocation,
                      fromController: _fromController,
                      toController: _toController,
                    );
                  },
                  title: AppStrings.to.tr,
                  hintText: AppStrings.enterYourTo.tr,
                  controller: _toController,
                ),
                Gap(16.h),

                Text(AppStrings.vehicleType.tr, style: context.bodyLarge),
                Gap(8.h),
                ValueListenableBuilder<String?>(
                  valueListenable: _selectedVehicleType,
                  builder: (context, value, child) {
                    return CustomDropdownField<String>(
                      hintText: "Car",
                      items: _vehicleTypes,
                      value: value,
                      onChanged: (val) {
                        _selectedVehicleType.value = val;
                      },
                    );
                  },
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.carNumber.tr,
                  hintText: "B456",
                  controller: _carNumberController,
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.driverLicenceNumber.tr,
                  hintText: AppStrings.enterLicenceNumber.tr,
                  controller: _driverLicenceNumberController,
                ),

                // Gap(16.h),

                // CustomTextField(
                //   title: AppStrings.stopsAlongTheWay.tr,
                //   hintText: AppStrings.enterStopsAlongTheWay.tr,
                //   controller: _stopsController,
                // ),
                Gap(16.h),

                Text(
                  AppStrings.scheduleAvailability.tr,
                  style: context.bodyLarge,
                ),
                Gap(16.h),
                CustomTextField(
                  readOnly: true,
                  onTap: () async {
                    final TimeOfDay? startTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        );
                      },
                    );

                    if (startTime != null && context.mounted) {
                      final TimeOfDay? endTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: startTime.hour + 1,
                          minute: startTime.minute,
                        ),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          );
                        },
                      );

                      if (endTime != null) {
                        final startFormatted = startTime.format(context);
                        final endFormatted = endTime.format(context);
                        _dailyCommuteTimeController.text =
                            '$startFormatted - $endFormatted';
                      }
                    }
                  },
                  hintText: "08:00 AM - 06:00 PM",
                  controller: _dailyCommuteTimeController,
                  title: AppStrings.dailyCommuteTime.tr,
                  suffixIcon: Icon(
                    Icons.access_time,
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),

                Gap(16.h),

                CustomTextField(
                  title: AppStrings.maxParcelWeight.tr,
                  hintText: AppStrings.enterMaxParcelWeight.tr,
                  controller: _maxParcelWeightController,
                ),

                Gap(16.h),

                CustomTextField(
                  title: AppStrings.notes.tr,
                  hintText: AppStrings.enterYourNotes.tr,
                  controller: _notesController,
                  maxLines: 3,
                ),
                Gap(16.h),

                // ---- Bank account (payout destination for wallet withdrawals) ----
                Text('Bank Account (for withdrawals)', style: context.bodyLarge),
                Gap(8.h),
                CustomTextField(
                  title: 'Bank Name',
                  hintText: 'Enter bank name',
                  controller: _bankNameController,
                ),
                Gap(16.h),
                CustomTextField(
                  title: 'Account Number',
                  hintText: 'Enter account number',
                  controller: _accountNumberController,
                ),
                Gap(16.h),
                CustomTextField(
                  title: 'Account Holder Name',
                  hintText: 'Enter account holder name',
                  controller: _accountHolderNameController,
                ),
                Gap(16.h),
                Text(AppStrings.numberPlateImage.tr, style: context.bodyLarge),
                Gap(8.h),
                Obx(
                  () => controller.numberPlateImage.value != null
                      ? SelectedImageBox(
                          image: controller.numberPlateImage.value!,
                          onRemove: () =>
                              controller.numberPlateImage.value = null,
                        )
                      : ImagePickerBox(
                          onTap: () =>
                              controller.pickImage('number_plate_image'),
                        ),
                ),
                Gap(16.h),

                Text(AppStrings.licenceImage.tr, style: context.bodyLarge),
                Gap(8.h),
                Obx(
                  () => controller.licenceImage.value != null
                      ? SelectedImageBox(
                          image: controller.licenceImage.value!,
                          onRemove: () => controller.licenceImage.value = null,
                        )
                      : ImagePickerBox(
                          onTap: () => controller.pickImage('license_image'),
                        ),
                ),
                Gap(16.h),

                Text(AppStrings.carImages.tr, style: context.bodyLarge),
                Gap(8.h),
                Obx(
                  () => SizedBox(
                    height: 100.w,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.carImages.length < 5
                          ? controller.carImages.length + 1
                          : 5,
                      separatorBuilder: (_, __) => Gap(16.w),
                      itemBuilder: (context, index) {
                        if (index == 0 && controller.carImages.length < 5) {
                          return ImagePickerBox(
                            onTap: () => controller.pickImage('vehicle_images'),
                          );
                        } else {
                          final imageIndex = controller.carImages.length < 5
                              ? index - 1
                              : index;
                          return SelectedImageBox(
                            image: controller.carImages[imageIndex],
                            onRemove: () =>
                                controller.removeCarImage(imageIndex),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Gap(32.h),

                Obx(
                  () => CustomButton(
                    isLoading: controller.registerCommuterLoading.value,
                    text: AppStrings.update.tr,
                    onTap: () {
                      final body = {
                        "data": jsonEncode({
                          "driverInfo": {
                            "from": {
                              "address": selectedFromLocation.value.address,
                              "latitude": selectedFromLocation
                                  .value
                                  .latLng
                                  .latitude
                                  .toString(),
                              "longitude": selectedFromLocation
                                  .value
                                  .latLng
                                  .longitude
                                  .toString(),
                            },
                            "to": {
                              "address": selectedToLocation.value.address,
                              "latitude": selectedToLocation
                                  .value
                                  .latLng
                                  .latitude
                                  .toString(),
                              "longitude": selectedToLocation
                                  .value
                                  .latLng
                                  .longitude
                                  .toString(),
                            },
                            "driver_license_number":
                                _driverLicenceNumberController.text,
                            "daily_commute_time":
                                _dailyCommuteTimeController.text,
                            "max_parcel_weight":
                                _maxParcelWeightController.text,
                            "bank_details": {
                              "bank_name": _bankNameController.text,
                              "account_number": _accountNumberController.text,
                              "account_holder_name":
                                  _accountHolderNameController.text,
                            },
                          },
                          "vehicle": {
                            "vehicle_type": _selectedVehicleType.value ?? "",
                            "vehicle_number": _carNumberController.text,
                          },
                        }),
                      };
                      if (_formKey.currentState!.validate()) {
                        controller.registerCommuter(body: body);
                      }
                    },
                  ),
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
