import 'dart:convert';
import 'dart:developer';

import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/controller/details_my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/action_buttons_section.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/parcel_details_section.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/parcel_image_section.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/price_display_section.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/receiver_details_section.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/status_message_section.dart';
import 'package:delivery_app/share/widgets/dialog/custom_dialog.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DetailsMyParcelScreen extends StatefulWidget {
  final ParcelItem parcel;
  const DetailsMyParcelScreen({super.key, required this.parcel});

  @override
  State<DetailsMyParcelScreen> createState() => _DetailsMyParcelScreenState();
}

class _DetailsMyParcelScreenState extends State<DetailsMyParcelScreen> {
  final DetailsMyParcelController controller = Get.put(
    DetailsMyParcelController(),
  );
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController finalPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.parcel.id != null) {
        controller.singleDetailsMyParcel(id: widget.parcel.id!);
      }
    });
  }

  @override
  void dispose() {
    reasonController.dispose();
    finalPriceController.dispose();
    Get.delete<DetailsMyParcelController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(
      "price of parcel in detailsMyParcelScreen : ${widget.parcel.finalPrice}",
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.detailsPage.tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.parcel.id != null) {
            await controller.singleDetailsMyParcel(id: widget.parcel.id!);
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                          if (widget.parcel.id != null) {
                            controller.singleDetailsMyParcel(
                              id: widget.parcel.id!,
                            );
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
                          if (widget.parcel.id != null) {
                            controller.singleDetailsMyParcel(
                              id: widget.parcel.id!,
                            );
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
                          if (widget.parcel.id != null) {
                            controller.singleDetailsMyParcel(
                              id: widget.parcel.id!,
                            );
                          }
                        },
                      ),
                    ),
                  );
                case ApiStatus.completed:
                  final parcelDetails = controller.detailsMyParcel.value?.data;
                  final priceRequests =
                      controller.detailsMyParcel.value?.data?.priceRequests ??
                      [];
                  debugPrint("parcelDetails --> ");
                  debugPrint(
                    parcelDetails == null
                        ? 'null'
                        : const JsonEncoder.withIndent(
                            '  ',
                          ).convert(parcelDetails.toJson()),
                  );

                  if (parcelDetails == null) {
                    return SliverFillRemaining(
                      child: Center(child: Text("No details found".tr)),
                    );
                  }

                  // Check if finalPrice exists
                  final finalPrice = parcelDetails.finalPrice != null
                      ? double.tryParse('${parcelDetails.finalPrice}') ?? 0.0
                      : 0.0;

                  final hasFinalPrice = finalPrice > 0;

                  // Get proposed price for status display
                  final proposedPrice =
                      double.tryParse(
                        '${(parcelDetails.priceRequests != null && parcelDetails.priceRequests!.isNotEmpty) ? parcelDetails.priceRequests!.last.proposedPrice : 0}',
                      ) ??
                      0.0;
                  final hasProposedPrice = proposedPrice > 0;

                  debugPrint("parcelDetails.isPaid : ${parcelDetails.isPaid}");

                  //
                  final canShowPayButton =
                      hasProposedPrice &&
                      parcelDetails.status?.toUpperCase() == "PENDING" &&
                      parcelDetails.priceStatus?.toUpperCase() == "ACCEPTED" &&
                      parcelDetails.isPaid == false;

                  //
                  log("proposedPrice of detail model parsed : $proposedPrice");

                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Parcel Image
                        ParcelImageSection(
                          imageUrl:
                              (parcelDetails.parcelImages != null &&
                                  parcelDetails.parcelImages!.isNotEmpty)
                              ? parcelDetails.parcelImages!.first
                              : null,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Parcel Details
                              ParcelDetailsSection(
                                parcelDetails: parcelDetails,
                              ),

                              Gap(16.h),

                              // Receiver Details
                              ReceiverDetailsSection(
                                parcelDetails: parcelDetails,
                              ),

                              Gap(16.h),

                              // Price Display
                              PriceDisplaySection(
                                hasProposedPrice: hasProposedPrice,
                                hasFinalPrice: hasFinalPrice,
                                finalPrice: finalPrice,
                                proposedPrice: proposedPrice,
                                priceRequests: parcelDetails.priceRequests,
                              ),

                              if (hasProposedPrice) ...[
                                if (!canShowPayButton) ...[
                                  Gap(16.h),

                                  // Status Message (REJECTED/COUNTERED)
                                  StatusMessageSection(
                                    priceRequests: parcelDetails.priceRequests,
                                  ),
                                ],
                                Gap(16.h),

                                // Action Buttons (Accept/Reject)
                                ActionButtonsSection(
                                  parcelStatus: parcelDetails.status,
                                  priceStatus: parcelDetails.priceStatus,
                                  priceRequests: priceRequests,
                                  controller: controller,
                                  parcelDetails: parcelDetails,
                                  onRejectPressed: () {
                                    _showRejectDialog(context, priceRequests);
                                  },
                                ),
                              ],

                              Gap(16.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, priceRequests) {
    final isFinalOffer =
        priceRequests != null &&
        priceRequests.isNotEmpty &&
        priceRequests.last.priceType == "FINAL_OFFER";

    if (isFinalOffer) {
      // Show simple confirmation dialog for FINAL_OFFER
      AppDialog.show(
        context: context,
        title: "Reject Final Offer",
        subtitle:
            "Are you sure you want to reject this final offer? This action cannot be undone.",
        subtitleColor: AppColors.black,
        type: AppDialogType.warning,
        actions: [
          TextButton(
            onPressed: () {
              AppRouter.route.pop();
            },
            child: Text(AppStrings.cancel.tr),
          ),
          Gap(8.w),
          Obx(
            () => controller.loadingRejectFinalOffer.value == true
                ? const Center(child: LoadingWidget())
                : TextButton(
                    onPressed: () {
                      if (priceRequests != null && priceRequests.isNotEmpty) {
                        controller.rejectFinalOffer(id: priceRequests.last.id);
                        AppRouter.route.pop();
                      }
                    },
                    child: Text(
                      "Yes, Reject",
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
          ),
        ],
      );
    } else {
      // Show normal dialog with input fields
      AppDialog.show(
        context: context,
        title: AppStrings.rejectReason.tr,
        subtitle: 'Are you sure you want to reject this parcel?',
        type: AppDialogType.info,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: reasonController, hintText: 'Reason'),
            Gap(12.h),
            CustomTextField(
              controller: finalPriceController,
              hintText: ' Price',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppRouter.route.pop();
            },
            child: Text(AppStrings.cancel.tr),
          ),
          Gap(8.w),
          Obx(
            () => controller.loadingRejectAndCounterOffer.value == true
                ? const Center(child: LoadingWidget())
                : TextButton(
                    onPressed: () {
                      if (priceRequests == null || priceRequests.isEmpty) {
                        return;
                      }
                      final lastRequest = priceRequests.last;
                      final body = {
                        "parcel_id": lastRequest.parcelId,
                        "rejection_reason": reasonController.text,
                        "suggested_price": finalPriceController.text.isNotEmpty
                            ? double.parse(finalPriceController.text)
                            : 0.0,
                      };
                      controller.rejectAndCounterOffer(
                        id: lastRequest.id ?? "",
                        body: body,
                      );
                    },
                    child: Text(
                      AppStrings.reject.tr,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
          ),
        ],
      );
    }
  }
}
