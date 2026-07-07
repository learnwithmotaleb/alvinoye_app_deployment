import 'package:delivery_app/features/parcel_owner/create_parcel/create_details_parcel/controller/create_details_parcel_controller.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dialog/custom_dialog.dart';
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
import 'package:iconsax/iconsax.dart';

import '../../../../../core/router/route_path.dart';
import '../../../../../core/router/routes.dart';

class CreateDetailsParcelScreen extends StatefulWidget {
  final String id;
  const CreateDetailsParcelScreen({super.key, required this.id});

  @override
  State<CreateDetailsParcelScreen> createState() =>
      _CreateDetailsParcelScreenState();
}

class _CreateDetailsParcelScreenState extends State<CreateDetailsParcelScreen> {
  final CreateDetailsParcelController createDetailsParcelController = Get.put(
    CreateDetailsParcelController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createDetailsParcelController.singleCreateDetailsParcel(id: widget.id);
    });
  }

  @override
  void dispose() {
    Get.delete<CreateDetailsParcelController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Parcel Details".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => createDetailsParcelController
            .singleCreateDetailsParcel(id: widget.id),
        child: CustomScrollView(
          slivers: [
            Obx(() {
              switch (createDetailsParcelController.loading.value) {
                case ApiStatus.loading:
                  return const SliverFillRemaining(
                    child: Center(child: LoadingWidget()),
                  );

                case ApiStatus.error:
                  return SliverFillRemaining(
                    child: Center(
                      child: ErrorCard(
                        onTap: () => createDetailsParcelController
                            .singleCreateDetailsParcel(id: widget.id),
                      ),
                    ),
                  );

                case ApiStatus.internetError:
                  return SliverFillRemaining(
                    child: Center(
                      child: NoInternetCard(
                        onTap: () => createDetailsParcelController
                            .singleCreateDetailsParcel(id: widget.id),
                      ),
                    ),
                  );

                case ApiStatus.noDataFound:
                  return SliverFillRemaining(
                    child: Center(
                      child: NoDataCard(
                        onTap: () => createDetailsParcelController
                            .singleCreateDetailsParcel(id: widget.id),
                      ),
                    ),
                  );

                case ApiStatus.completed:
                  final data =
                      createDetailsParcelController.parcelDetails.value?.data;

                  if (data == null) {
                    return SliverFillRemaining(
                      child: Center(child: Text("No Parcel Found".tr)),
                    );
                  }

                  final image =
                      (data.parcelImages != null &&
                          data.parcelImages!.isNotEmpty)
                      ? data.parcelImages!.first
                      : "https://static.vecteezy.com/system/resources/thumbnails/033/226/263/small/close-up-packing-cardboard-box-on-a-table-with-copyspace-against-background-ai-generated-photo.jpg";
                  final isWaiting = data.status == "WAITING";
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomNetworkImage(
                            imageUrl: image,
                            height: 200.h,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          Gap(20.h),

                          // DETAILS CARD
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  context,
                                  AppStrings.parcelId.tr,
                                  " ${data.parcelId ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  "${AppStrings.parcelName.tr}:",
                                  " ${data.parcelName ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  AppStrings.size.tr,
                                  " ${data.size ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  "${AppStrings.weight.tr}:",
                                  " ${data.weight ?? ''} kg",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  AppStrings.parcelPriority.tr,
                                  " ${data.priority ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  AppStrings.date.tr,
                                  " ${data.date?.toLocal().toIso8601String().split('T').first ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  AppStrings.time.tr,
                                  " ${data.time ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  AppStrings.pickupLocation.tr,
                                  " ${data.pickupLocation?.address ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  "${AppStrings.handoverLocation.tr} :",
                                  " ${data.handoverLocation?.address ?? ''}",
                                ),
                                Gap(16.h),

                                Text(
                                  AppStrings.receiverDetails.tr,
                                  style: context.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondPrimaryColor,
                                  ),
                                ),
                                Gap(8.h),

                                _buildDetailRow(
                                  context,
                                  AppStrings.receiverName.tr,
                                  " ${data.receiverName ?? ''}",
                                ),
                                Gap(6.h),
                                _buildDetailRow(
                                  context,
                                  AppStrings.receiverPhone.tr,
                                  " ${data.receiverPhone ?? ''}",
                                ),

                                Gap(6.h),

                                _buildDetailRow(
                                  context,
                                  AppStrings.senderRemarks.tr,
                                  " ${data.senderRemarks ?? data.review ?? ''}",
                                ),

                                Gap(16.h),

                                if (isWaiting)
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFF6E6E),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Waiting for parcel price",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          Gap(20.h),
                          if (isWaiting)
                            CustomButton(
                              onTap: () {
                                AppRouter.route.goNamed(
                                  RoutePath.parcelOwnerNavScreen,
                                  extra: 1,
                                );
                              },
                              text: "Back to parcel list".tr,
                            ),
                          Gap(20.h),
                          // BUTTONS
                          if (!isWaiting) ...[
                            OutlinedButton(
                              onPressed: () {
                                debugPrint(
                                  "data in create details parcel screen: $data",
                                );
                                AppRouter.route.pushNamed(
                                  RoutePath.createParcelScreen,
                                  extra: data,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                minimumSize: Size(double.infinity, 50.h),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.edit,
                                    color: AppColors.primaryColor,
                                    size: 20.r,
                                  ),
                                  Gap(8.w),
                                  Text(
                                    "Edit".tr,
                                    style: context.titleMedium.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(16.h),

                            Obx(
                              () => CustomButton(
                                isLoading:
                                    createDetailsParcelController
                                        .getDeliveryPriceStatus
                                        .value ==
                                    ApiStatus.loading,
                                onTap: () {
                                  AppDialog.show(
                                    context: context,
                                    title: AppStrings.getDeliveryPrice.tr,
                                    subtitle:
                                        "Are you sure you want to get the delivery price?",
                                    subtitleColor: AppColors.secondPrimaryColor,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          AppRouter.route.pop();
                                        },
                                        child: Text(
                                          AppStrings.cancel.tr,
                                          style: context.titleMedium.copyWith(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          AppRouter.route.pop();
                                          createDetailsParcelController
                                              .deliveryPrice(id: data.id ?? '');
                                        },
                                        child: Text(
                                          AppStrings.confirm.tr,
                                          style: context.titleMedium.copyWith(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                text: AppStrings.getDeliveryPrice.tr,
                              ),
                            ),
                            Gap(30.h),
                          ],
                        ],
                      ),
                    ),
                  );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: context.bodyLarge.copyWith(color: AppColors.primaryColor),
          ),
          TextSpan(text: value, style: context.bodyMedium),
        ],
      ),
    );
  }
}
