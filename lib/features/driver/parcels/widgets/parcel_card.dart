import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/driver/parcels/controller/parcel_controller.dart';
import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ParcelCard extends StatelessWidget {
  final DriverParcelItem parcelItem;
  final String parcelMainId;
  final String status;
  final String parcelId;
  final String parcelName;
  final String size;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onChatTap;
  final bool isLoadingChat;

  const ParcelCard({
    super.key,
    required this.parcelItem,
    required this.parcelMainId,
    required this.status,
    required this.parcelId,
    required this.parcelName,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.onTap,
    required this.onChatTap,
    this.isLoadingChat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.only(
              left: 12.r,
              right: 12.r,
              top: 24.r,
              bottom: 12.r,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CustomNetworkImage(
                          imageUrl: imageUrl,
                          width: 100.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Parcel ID", parcelId),
                            _buildDetailRow("Parcel Name", parcelName),
                            _buildDetailRow("Size", size),
                            _buildDetailRow("Price", "\$$price"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(12.h),
                // Actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildFirstRowButtons(context),
                      ),
                    ),
                    Gap(8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: _buildSecondRowButtons(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Status Badge - Positioned at top-right corner
        Positioned(top: 0, right: 0, child: _buildStatusBadge(status)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.normal,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String statusText;

    if (status == "Ongoing") {
      badgeColor = AppColors.orangeSecondaryAccentColorNormal;
      statusText = 'Ongoing Parcel';
    } else {
      // Completed
      badgeColor = AppColors.success;
      statusText = 'Completed';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.r),
          bottomLeft: Radius.circular(12.r),
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildFirstRowButtons(BuildContext context) {
    final buttons = <Widget>[
      _ActionButton(
        label: isLoadingChat ? "Loading..." : "Chat",
        icon: isLoadingChat ? Icons.hourglass_empty : Icons.chat_bubble_outline,
        isOutlined: true,
        color: AppColors.primaryColor,
        onTap: isLoadingChat ? () {} : onChatTap,
      ),
    ];

    if (status == "Ongoing") {
      buttons.addAll([
        Gap(8.w),
        _ActionButton(
          label: "Track Live",
          icon: Icons.location_on,
          isOutlined: true,
          color: Colors.red,
          onTap: () {
            AppRouter.route.pushNamed(
              RoutePath.trackParcelScreen,
              extra: parcelItem,
            );
          },
        ),
        Gap(8.w),
        _ActionButton(
          label: "Confirm",
          icon: Icons.check_circle_outline,
          isOutlined: true,
          color: Colors.green,
          onTap: () {
            AppRouter.route.pushNamed(
              RoutePath.parcelOtpScreen,
              extra: parcelMainId,
            );
          },
        ),
      ]);
    }

    return buttons;
  }

  List<Widget> _buildSecondRowButtons(BuildContext context) {
    if (status != "Ongoing") return [];

    final controller = ParcelController.to;

    return [
      Obx(
        () => _ActionButton(
          label: controller.isResendOtpLoading(parcelMainId)
              ? "Sending..."
              : "Resend OTP",

          icon: controller.isResendOtpLoading(parcelMainId)
              ? Icons.hourglass_empty
              : Icons.refresh,

          isOutlined: true,

          color: Colors.orange,

          onTap: controller.isResendOtpLoading(parcelMainId)
              ? () {}
              : () => controller.resendDriverOtp(parcelId: parcelMainId),
        ),
      ),
    ];
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    final controller = ParcelController.to;
    List<Widget> buttons = [];

    // Chat button - available for both statuses
    buttons.add(
      _ActionButton(
        label: isLoadingChat ? "Loading..." : "Chat",
        icon: isLoadingChat ? Icons.hourglass_empty : Icons.chat_bubble_outline,
        isOutlined: true,
        color: AppColors.primaryColor,
        onTap: isLoadingChat ? () {} : onChatTap,
      ),
    );
    buttons.add(Gap(8.w));

    // Ongoing specific buttons
    if (status == "Ongoing") {
      buttons.add(
        _ActionButton(
          label: "Track Live",
          icon: Icons.location_on,
          isOutlined: true,
          color: Colors.red,
          onTap: () {
            AppRouter.route.pushNamed(
              RoutePath.trackParcelScreen,
              extra: parcelItem,
            );
          },
        ),
      );
      buttons.add(Gap(8.w));
      buttons.add(
        Obx(
          () => _ActionButton(
            label: controller.isResendOtpLoading(parcelMainId)
                ? "Sending..."
                : "Resend OTP",
            icon: controller.isResendOtpLoading(parcelMainId)
                ? Icons.hourglass_empty
                : Icons.refresh,
            isOutlined: true,
            color: Colors.orange,
            onTap: controller.isResendOtpLoading(parcelMainId)
                ? () {}
                : () {
                    controller.resendDriverOtp(parcelId: parcelMainId);
                  },
          ),
        ),
      );

      buttons.add(Gap(8.w));
      buttons.add(Gap(8.w));
      buttons.add(
        _ActionButton(
          label: "Confirm",
          icon: Icons.check_circle_outline,
          isOutlined: true,
          color: Colors.green,
          onTap: () {
            print("parcelMainId: $parcelMainId");
            AppRouter.route.pushNamed(
              RoutePath.parcelOtpScreen,
              extra: parcelMainId,
            );
          },
        ),
      );
    }

    return buttons;
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final bool isOutlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    this.icon,
    required this.color,
    this.isOutlined = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(8.r),
          border: isOutlined ? Border.all(color: color) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.r, color: isOutlined ? color : Colors.white),
              Gap(4.w),
            ],
            Text(
              label,
              style: context.bodyMedium.copyWith(
                fontSize: 16.sp,
                color: isOutlined ? color : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
