import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/features/parcel_owner/payment/controller/payment_controller.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final ParcelItem parcel;
  const PaymentScreen({super.key, required this.parcel});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'online';
  final PaymentController _paymentController = Get.put(PaymentController());

  Future<void> _onProceedToPay() async {
    final parcelId = widget.parcel.id;
    if (parcelId == null || parcelId.isEmpty) {
      AppToast.error(message: 'Invalid parcel');
      return;
    }

    // 1) Create the DPO transaction and get the hosted payment URL.
    final url = await _paymentController.createCheckout(parcelId);
    if (url == null) return;
    if (!mounted) return;

    // 2) Open the payment page in an in-app WebView and await the outcome.
    final result = await AppRouter.route.pushNamed(
      RoutePath.dpoWebviewScreen,
      extra: url,
    );

    // 3) Verify server-to-server regardless of the reported result.
    final paid = await _paymentController.verify(parcelId);
    if (!mounted) return;

    if (paid) {
      AppToast.success(message: 'Payment successful');
      AppRouter.route.goNamed(RoutePath.parcelOwnerNavScreen, extra: 1);
    } else {
      AppToast.error(
        message: result == 'cancel'
            ? 'Payment was cancelled'
            : 'Payment not completed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the final price, default to 0 if null
    final price = double.tryParse('${widget.parcel.finalPrice}') ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.paymentOption.tr),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 20.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Parcel Info Card
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Parcel Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: SizedBox(
                              height: 80.h,
                              width: 80.w,
                              child:
                                  widget.parcel.parcelImages != null &&
                                      widget.parcel.parcelImages!.isNotEmpty
                                  ? CustomNetworkImage(
                                      imageUrl:
                                          widget.parcel.parcelImages!.first,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: AppColors.grayTabBgColor,
                                      child: Icon(
                                        Icons.inventory_2_outlined,
                                        color: AppColors.grayTextSecondaryColor,
                                        size: 32.sp,
                                      ),
                                    ),
                            ),
                          ),
                          Gap(12.w),
                          // Parcel Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  AppStrings.parcelId.tr,
                                  widget.parcel.parcelId ?? 'N/A',
                                ),
                                Gap(4.h),
                                _buildInfoRow(
                                  AppStrings.parcelName.tr,
                                  widget.parcel.parcelName ?? 'N/A',
                                ),
                                Gap(4.h),
                                _buildInfoRow(
                                  'Delivery Address',
                                  widget.parcel.handoverLocation?.address ??
                                      'N/A',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Total Amount Section
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.totalAmount.tr,
                            style: context.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.grayTextSecondaryColor,
                            ),
                          ),
                          Gap(8.h),
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: context.headlineLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Payment Method Selection
                    Text(
                      AppStrings.selectPaymentSystem.tr,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackMainTextColor,
                      ),
                    ),
                    Gap(12.h),

                    // Online Payment Option
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: selectedPaymentMethod == 'online'
                              ? AppColors.primaryColor
                              : AppColors.linesDarkColor,
                          width: selectedPaymentMethod == 'online' ? 2 : 1,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: 'online',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                        title: Row(
                          children: [
                            Icon(
                              Icons.credit_card,
                              color: selectedPaymentMethod == 'online'
                                  ? AppColors.primaryColor
                                  : AppColors.grayTextSecondaryColor,
                              size: 24.sp,
                            ),
                            Gap(12.w),
                            Text(
                              AppStrings.onlinePayment.tr,
                              style: context.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: selectedPaymentMethod == 'online'
                                    ? AppColors.primaryColor
                                    : AppColors.blackMainTextColor,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(left: 36.w, top: 4.h),
                          child: Text(
                            'Pay securely with card / bank (DPO)',
                            style: context.bodySmall.copyWith(
                              color: AppColors.grayTextSecondaryColor,
                            ),
                          ),
                        ),
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                      ),
                    ),

                    Gap(12.h),

                    // Cash Payment Option (Disabled for design)
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.linesDarkColor,
                            width: 1,
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: 'cash',
                          groupValue: selectedPaymentMethod,
                          onChanged: null, // Disabled
                          title: Row(
                            children: [
                              Icon(
                                Icons.money,
                                color: AppColors.grayTextSecondaryColor,
                                size: 24.sp,
                              ),
                              Gap(12.w),
                              Flexible(
                                child: Text(
                                  'Cash on Delivery',
                                  style: context.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grayTextSecondaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Gap(8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grayTabBgColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Coming Soon',
                                  style: context.bodySmall.copyWith(
                                    fontSize: 10.sp,
                                    color: AppColors.grayTextSecondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(left: 36.w, top: 4.h),
                            child: Text(
                              'Pay when you receive',
                              style: context.bodySmall.copyWith(
                                color: AppColors.grayTextSecondaryColor,
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Proceed to Pay Button
            Obx(
              () => CustomButton(
                isLoading:
                    _paymentController.isCreating.value ||
                    _paymentController.isVerifying.value,
                onTap: _onProceedToPay,
                text: AppStrings.proceedToPay.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: value,
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.grayTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
