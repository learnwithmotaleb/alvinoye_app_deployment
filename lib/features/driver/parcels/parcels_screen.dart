import 'package:delivery_app/features/driver/parcels/widgets/parcel_list.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class ParcelsScreen extends StatefulWidget {
  const ParcelsScreen({super.key});

  @override
  State<ParcelsScreen> createState() => _ParcelsScreenState();
}

class _ParcelsScreenState extends State<ParcelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Parcels"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(4.w),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.grayTextSecondaryColor,
                labelStyle: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                tabs: [_buildTab("Ongoing", 0), _buildTab("Completed", 1)],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ParcelList(status: "Ongoing"),
                ParcelList(status: "Completed"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Icon(
                index == 0 ? Icons.local_shipping : Icons.check_circle,
                size: 18.sp,
                color: Colors.white,
              ),
            if (isSelected) SizedBox(width: 6.w),
            Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
