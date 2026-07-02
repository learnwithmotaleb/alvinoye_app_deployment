import 'package:delivery_app/features/driver/wallet/controller/wallet_controller.dart';
import 'package:delivery_app/features/driver/wallet/model/wallet_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletController controller = Get.put(WalletController());

  @override
  void initState() {
    super.initState();
    controller.getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Wallet'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshAll(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: Text(
                  'Transaction History',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            PagedSliverList<int, WalletTransaction>(
              pagingController: controller.transactionController,
              builderDelegate: PagedChildBuilderDelegate<WalletTransaction>(
                itemBuilder: (context, item, index) => _buildTxRow(item),
                noItemsFoundIndicatorBuilder: (context) => Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Center(
                    child: Text(
                      'No transactions yet',
                      style: context.bodyMedium.copyWith(
                        color: AppColors.grayTextSecondaryColor,
                      ),
                    ),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Padding(padding: EdgeInsets.all(24), child: LoadingWidget()),
              ),
            ),
            SliverToBoxAdapter(child: Gap(20.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      if (controller.status.value == ApiStatus.loading &&
          controller.wallet.value == null) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: const LoadingWidget(),
        );
      }

      final w = controller.wallet.value;
      final currency = w?.currency ?? '';
      final available = w?.availableBalance ?? 0;
      final pending = w?.pendingBalance ?? 0;

      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available balance card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: context.bodyMedium.copyWith(color: AppColors.white),
                  ),
                  Gap(6.h),
                  Text(
                    '$currency ${available.toStringAsFixed(2)}',
                    style: context.headlineLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.h),
            // Pending + totals
            Row(
              children: [
                Expanded(
                  child: _miniStat(
                    'Pending',
                    '$currency ${pending.toStringAsFixed(2)}',
                    AppColors.orangeSecondaryAccentColor,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: _miniStat(
                    'Total Earned',
                    '$currency ${(w?.totalEarned ?? 0).toStringAsFixed(2)}',
                    AppColors.success,
                  ),
                ),
              ],
            ),
            Gap(8.h),
            Text(
              'Pending earnings become available for withdrawal after the weekly distribution (every Sunday).',
              style: context.bodySmall.copyWith(
                color: AppColors.grayTextSecondaryColor,
              ),
            ),
            Gap(16.h),
            CustomButton(
              text: 'Withdraw',
              onTap: () => _onWithdrawTap(available, currency),
            ),
          ],
        ),
      );
    });
  }

  Widget _miniStat(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          Text(
            label,
            style: context.bodySmall.copyWith(
              color: AppColors.grayTextSecondaryColor,
            ),
          ),
          Gap(4.h),
          Text(
            value,
            style: context.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTxRow(WalletTransaction tx) {
    final isCredit =
        tx.type == 'EARNING' ||
        tx.type == 'DISTRIBUTION' ||
        tx.type == 'WITHDRAWAL_REVERSAL';
    final sign = isCredit ? '+' : '-';
    final color = isCredit ? AppColors.success : AppColors.redColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _typeLabel(tx.type),
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (tx.description.isNotEmpty) ...[
                  Gap(2.h),
                  Text(
                    tx.description,
                    style: context.bodySmall.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (tx.createdAt != null) ...[
                  Gap(2.h),
                  Text(
                    _formatDate(tx.createdAt!),
                    style: context.bodySmall.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '$sign${tx.amount.toStringAsFixed(2)}',
            style: context.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'EARNING':
        return 'Delivery earning';
      case 'DISTRIBUTION':
        return 'Earnings distributed';
      case 'WITHDRAWAL':
        return 'Withdrawal';
      case 'WITHDRAWAL_REVERSAL':
        return 'Withdrawal refunded';
      default:
        return type;
    }
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  void _onWithdrawTap(double available, String currency) {
    if (available <= 0) {
      AppToast.info(
        message:
            'No available balance yet. Pending earnings become withdrawable after the weekly distribution (Sunday).',
      );
      return;
    }

    final amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Withdraw',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap(4.h),
              Text(
                'Available: $currency ${available.toStringAsFixed(2)}',
                style: context.bodySmall.copyWith(
                  color: AppColors.grayTextSecondaryColor,
                ),
              ),
              Gap(16.h),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              Gap(16.h),
              Obx(
                () => CustomButton(
                  isLoading: controller.isWithdrawing.value,
                  text: 'Confirm Withdraw',
                  onTap: () {
                    final amount = double.tryParse(amountController.text.trim());
                    if (amount == null || amount <= 0) {
                      AppToast.error(message: 'Enter a valid amount');
                      return;
                    }
                    if (amount > available) {
                      AppToast.error(message: 'Amount exceeds available balance');
                      return;
                    }
                    Navigator.of(ctx).pop();
                    controller.requestWithdraw(amount);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
