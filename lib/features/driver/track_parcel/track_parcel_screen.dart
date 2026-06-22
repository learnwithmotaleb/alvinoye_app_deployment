import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/driver/track_parcel/controller/track_parcel_controller.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class TrackParcelScreen extends StatefulWidget {
  final DriverParcelItem parcelItem;
  const TrackParcelScreen({super.key, required this.parcelItem});

  @override
  State<TrackParcelScreen> createState() => _TrackParcelScreenState();
}

class _TrackParcelScreenState extends State<TrackParcelScreen> {
  late final TrackParcelController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TrackParcelController(parcelItem: widget.parcelItem));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDetailsBottomSheet(context);
    });
  }

  @override
  void dispose() {
    Get.delete<TrackParcelController>();
    super.dispose();
  }

  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      enableDrag: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Parcel Info
                Text(
                  "Parcel Info",
                  style: context.bodyMedium.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  widget.parcelItem.parcelName ?? 'N/A',
                  style: context.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Gap(20.h),

                // Progress Bar
                _buildProgressBar(context),
                Gap(24.h),

                // Pickup Location
                Text(
                  "Pickup Location",
                  style: context.titleMedium.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.h),
                RichText(
                  text: TextSpan(
                    style: context.bodySmall.copyWith(color: Colors.black87),
                    children: [
                      TextSpan(
                        text:
                            widget.parcelItem.pickupLocation?.address ?? 'N/A',
                        style: context.bodySmall.copyWith(
                          color: AppColors.grayTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(24.h),

                // Handover Location
                Text(
                  "Handover Location",
                  style: context.titleMedium.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.h),
                RichText(
                  text: TextSpan(
                    style: context.bodySmall.copyWith(color: Colors.black87),
                    children: [
                      TextSpan(
                        text:
                            widget.parcelItem.handoverLocation?.address ??
                            'N/A',
                        style: context.bodySmall.copyWith(
                          color: AppColors.grayTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Positioned.fill(
            child: Obx(() {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: controller.initialCameraPosition,
                markers: controller.markers.toSet(),
                polylines: controller.polylines.toSet(),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  if (!controller.googleMapController.isCompleted) {
                    controller.googleMapController.complete(mapController);
                  }
                },
              );
            }),
          ),

          // Custom AppBar
          Positioned(
            top: 50.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    AppRouter.route.pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_back, size: 24.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Track Parcel",
                    textAlign: TextAlign.center,
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDetailsBottomSheet(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.info_outline, color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            Gap(4.w),
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            Gap(4.w),
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
          ],
        ),
        Gap(8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Picked Up",
              style: context.bodySmall.copyWith(color: Colors.black54),
            ),
            Text(
              "On The Way",
              style: context.bodySmall.copyWith(color: Colors.black54),
            ),
            Text(
              "Delivery Point",
              style: context.bodySmall.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
