import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/model/parcel_owner_home_model.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ActiveParcelCard extends StatelessWidget {
  final ParcelItem parcelItem;

  const ActiveParcelCard({super.key, required this.parcelItem});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = parcelItem.parcelImages?.isNotEmpty == true
        ? parcelItem.parcelImages!.first
        : "https://img.freepik.com/free-photo/cardboard-box-isolated_125540-652.jpg";

    final String route =
        "${parcelItem.pickupLocation?.address ?? 'N/A'} to ${parcelItem.handoverLocation?.address ?? 'N/A'}";

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            borderRadius: BorderRadius.circular(8.r),
            imageUrl: imageUrl,
            width: 80.w,
            height: 80.w,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRouter.route.pushNamed(
                          RoutePath.trackParcelOwnerScreen,
                          extra: parcelItem.toJson(),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "Track Live",
                          style: context.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Parcel ID: ${parcelItem.parcelId ?? 'N/A'}",
                        style: context.labelLarge.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  route,
                  style: context.bodySmall.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),
                Gap(8.h),
                // Custom Progress Bar
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                Gap(8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "Picked Up ",
                          style: context.bodySmall.copyWith(
                            color: AppColors.grayTextSecondaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: parcelItem.status ?? 'N/A',
                              style: context.bodySmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
