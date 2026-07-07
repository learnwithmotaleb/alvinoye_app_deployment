import 'package:delivery_app/features/parcel_owner/my_parcel/model/details_my_parcel_model.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReceiverDetailsSection extends StatelessWidget {
  final ParcelDetailsModelData parcelDetails;

  const ReceiverDetailsSection({super.key, required this.parcelDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.receiverDetails.tr, style: context.titleLarge),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.receiverName.tr,
          parcelDetails.receiverName ?? "",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.receiverPhone.tr,
          parcelDetails.receiverPhone ?? "",
        ),
        Gap(8.h),
        _buildDetailRow(
          context,
          AppStrings.senderRemarks.tr,
          parcelDetails.senderRemarks ?? "",
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
