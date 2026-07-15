import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/driver/parcel_details/controller/parcel_details_controller.dart';
import 'package:delivery_app/helper/date_converter/date_converter.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../driver_home/controller/driver_home_controller.dart';

class ParcelDetailsScreen extends StatefulWidget {
  final String parcelId;
  const ParcelDetailsScreen({super.key, required this.parcelId});

  @override
  State<ParcelDetailsScreen> createState() => _ParcelDetailsScreenState();
}

class _ParcelDetailsScreenState extends State<ParcelDetailsScreen> {
  final ParcelDetailsController controller = Get.put(ParcelDetailsController());
  final DriverHomeController driverHomeCtrl = Get.find();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.parcelId.isNotEmpty) {
        controller.getParcelDetails(widget.parcelId);
      }
    });
  }

  @override
  void dispose() {
    Get.delete<ParcelDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.detailsPage.tr),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.parcelId.isNotEmpty) {
            await controller.getParcelDetails(widget.parcelId);
          }
        },
        child: CustomScrollView(
          slivers: [
            Obx(() {
              switch (controller.loading.value) {
                case ApiStatus.loading:
                  return const SliverFillRemaining(
                    child: Center(child: LoadingWidget()),
                  );

                case ApiStatus.error:
                  return SliverFillRemaining(
                    child: Center(
                      child: ErrorCard(
                        onTap: () {
                          if (widget.parcelId.isNotEmpty) {
                            controller.getParcelDetails(widget.parcelId);
                          }
                        },
                      ),
                    ),
                  );

                case ApiStatus.internetError:
                  return SliverFillRemaining(
                    child: Center(
                      child: NoInternetCard(
                        onTap: () {
                          if (widget.parcelId.isNotEmpty) {
                            controller.getParcelDetails(widget.parcelId);
                          }
                        },
                      ),
                    ),
                  );

                case ApiStatus.noDataFound:
                  return SliverFillRemaining(
                    child: Center(
                      child: NoDataCard(
                        onTap: () {
                          if (widget.parcelId.isNotEmpty) {
                            controller.getParcelDetails(widget.parcelId);
                          }
                        },
                        title: "No details found".tr,
                      ),
                    ),
                  );

                case ApiStatus.completed:
                  final data = controller.parcelDetails.value;
                  if (data == null) {
                    return SliverFillRemaining(
                      child: Center(
                        child: NoDataCard(
                          onTap: () {
                            if (widget.parcelId.isNotEmpty) {
                              controller.getParcelDetails(widget.parcelId);
                            }
                          },
                          title: "No details found".tr,
                        ),
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(20.h),
                          // Parcel Image
                          CustomNetworkImage(
                            imageUrl:
                                (data.parcelImages != null &&
                                    data.parcelImages!.isNotEmpty)
                                ? data.parcelImages!.first
                                : "", // Use first image or placeholder
                            height: 200.h,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          Gap(24.h),

                          // Details Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.parcelId.tr,
                                  value: data.parcelId ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: "${AppStrings.parcelName.tr}:",
                                  value: data.parcelName ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.size.tr,
                                  value: data.size ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: "${AppStrings.weight.tr}:",
                                  value: "${data.weight ?? 0} kg",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.price.tr,
                                  value: "\$${data.finalPrice ?? 0}",
                                  valueColor: AppColors.redColor,
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.parcelPriority.tr,
                                  value: data.priority ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.date.tr,
                                  value: data.date != null
                                      ? DateConverter.formatDate(
                                          dateTime: data.date,
                                        )
                                      : "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.time.tr,
                                  value: data.time ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.pickupLocation.tr,
                                  value: data.pickupLocation?.address ?? "N/A",
                                  isMultiLine: true,
                                ),
                                Gap(16.h),
                                Text(
                                  'Sender details'.tr,
                                  style: context.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.senderName.tr,
                                  value: data.userId?.fullName ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.senderPhone.tr,
                                  value: data.userId?.phoneNumber ?? "N/A",
                                ),
                                Gap(16.h),
                                Text(
                                  AppStrings.receiverDetails.tr,
                                  style: context.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.receiverName.tr,
                                  value: data.receiverName ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.receiverPhone.tr,
                                  value: data.receiverPhone ?? "N/A",
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: "${AppStrings.deliveryPoint.tr} :",
                                  value:
                                      data.handoverLocation?.address ?? "N/A",
                                  isMultiLine: true,
                                ),
                                Gap(8.h),
                                _buildDetailRow(
                                  context,
                                  label: AppStrings.senderRemarks.tr,
                                  value: data.senderRemarks ?? "N/A",
                                  isMultiLine: true,
                                ),
                              ],
                            ),
                          ),
                          Gap(100.h), // Space for bottom button
                        ],
                      ),
                    ),
                  );
              }
            }),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: SizedBox(
          width: double.infinity,
          child: Obx(
            () => CustomButton(
              isLoading:
                  driverHomeCtrl.acceptLoadingMap[widget.parcelId ?? ''] ==
                  true,
              onTap: () async {
                await driverHomeCtrl.acceptParcel(id: widget.parcelId ?? "");
                AppRouter.route.pushNamed(
                  RoutePath.parcelOtpScreen,
                  extra: widget.parcelId,
                );
              },
              text: AppStrings.confirm.tr,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    bool isMultiLine = false,
  }) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: context.bodyMedium.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: value,
            style: context.bodyMedium.copyWith(
              color: valueColor ?? AppColors.grayTextSecondaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      maxLines: isMultiLine ? 3 : 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
