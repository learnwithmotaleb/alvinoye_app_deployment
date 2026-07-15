import 'dart:developer';

import 'package:delivery_app/features/parcel_owner/my_parcel/controller/details_my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/details_my_parcel_model.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/router/route_path.dart';
import '../../../../core/router/routes.dart';

class ActionButtonsSection extends StatelessWidget {
  final String? parcelStatus;
  final String? priceStatus;
  final List<PriceRequest> priceRequests;
  final DetailsMyParcelController controller;
  final ParcelDetailsModelData parcelDetails;
  final VoidCallback onRejectPressed;

  const ActionButtonsSection({
    super.key,
    this.parcelStatus,
    required this.priceRequests,
    required this.controller,
    required this.parcelDetails,
    required this.onRejectPressed,
    this.priceStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = parcelStatus?.toUpperCase() == "PENDING";
    final isAccepted = priceStatus?.toUpperCase() == "ACCEPTED";

    //
    // Get proposed price for status display
    final proposedPrice =
        double.tryParse(
          '${(parcelDetails.priceRequests != null && parcelDetails.priceRequests!.isNotEmpty) ? parcelDetails.priceRequests!.last.proposedPrice : 0}',
        ) ??
        0.0;

    log("parcel price in details page: in button section: $proposedPrice");

    // 👉 NEW CASE: Show only PAY button
    if (isPending && isAccepted && !parcelDetails.isPaid) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            AppRouter.route.pushNamed(
              RoutePath.paymentScreen,
              extra: parcelDetails,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(double.infinity, 48.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            "Pay",
            style: context.titleMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Existing rule: hide for PENDING or ONGOING (ONLY if not pay case)
    if (isPending || parcelStatus?.toUpperCase() == "ONGOING") {
      return const SizedBox.shrink();
    }

    if (priceRequests.isNotEmpty) {
      final lastRequest = priceRequests.last;

      if (lastRequest.priceType != "FINAL_OFFER" &&
          lastRequest.priceType != "PROPOSED") {
        return const SizedBox.shrink();
      }

      if (lastRequest.status == "REJECTED") {
        return const SizedBox.shrink();
      }
    }

    if (priceRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentPriceRequest = priceRequests.last;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Send the current price request ID to backend for acceptance
              print(currentPriceRequest.id);
              controller.acceptFinalOffer(
                id: currentPriceRequest.id ?? "",
                parcel: parcelDetails,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Obx(
              () => controller.loadingAcceptFinalOffer.value == true
                  ? const Center(child: LoadingWidget())
                  : Text(
                      AppStrings.accept.tr,
                      style: context.titleMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: onRejectPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              AppStrings.reject.tr,
              style: context.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
