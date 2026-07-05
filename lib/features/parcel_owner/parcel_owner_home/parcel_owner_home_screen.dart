import 'package:delivery_app/features/parcel_owner/parcel_owner_home/controller/parcel_owner_home_controller.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/model/parcel_owner_home_model.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/active_parcel_card.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/parcel_owner_action_buttons.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/parcel_owner_header.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ParcelOwnerHomeScreen extends StatelessWidget {
  ParcelOwnerHomeScreen({super.key});
  final controller = Get.find<ParcelOwnerHomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshAllData();
          controller.getSingleOngoingData(pageKey: 1);
        },
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Obx(() {
                final profileData =
                    controller.profileController.profile.value.data;
                return ParcelOwnerHeader(
                  name: profileData?.fullName ?? "Guest",
                  imageUrl: profileData?.profilePicture ?? "",
                );
              }),
            ),

            // Main Content
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Gap(24.h),

                  // Action Buttons
                  const ParcelOwnerActionButtons(),
                  Gap(24.h),

                  // Active Parcel Section (Ongoing Parcels)
                  Text(
                    AppStrings.activeParcel.tr,
                    style: context.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),

                  _buildOngoingParcels(),

                  // Recent Delivery Section (Completed Parcels)
                  Text(
                    AppStrings.recentDeliveryParcel.tr,
                    style: context.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Gap(12.h),
                ]),
              ),
            ),

            // Completed Parcels List as Sliver
            PagedSliverList<int, ParcelItem>(
              pagingController: controller.completedController,
              builderDelegate: PagedChildBuilderDelegate<ParcelItem>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 6.h,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomNetworkImage(
                            borderRadius: BorderRadius.circular(8.r),
                            imageUrl: item.parcelImages?.isNotEmpty == true
                                ? item.parcelImages!.first
                                : "https://cdn-icons-png.flaticon.com/512/883/883407.png",
                            width: 70.w,
                            height: 70.w,
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      "Completed Parcel",
                                      style: context.labelMedium.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Parcel ID: ${item.parcelId ?? 'N/A'}",
                                  style: context.labelMedium.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(4.h),
                                RichText(
                                  text: TextSpan(
                                    text: "Parcel Name: ",
                                    style: context.bodySmall.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: item.parcelName ?? 'N/A',
                                        style: context.bodySmall.copyWith(
                                          color:
                                              AppColors.grayTextSecondaryColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "Size: ",
                                    style: context.bodySmall.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: item.size ?? 'N/A',
                                        style: context.bodySmall.copyWith(
                                          color:
                                              AppColors.grayTextSecondaryColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (context) => Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Center(
                    child: Text(
                      'Error loading completed parcels',
                      style: context.bodyMedium,
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        Gap(16.h),
                        Text(
                          'No completed parcels',
                          style: context.bodyLarge.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                newPageProgressIndicatorBuilder: (context) =>
                    const Center(child: LoadingWidget()),
                firstPageProgressIndicatorBuilder: (context) =>
                    const Center(child: LoadingWidget()),
              ),
            ),

            // Bottom spacing
            SliverToBoxAdapter(child: Gap(80.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingParcels() {
    return Obx(() {
      if (controller.isSingleLoading.value) {
        return SizedBox(
          height: 1.sh * 0.3,
          child: const Center(child: LoadingWidget()),
        );
      }

      final item = controller.firstParcel.value;
      if (item == null) {
        return SizedBox(
          height: 1.sh * 0.3,
          child: Center(
            child: NoDataCard(
              onTap: () => controller.getSingleOngoingData(pageKey: 1),
              title: "No active parcels",
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(12.h),
          ActiveParcelCard(parcelItem: item),
          Gap(24.h),
        ],
      );
    });
  }
}
