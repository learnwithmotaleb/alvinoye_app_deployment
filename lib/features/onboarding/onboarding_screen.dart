import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/custom_image/custom_image.dart';
import 'package:delivery_app/share/widgets/custom_text/custom_text.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final _controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          _controller.currentIndex.value = index;
        },
        children: [
          OnboardingPageCard(),
          OnboardingPageCard(),
          OnboardingPageCard(),
        ],
      ),
    );
  }
}

class OnboardingPageCard extends StatelessWidget {
  final _controller = Get.find<OnboardingController>();

  OnboardingPageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16,
        bottom: 24,
        top: 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_controller.currentIndex.value > 0) {
                        _controller.currentIndex.value--;
                      }
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        AppRouter.route.goNamed(RoutePath.loginScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: "Skip",
                          fontSize: 16,
                          // Bigger text for tablets
                          fontWeight: FontWeight.w700,
                          color: AppColors.greenTextColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Obx(() {
            return CustomImage(
              width: width,
              height: 235,
              fit: BoxFit.fill,
              imageSrc: _controller
                  .onboardingList[_controller.currentIndex.value]
                  .image,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => buildDot(index, context)),
          ),
          Obx(() {
            return Text(
              _controller.onboardingList[_controller.currentIndex.value].title,
              style: context.bodyLarge,
              textAlign: TextAlign.center,
            );
          }),
          Obx(() {
            return Text(
              _controller.onboardingList[_controller.currentIndex.value].title,
              style: context.labelLarge,
              textAlign: TextAlign.center,
            );
          }),

          SizedBox(height: 12),

          Obx(() {
            return CustomButton(
              onTap: () {
                if (_controller.currentIndex.value < 2) {
                  _controller.currentIndex.value =
                      _controller.currentIndex.value + 1;
                } else {
                  AppRouter.route.goNamed(RoutePath.loginScreen);
                }
              },
              text: _controller.currentIndex.value >= 2
                  ? "Get Started"
                  : 'Next',
            );
          }),
        ],
      ),
    );
  }

  Padding buildDot(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Obx(() {
        return Container(
          height: 6,
          width: _controller.currentIndex.value == index ? 24 : 6,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _controller.currentIndex.value == index
                ? AppColors.primaryColor
                : AppColors.blueTextColor400,
          ),
        );
      }),
    );
  }
}
