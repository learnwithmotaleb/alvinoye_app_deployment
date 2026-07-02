import 'dart:convert';

import 'package:delivery_app/features/driver/commuter_registration/models/record_location.dart';
import 'package:delivery_app/features/driver/commuter_registration/widgets/image_picker_box.dart';
import 'package:delivery_app/features/parcel_owner/create_parcel/controller/create_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/create_parcel/widgets/selected_image_container.dart';
import 'package:delivery_app/helper/date_converter/date_converter.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/align/custom_align_text.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dropdown/custom_dropdown_field.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/share/widgets/text_field/description_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:map_location_picker/map_location_picker.dart';

import '../../../utils/config/app_config.dart';

class CreateParcelScreen extends StatefulWidget {
  const CreateParcelScreen({super.key});

  @override
  State<CreateParcelScreen> createState() => _CreateParcelScreenState();
}

class _CreateParcelScreenState extends State<CreateParcelScreen> {
  final _formKey = GlobalKey<FormState>();

  final CreateParcelController createParcelController = Get.put(
    CreateParcelController(),
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();
  final TextEditingController _senderRemarksController =
      TextEditingController();
  //final TextEditingController _vehicleTypeController = TextEditingController();

  final selectedPickupLocation = ValueNotifier<RecordLocation>(
    RecordLocation(LatLng(0.0, 0.0), ""),
  );
  final selectedHandoverLocation = ValueNotifier<RecordLocation>(
    RecordLocation(LatLng(0.0, 0.0), ""),
  );

  final ValueNotifier<String?> _selectedSize = ValueNotifier(null);
  final ValueNotifier<String?> _selectedPriority = ValueNotifier(null);
  final ValueNotifier<String?> _selectedVehicleType = ValueNotifier(null);
  final List<String> _vehicleTypes = ['Car', 'Bike', 'Truck', 'Van'];
  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    selectedPickupLocation.dispose();
    selectedHandoverLocation.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _senderRemarksController.dispose();
    //_vehicleTypeController.dispose();
    _selectedSize.dispose();
    _selectedPriority.dispose();
    super.dispose();
    Get.delete<CreateParcelController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Create Parcel",
          style: context.titleMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                title: "Parcel Name",
                hintText: "Enter your parcel name",
                fillColor: Colors.white,
                validator: TextFieldValidator.requiredField(
                  label: "Parcel Name",
                ),
              ),
              Gap(16.h),
              CustomAlignText(text: "Size"),
              Gap(12.h),
              ValueListenableBuilder<String?>(
                valueListenable: _selectedSize,
                builder: (context, value, child) {
                  return CustomDropdownField<String>(
                    value: value,
                    hintText: "select size",
                    items: const ["Small", "Medium", "Large"],
                    onChanged: (val) => _selectedSize.value = val,
                    fillColor: Colors.white,
                    validator: TextFieldValidator.requiredField(label: "Size"),
                  );
                },
              ),
              Gap(16.h),
              // CustomTextField(
              //   controller: _vehicleTypeController,
              //   title: "Vehicle Type",
              //   hintText: "Enter vehicle type",
              //   fillColor: Colors.white,
              //   validator: TextFieldValidator.requiredField(
              //     label: "Vehicle Type",
              //   ),
              // ),
              CustomAlignText(text: "Vehicle Type"),
              Gap(12.h),
              ValueListenableBuilder<String?>(
                valueListenable: _selectedVehicleType,
                builder: (context, value, child) {
                  return CustomDropdownField<String>(
                    value: value,
                    hintText: "select vehicle type",
                    items: _vehicleTypes,
                    onChanged: (val) => _selectedVehicleType.value = val,
                    fillColor: Colors.white,
                    validator: TextFieldValidator.requiredField(
                      label: "Vehicle Type",
                    ),
                  );
                },
              ),
              Gap(16.h),

              CustomTextField(
                controller: _weightController,
                title: "Weight",
                hintText: "Enter price weight",
                keyboardType: TextInputType.number,
                fillColor: Colors.white,
                validator: TextFieldValidator.number(label: "Weight"),
              ),
              Gap(16.h),
              CustomAlignText(text: "Pickup Location"),
              Gap(12.h),
              GestureDetector(
                onTap: () async {
                  _openLocationPicker(
                    selectedPickupLocation,
                  ); // Pass pickup notifier
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ValueListenableBuilder<RecordLocation>(
                    valueListenable:
                        selectedPickupLocation, // Listen to changes
                    builder: (_, item, _) {
                      String address = item.address.isEmpty
                          ? "Selected Your pickup location"
                          : item.address;
                      return Text(address);
                    },
                  ),
                ),
              ),
              Gap(16.h),
              CustomAlignText(text: "Handover Location"),
              Gap(12.h),
              GestureDetector(
                onTap: () async {
                  _openLocationPicker(
                    selectedHandoverLocation,
                  ); // Pass handover notifier
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ValueListenableBuilder<RecordLocation>(
                    valueListenable:
                        selectedHandoverLocation, // Listen to changes
                    builder: (_, item, _) {
                      String address = item.address.isEmpty
                          ? "Selected Your handover location"
                          : item.address;
                      return Text(address);
                    },
                  ),
                ),
              ),
              Gap(16.h),

              CustomAlignText(text: "Parcel Priority"),
              Gap(12.h),
              ValueListenableBuilder<String?>(
                valueListenable: _selectedPriority,
                builder: (context, value, child) {
                  return CustomDropdownField<String>(
                    value: value,
                    hintText: "Select Priority",
                    items: const ["Urgent", "Normal", "Low"],
                    onChanged: (val) => _selectedPriority.value = val,
                    fillColor: Colors.white,
                    validator: TextFieldValidator.requiredField(
                      label: "Priority",
                    ),
                  );
                },
              ),
              Gap(16.h),

              CustomTextField(
                controller: _dateController,
                title: "Date",
                hintText: "Select date",
                readOnly: true,
                suffixIcon: const Icon(
                  Iconsax.calendar_1,
                  color: AppColors.primaryColor,
                ),
                fillColor: Colors.white,
                validator: TextFieldValidator.requiredField(label: "Date"),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    _dateController.text = DateConverter.formatDate(
                      dateTime: picked,
                      format: 'yyyy-MM-dd',
                    );
                  }
                },
              ),
              Gap(16.h),

              CustomTextField(
                controller: _timeController,
                title: "Time",
                hintText: "Select starting time",
                readOnly: true,
                suffixIcon: const Icon(
                  Iconsax.clock,
                  color: AppColors.primaryColor,
                ),
                fillColor: Colors.white,
                validator: TextFieldValidator.requiredField(label: "Time"),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && context.mounted) {
                    _timeController.text = picked.format(context);
                  }
                },
              ),
              Gap(16.h),

              CustomAlignText(text: "Receiver details"),
              Gap(12.h),
              CustomTextField(
                controller: _receiverNameController,
                hintText: "Enter receiver name",
                fillColor: Colors.white,
                validator: TextFieldValidator.name(),
              ),
              Gap(12.h),
              CustomTextField(
                controller: _receiverPhoneController,
                hintText: "Enter receiver phone",
                keyboardType: TextInputType.phone,
                fillColor: Colors.white,
                validator: TextFieldValidator.phone(),
              ),
              Gap(12.h),
              DescriptionTextField(
                controller: _senderRemarksController,
                hintText: "Sender remarks",
                maxLines: 4,
                backgroundColor: Colors.white,
              ),
              Gap(12.h),

              Obx(
                () => createParcelController.parcelImage.value != null
                    ? SelectedImageContainer(
                        image: createParcelController.parcelImage.value!,
                        onRemove: () =>
                            createParcelController.parcelImage.value = null,
                      )
                    : ImagePickerBox(
                        onTap: () => createParcelController.pickImage(),
                      ),
              ),
              Gap(32.h),
              Obx(
                () => CustomButton(
                  isLoading: createParcelController.createParcelLoading.value,
                  onTap: () {
                    final body = {
                      "data": jsonEncode({
                        "parcel_name": _nameController.text,
                        "size": _selectedSize.value ?? "",
                        "vehicle_type": _selectedVehicleType.value ?? "",
                        "weight": _weightController.text.isNotEmpty
                            ? double.parse(_weightController.text)
                            : 0.0,
                        "pickup_location": {
                          "address": selectedPickupLocation.value.address,
                          "latitude":
                              selectedPickupLocation.value.latLng.latitude,
                          "longitude":
                              selectedPickupLocation.value.latLng.longitude,
                        },
                        "handover_location": {
                          "address": selectedHandoverLocation.value.address,
                          "latitude":
                              selectedHandoverLocation.value.latLng.latitude,
                          "longitude":
                              selectedHandoverLocation.value.latLng.longitude,
                        },
                        "priority": _selectedPriority.value ?? "",
                        "date": _dateController.text,
                        "time": _timeController.text,
                        "receiver_name": _receiverNameController.text,
                        "receiver_phone": _receiverPhoneController.text,
                        "sender_remarks": _senderRemarksController.text,
                      }),
                    };

                    if (_formKey.currentState!.validate()) {
                      createParcelController.createParcel(body: body);
                    }
                  },
                  text: AppStrings.confirm.tr,
                ),
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openLocationPicker(
    ValueNotifier<RecordLocation> targetNotifier,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          config: MapLocationPickerConfig(
            apiKey: AppConfig.googleApiKey,
            initialPosition: const LatLng(-22.3285, 24.6849),
            onNext: (result) {
              if (result != null) {
                targetNotifier.value = RecordLocation(
                  LatLng(
                    result.geometry?.location.lat ?? 0,
                    result.geometry?.location.lng ?? 0,
                  ),
                  result.formattedAddress ?? "Address not available",
                );
              }
              if (context.mounted) {
                Navigator.pop(context, result);
              }
            },
          ),
          searchConfig: const SearchConfig(
            apiKey: AppConfig.googleApiKey,
            searchHintText: "Search for a location",
          ),
        ),
      ),
    );
  }
}
