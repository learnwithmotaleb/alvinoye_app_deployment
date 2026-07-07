import 'package:delivery_app/features/parcel_owner/my_parcel/model/details_my_parcel_model.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PriceDisplaySection extends StatelessWidget {
  final bool hasProposedPrice;
  final bool hasFinalPrice;
  final double finalPrice;
  final double proposedPrice;
  final List<PriceRequest>? priceRequests;

  const PriceDisplaySection({
    super.key,
    required this.hasProposedPrice,
    required this.hasFinalPrice,
    required this.finalPrice,
    required this.proposedPrice,
    this.priceRequests,
  });

  @override
  Widget build(BuildContext context) {
    // Show "Waiting for parcel price" if no proposed price
    if (!hasProposedPrice) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xffFF6E6E),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Center(
          child: Text(
            "Waiting for parcel price",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    // Show price section if there's a proposed price
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: double.infinity,
      // height: 45.h,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(
            hasFinalPrice ? 'Final Price : ' : '${AppStrings.price.tr} ',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
          Text(
            hasFinalPrice
                ? '\$${finalPrice.toStringAsFixed(2)}'
                : '\$${proposedPrice.toStringAsFixed(2)}',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          // Only show status badge if there's no final price
          if (!hasFinalPrice) ...[
            Gap(8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  priceRequests != null && priceRequests!.isNotEmpty
                      ? priceRequests!.last.priceType
                      : null,
                ).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                priceRequests != null && priceRequests!.isNotEmpty
                    ? priceRequests!.last.priceType ?? 'NOT_SET'
                    : 'NOT_SET',
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,

                  color: _getStatusColor(
                    priceRequests != null && priceRequests!.isNotEmpty
                        ? priceRequests!.last.priceType
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toUpperCase()) {
      case "COUNTERED":
        return Colors.orange;
      case "PROPOSED":
        return AppColors.primaryColor;
      case "FINAL_OFFER":
        return Colors.purple;
      case "ACCEPTED":
        return Colors.green;
      case "REJECTED":
        return AppColors.error;
      case "NOT_SET":
      default:
        return Colors.grey;
    }
  }
}
