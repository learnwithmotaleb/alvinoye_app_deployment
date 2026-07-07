import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/align/custom_align_text.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dropdown/custom_dropdown_field.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/share/widgets/text_field/description_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class EditParcelScreen extends StatefulWidget {
  const EditParcelScreen({super.key});

  @override
  State<EditParcelScreen> createState() => _EditParcelScreenState();
}

class _EditParcelScreenState extends State<EditParcelScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _handoverLocationController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();
  final TextEditingController _senderRemarksController =
      TextEditingController();

  final ValueNotifier<String?> _selectedSize = ValueNotifier(null);
  final ValueNotifier<String?> _selectedVehicle = ValueNotifier(null);
  final ValueNotifier<String?> _selectedPriority = ValueNotifier(null);

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _handoverLocationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _senderRemarksController.dispose();
    _selectedSize.dispose();
    _selectedVehicle.dispose();
    _selectedPriority.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Parcel"),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
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

              CustomAlignText(text: "Vehicle Type"),
              Gap(12.h),
              ValueListenableBuilder<String?>(
                valueListenable: _selectedVehicle,
                builder: (context, value, child) {
                  return CustomDropdownField<String>(
                    value: value,
                    hintText: "Select vehicle",
                    items: const ["Bike", "Car", "Truck"],
                    onChanged: (val) => _selectedVehicle.value = val,
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

              CustomTextField(
                controller: _handoverLocationController,
                title: "Handover location",
                hintText: "enter location",
                fillColor: Colors.white,
                validator: TextFieldValidator.requiredField(
                  label: "Handover location",
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
                    items: const ["Standard", "Express"],
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
                    lastDate: DateTime(2026),
                  );
                  if (picked != null) {
                    _dateController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
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
                  if (picked != null) {
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
              CustomNetworkImage(
                borderRadius: BorderRadius.circular(12.r),
                imageUrl:
                    "https://img.freepik.com/free-vector/3d-delivery-box-parcel_78370-825.jpg?semt=ais_hybrid&w=740&q=80",
                width: 150.w,
                height: 150.h,
              ),
              Gap(32.h),
              CustomButton(
                onTap: () {
                  // if (_formKey.currentState!.validate()) {

                  // }
                  context.pop();
                },
                text: AppStrings.update.tr,
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
