import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Widget makeDismissable({required Widget child}) => GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () => Get.back(),
  child: GestureDetector(onTap: () {}, child: child),
);

void showYesNoModal(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmButtonText,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return ConfirmationModalBottomSheet(
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        onConfirm: onConfirm,
      );
    },
  );
}
// ---------------------------------------------

class ConfirmationModalBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final VoidCallback onConfirm;

  const ConfirmationModalBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode
        ? AppColors.white
        : AppColors.blackMainTextColor;

    return makeDismissable(
      child: DraggableScrollableSheet(
        // initialChildSize: 0.40,
        // minChildSize: 0.25,
        // maxChildSize: 0.4,
        initialChildSize: 0.45,
        minChildSize: 0.25,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: Assets.icons.vector.svg()),
                  Gap(24),
                  Text(
                    title,
                    style: context.headlineSmall.copyWith(
                      color: primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(12),
                  Text(
                    message,
                    style: context.bodyMedium.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(36),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Back'.tr,
                          onTap: () => AppRouter.route.pop(),
                        ),
                      ),
                      Gap(16),
                      Expanded(
                        child: CustomButton(
                          text: confirmButtonText,
                          onTap: () {
                            onConfirm();
                            AppRouter.route.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
