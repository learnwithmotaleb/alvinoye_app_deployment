import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/align/custom_align_text.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/custom_image/custom_image.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailSignIn = .new();
  final TextEditingController passwordSignIn = .new();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (kDebugMode) {
      emailSignIn.text = "parcel_owner@yopmail.com";
      passwordSignIn.text = "123456a";
    }
    return Scaffold(
      // appBar: AppBar(
      //   scrolledUnderElevation: 0,
      //   centerTitle: true,
      //   title: Text(
      //     AppStrings.ntsamaela.tr,
      //     style: Theme.of(
      //       context,
      //     ).textTheme.headlineSmall?.copyWith(color: AppColors.primaryColor),
      //   ),
      // ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 199.h,
                        width: double.infinity,
                        color: AppColors.primaryColor,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomImage(
                                imageSrc: Assets.images.simage.path,
                              ),
                            ),
                            Positioned(
                              left: 70,
                              bottom: 0,
                              child: Assets.icons.slogo.svg(width: 60.w),
                            ),
                          ],
                        ),
                      ),
                      Gap(56),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              AppStrings.signIn.tr,
                              style: context.titleLarge,
                            ),
                            Gap(8),
                            Text(
                              "Welcome Back, You've been missed.",
                              style: context.bodyMedium,
                            ),
                            Gap(24),
                            CustomTextField(
                              controller: emailSignIn,
                              title: AppStrings.email.tr,
                              hintText: AppStrings.enterYourEmail.tr,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.mail_outline_outlined),
                              validator: TextFieldValidator.email(),
                            ),
                            Gap(14),
                            CustomTextField(
                              controller: passwordSignIn,
                              title: AppStrings.password.tr,
                              hintText: AppStrings.enterYourPassword.tr,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.lock_outline),
                              isPassword: true,
                              validator: TextFieldValidator.password(),
                            ),
                            Gap(14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                GestureDetector(
                                  onTap: () => AppRouter.route.pushNamed(
                                    RoutePath.forgetPasswordScreen,
                                  ),
                                  child: CustomAlignText(
                                    text: AppStrings.forgotPassword.tr,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                            Gap(28),
                            Obx(
                              () => CustomButton(
                                isLoading: _auth.signInLoading.value,
                                text: AppStrings.signIn.tr,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    _auth.signIn(
                                      email: emailSignIn.text,
                                      password: passwordSignIn.text,
                                    );
                                  }
                                },
                              ),
                            ),
                            Gap(32),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.grayTextSecondaryColor,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    AppStrings.signInWith.tr,
                                    style: context.titleLarge,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.grayTextSecondaryColor,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            Gap(24),

                            /// ----------- SOCIAL ICONS ------------

                            /*
                             Row(
                              spacing: 24,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.blueTextColor400,
                                    ),
                                  ),
                                  child: Assets.icons.google.svg(width: 22),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.blueTextColor400,
                                    ),
                                  ),
                                  child: Assets.icons.facebook.svg(width: 22),
                                ),
                              ],
                            ),
                            */
                            Gap(32),
                          ],
                        ),
                      ),

                      /// ----------- New Here + Register ----------
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAnAccount.tr,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),

                            GestureDetector(
                              onTap: () => AppRouter.route.pushNamed(
                                RoutePath.vendorSelectionScreen,
                              ),
                              child: Text(
                                AppStrings.signUp.tr,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? AppColors.white
                                          : AppColors.greenTextColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 155,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: AppColors.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      shape: BoxShape.rectangle,
                      color: AppColors.white,
                    ),
                    child: Assets.images.splashmainlogo.image(
                      height: 70.h,
                      width: 70.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
