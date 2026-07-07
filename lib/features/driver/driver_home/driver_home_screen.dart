import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/driver/driver_home/controller/driver_home_controller.dart';
import 'package:delivery_app/features/driver/driver_home/model/driver_home_model.dart';
import 'package:delivery_app/features/driver/driver_home/widgets/driver_header.dart';
import 'package:delivery_app/features/driver/driver_home/widgets/driver_request_card.dart';
import 'package:delivery_app/features/driver/driver_home/widgets/stat_card.dart';
import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart'
    as driver_parcel;
import 'package:delivery_app/features/parcel_owner/my_parcel/controller/my_parcel_controller.dart';
import 'package:delivery_app/features/profile/controller/profile_controller.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final DriverHomeController controller = Get.find();
  final ProfileController profileController = Get.find();
  @override
  void initState() {
    super.initState();
    controller.pagingController.refresh();
    profileController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            // Header
            Obx(
              () => SliverToBoxAdapter(
                child: DriverHeader(
                  userName:
                      profileController.profile.value.data?.fullName ??
                      "Alviniloyun",
                  profileImageUrl:
                      profileController.profile.value.data?.profilePicture ??
                      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
                  onNotificationTap: () {
                    AppRouter.route.pushNamed(RoutePath.notificationScreen);
                  },
                ),
              ),
            ),

            // Stats and Title
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.map_outlined,
                            title: AppStrings.activeRoutes.tr,
                            iconColor: AppColors.primaryColor,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: StatCard(
                            icon: Icons.monetization_on_outlined,
                            title: "${AppStrings.earning.tr} \$125",
                            iconColor: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Gap(24.h),
                    Text(
                      AppStrings.yourRecentRequest.tr,
                      style: context.headlineSmall.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    Gap(10.h),
                  ],
                ),
              ),
            ),

            // ── REST paginated list (fallback / scroll) ────────────────
            PagedSliverList<int, ParcelInformation>(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ParcelInformation>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Obx(
                      () => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.parcelDetailsScreen,
                            extra: item,
                          );
                        },
                        child: DriverRequestCard(
                          parcelId: item.parcelId ?? "N/A",
                          parcelName: item.parcelName ?? "N/A",
                          size: item.size ?? "N/A",
                          price: "\$${item.finalPrice ?? 0}",
                          imageUrl:
                              (item.parcelImages != null &&
                                  item.parcelImages!.isNotEmpty)
                              ? item.parcelImages!.first
                              : "",
                          isLoading:
                              controller.acceptLoadingMap[item.id ?? ''] ==
                              true,
                          onImageTap: () {
                            AppRouter.route.pushNamed(
                              RoutePath.parcelDetailsScreen,
                              extra: item,
                            );
                          },
                          onTrackTap: () {
                            final driverParcelItem =
                                driver_parcel.DriverParcelItem(
                                  id: item.id,
                                  parcelId: item.parcelId,
                                  parcelName: item.parcelName,
                                  size: item.size,
                                  vehicleType: item.vehicleType,
                                  weight: item.weight?.toDouble(),
                                  pickupLocation: item.pickupLocation != null
                                      ? driver_parcel.Location(
                                          address: item.pickupLocation!.address,
                                          latitude:
                                              item.pickupLocation!.latitude,
                                          longitude:
                                              item.pickupLocation!.longitude,
                                        )
                                      : null,
                                  handoverLocation:
                                      item.handoverLocation != null
                                      ? driver_parcel.Location(
                                          address:
                                              item.handoverLocation!.address,
                                          latitude:
                                              item.handoverLocation!.latitude,
                                          longitude:
                                              item.handoverLocation!.longitude,
                                        )
                                      : null,
                                  priority: item.priority,
                                  date: item.date,
                                  time: item.time,
                                  parcelImages: item.parcelImages,
                                  receiverName: item.receiverName,
                                  receiverPhone: item.receiverPhone,
                                  senderRemarks: item.senderRemarks,
                                  status: item.status,
                                  finalPrice: item.finalPrice,
                                  priceStatus: item.priceStatus,
                                  rejectionReason: item.rejectionReason,
                                  acceptedBy: item.acceptedBy,
                                  acceptedAt: item.acceptedAt,
                                  completedAt: item.completedAt,
                                  stripeCheckoutSessionId:
                                      item.stripeCheckoutSessionId,
                                  createdAt: item.createdAt,
                                  updatedAt: item.updatedAt,
                                  datumId: item.id,
                                );
                            AppRouter.route.pushNamed(
                              RoutePath.trackParcelScreen,
                              extra: driverParcelItem,
                            );
                          },
                          onChatTap: () {
                            MyParcelController.to.chatInitiateP2P(
                              id: item.userId ?? "",
                              parcel: item,
                            );
                          },
                          onAcceptTap: () {
                            controller.acceptParcel(id: item.id ?? "");
                          },
                        ),
                      ),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (context) => NoInternetCard(
                  onTap: () => controller.pagingController.refresh(),
                ),
                noItemsFoundIndicatorBuilder: (context) => NoDataCard(
                  onTap: () => controller.pagingController.refresh(),
                ),
                firstPageProgressIndicatorBuilder: (context) =>
                    const LoadingWidget(),
                newPageProgressIndicatorBuilder: (context) =>
                    const LoadingWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
