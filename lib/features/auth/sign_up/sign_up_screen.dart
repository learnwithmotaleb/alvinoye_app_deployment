import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController nameSignUp = TextEditingController();
  final TextEditingController emailSignUp = TextEditingController();
  final TextEditingController passwordSignUp = TextEditingController();
  final TextEditingController confirmPasswordSignUp = TextEditingController();
  bool _isTermsAccepted = false;
  @override
  void dispose() {
    nameSignUp.dispose();
    emailSignUp.dispose();
    passwordSignUp.dispose();
    confirmPasswordSignUp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.ntsamaela.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                /// ---------- MAIN TITLE ----------
                Text(
                  AppStrings.createYourAccount.tr,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall,
                ),
                Gap(6),

                /// ---------- SUBTITLE ----------
                Text(
                  AppStrings.signUpTitle.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),
                Gap(26),

                /// ---------- Name ----------
                CustomTextField(
                  title: AppStrings.fullName.tr,
                  hintText: AppStrings.enterYourName.tr,
                  keyboardType: TextInputType.name,
                  controller: nameSignUp,
                  validator: TextFieldValidator.name(),
                ),
                Gap(14),

                /// ---------- Email ----------
                CustomTextField(
                  title: AppStrings.email.tr,
                  hintText: AppStrings.enterYourEmail.tr,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailSignUp,
                  prefixIcon: const Icon(Icons.mail_outline),
                  validator: TextFieldValidator.email(),
                ),
                Gap(14),

                /// ---------- Password ----------
                CustomTextField(
                  title: AppStrings.password.tr,
                  hintText: AppStrings.enterYourPassword.tr,
                  prefixIcon: const Icon(Icons.lock_outline),
                  controller: passwordSignUp,
                  isPassword: true,
                  validator: TextFieldValidator.password(),
                ),
                Gap(14),

                /// ---------- Confirm Password ----------
                CustomTextField(
                  title: AppStrings.confirmPassword.tr,
                  hintText: AppStrings.confirmPassword.tr,
                  prefixIcon: const Icon(Icons.lock_outline),
                  controller: confirmPasswordSignUp,
                  isPassword: true,
                  validator: TextFieldValidator.password(),
                ),
                Gap(14),

                /// ---------- Terms & Conditions ----------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _isTermsAccepted,
                        activeColor: AppColors.greenTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          setState(() => _isTermsAccepted = val ?? false);
                        },
                      ),
                    ),
                    Gap(8),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            'I agree to the ',
                            style: context.textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () {
                              AppRouter.route.pushNamed(
                                RoutePath.termsAndConditionsScreen,
                              );
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Terms & Conditions'),
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      'By using this application, you agree to our Terms and Conditions. '
                                      'You must be at least 18 years old to use this service. '
                                      'We reserve the right to modify these terms at any time. '
                                      'Your continued use of the app constitutes acceptance of any changes.',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: AppColors.greenTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              'Terms & Conditions',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greenTextColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.greenTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Gap(24),

                /// ---------- Register Button ----------
                Obx(
                  () => CustomButton(
                    isLoading: _auth.signUpLoading.value,
                    text: AppStrings.signUp.tr,
                    onTap: () {
                      if (!_isTermsAccepted) {
                        AppToast.error(
                          message:
                              'Please accept the Terms & Conditions to continue.',
                        );
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        _auth.signUp(
                          nameSignUp: nameSignUp.text,
                          emailSignUp: emailSignUp.text,
                          passwordSignUp: passwordSignUp.text,
                        );
                      }
                    },
                  ),
                ),

                Gap(26),

                /// ---------- Divider + Text ----------
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: AppColors.grayTextSecondaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        AppStrings.signInWith.tr,
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: AppColors.grayTextSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Gap(26),

                /// ---------- Social Icons ----------
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
                Gap(34),

                /// ---------- Already Have Account ----------
                Text(
                  AppStrings.dontHaveAnAccount.tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Gap(4),
                GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.loginScreen),
                  child: Text(
                    AppStrings.signIn.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.greenTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gap(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
