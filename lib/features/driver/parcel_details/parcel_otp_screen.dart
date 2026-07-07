import 'package:delivery_app/features/driver/parcel_details/controller/parcel_details_controller.dart';
import 'package:delivery_app/features/driver/parcels/controller/parcel_controller.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/otp_text_field.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ParcelOtpScreen extends StatefulWidget {
  final String parcelId;
  const ParcelOtpScreen({super.key, required this.parcelId});

  @override
  State<ParcelOtpScreen> createState() => _ParcelOtpScreenState();
}

class _ParcelOtpScreenState extends State<ParcelOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final controller = Get.find<ParcelController>();

  @override
  void dispose() {
    otpController.dispose();
    Get.delete<ParcelDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("OTP CODE", style: context.titleMedium),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(40.h),
                Text(
                  "Reciever accept parcel",
                  style: context.bodyLarge.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),
                Gap(24.h),
                Align(
                  alignment: Alignment.center,
                  child: OtpTextField(controller: otpController),
                ),
                Spacer(),
                Obx(
                  () => CustomButton(
                    isLoading: controller.otpLoading.value,
                    onTap: () {
                      print("parcelId: ${widget.parcelId}");
                      print("otp: ${otpController.text}");
                      controller.verifyParcelOtp(
                        widget.parcelId,
                        otpController.text,
                      );
                    },
                    text: "Verify Parcel OTP",
                    icon: Icons.share,
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
