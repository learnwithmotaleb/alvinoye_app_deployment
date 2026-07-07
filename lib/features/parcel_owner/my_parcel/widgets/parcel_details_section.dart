import 'package:delivery_app/features/parcel_owner/my_parcel/model/details_my_parcel_model.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ParcelDetailsSection extends StatelessWidget {
  final ParcelDetailsModelData parcelDetails;

  const ParcelDetailsSection({super.key, required this.parcelDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          context,
          "${'Parcel status'.tr} :",
          parcelDetails.status ?? "",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.parcelId.tr,
          parcelDetails.parcelId ?? "",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          "${AppStrings.parcelName.tr} :",
          parcelDetails.parcelName ?? "",
        ),
        Gap(8.h),
        _buildDetailRow(context, AppStrings.size.tr, parcelDetails.size ?? ""),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.weight.tr,
          "${parcelDetails.weight ?? ""} kg",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.parcelPriority.tr,
          parcelDetails.priority ?? "",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.date.tr,
          parcelDetails.date?.toLocal().toIso8601String().split('T').first ??
              "",
        ),
        Gap(8.h),
        _buildDetailRow(context, AppStrings.time.tr, parcelDetails.time ?? ""),
        Gap(8.h),
        _buildDetailRow(
          context,
          "${'Pick up location'.tr} :",
          parcelDetails.pickupLocation?.address ?? "N/A",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.handoverLocation.tr,
          parcelDetails.handoverLocation?.address ?? "",
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label  ',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: value,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.secondPrimaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
