import 'package:delivery_app/features/chatList/controller/chat_list_controller.dart';
import 'package:delivery_app/features/driver/driver_home/controller/driver_home_controller.dart';
import 'package:delivery_app/features/driver/parcels/controller/parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/controller/parcel_owner_home_controller.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/features/onboarding/controller/onboarding_controller.dart';
import 'package:delivery_app/features/other/controller/other_controller.dart';
import 'package:delivery_app/share/controller/language_controller.dart';
import 'package:delivery_app/utils/common_controller/common_controller.dart';
import 'package:delivery_app/features/chat/controller/chat_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/controller/my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/refund/controller/refund_controller.dart';
import 'package:delivery_app/features/profile/controller/profile_controller.dart';
import 'package:delivery_app/features/parcel_owner/payment/controller/payment_controller.dart';
import 'package:delivery_app/features/driver/wallet/controller/wallet_controller.dart';

void initGetx() {
  //Auth
  Get.lazyPut(() => LanguageController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);

  //Others
  Get.lazyPut(() => OtherController(), fenix: true);
  Get.lazyPut(() => OnboardingController(), fenix: true);
  Get.lazyPut(() => CommonController(), fenix: true);

  //Chat
  Get.lazyPut(() => ChatController(), fenix: true);
  Get.lazyPut(() => ChatListController(), fenix: true);
  //Driver

  //Parcel Owner
  Get.lazyPut(() => MyParcelController(), fenix: true);
  Get.lazyPut(() => RefundController(), fenix: true);

  //Profile
  Get.lazyPut(() => ProfileController(), fenix: true);

  //Parcel Owner Home
  Get.lazyPut(() => ParcelOwnerHomeController(), fenix: true);

  //Driver
  Get.lazyPut(() => ParcelController(), fenix: true);

  //Driver Home
  Get.lazyPut(() => DriverHomeController(), fenix: true);

  //Payment
  Get.lazyPut(() => PaymentController(), fenix: true);

  //Wallet
  Get.lazyPut(() => WalletController(), fenix: true);
}
