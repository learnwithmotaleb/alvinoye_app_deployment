import 'dart:developer';

import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/controller/my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/parcel_card.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MyParcelScreen extends StatefulWidget {
  const MyParcelScreen({super.key});

  @override
  State<MyParcelScreen> createState() => _MyParcelScreenState();
}

class _MyParcelScreenState extends State<MyParcelScreen> {
  final controller = Get.find<MyParcelController>();

  @override
  void initState() {
    controller.waitingController.refresh();
    controller.pendingController.refresh();
    controller.ongoingController.refresh();
    controller.completedController.refresh();
    controller.rejectedController.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('My Parcel'),
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: TabBar(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.primaryColor,
            indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 4.h,
            ),
            labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Waiting'),
              Tab(text: 'Pending'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
              Tab(text: 'Reject'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TabBarView(
            children: [
              _buildPagedList(controller.waitingController),
              _buildPagedList(controller.pendingController),
              _buildPagedList(controller.ongoingController),
              _buildPagedList(controller.completedController),
              _buildPagedList(controller.rejectedController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagedList(PagingController<int, ParcelItem> pagingController) {
    return RefreshIndicator(
      onRefresh: () async => pagingController.refresh(),
      child: CustomScrollView(
        slivers: [
          PagedSliverList<int, ParcelItem>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<ParcelItem>(
              itemBuilder: (context, item, index) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: ParcelCardList(
                  parcel: item,
                  onTap: () {
                    log("item finalPrice --> ${item.finalPrice}");
                    if (item.status == "PENDING" ||
                        item.status == "WAITING" ||
                        item.status == "ONGOING") {
                      AppRouter.route.pushNamed(
                        RoutePath.detailsMyParcelScreen,
                        extra: item,
                      );
                    }
                  },
                  onChatTap: () {
                    controller.chatInitiateP2P(
                      id: item.acceptedBy?.id ?? "",
                      parcel: item,
                    );
                  },
                  onReviewTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.parcelOwnerReviewScreen,
                      extra: item,
                    );
                  },
                  onRefundTap: () {
                    AppRouter.route.pushNamed(RoutePath.refundScreen);
                  },
                  onTrackLiveTap: () {
                    AppRouter.route.pushNamed(
                      RoutePath.trackParcelOwnerScreen,
                      extra: item,
                    );
                  },
                ),
              ),
              firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: LoadingWidget()),
              newPageProgressIndicatorBuilder: (_) =>
                  const Center(child: LoadingWidget()),
              noItemsFoundIndicatorBuilder: (_) => Center(
                child: Text(
                  'No parcels found',
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 16.h)),
        ],
      ),
    );
  }
}
