import 'package:delivery_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;
  // static String socketUrl() => 'http://13.63.95.203:5000';
  static String socketUrl() => 'http://10.10.28.192:5000';
  static String login() => '$base/v1/auth/login';
  static String register() => '$base/v1/auth/register';
  static String verifyOtp() => '$base/v1/auth/verify-otp';
  static String resendOtp() => '$base/v1/auth/resend-otp';
  static String forgotPassword() => '$base/v1/auth/forget-password';
  static String resetPassword() => '$base/v1/auth/reset-password';
  // =========== Customer Api Urls ===========
  static String getProfile() => '$base/v1/user/get-me';
  static String updateProfile() => '$base/v1/user/update-me';
  // =========== Parcel Owner Api Urls ===========
  static String getHomeData({required String status, required int page}) =>
      '$base/v1/parcel/get-my-parcels?status=$status&page=$page&limit=10';
  static String createParcel() => '$base/v1/parcel/create';
  static String createDetailsParcel({required String id}) =>
      '$base/v1/parcel/get/$id';
  static String getDeliveryPrice({required String id}) =>
      '$base/v1/parcel/request-for-price/$id';
  static String rejectAndCounterOffer({required String id}) =>
      '$base/v1/parcel/reject-and-counter/$id';
  static String rejectFinalOffer({required String id}) =>
      '$base/v1/parcel/reject-price/$id';
  static String acceptFinalOffer({required String id}) =>
      '$base/v1/parcel/accept-price/$id';
  static String getParcelOwnerReview({required int pageKey}) =>
      '$base/v1/review/get-driver-review?page=$pageKey&limit=10';
  static String createReview() => '$base/v1/review/create';
  static String getReview() => '$base/v1/review/get-customer-review';
  static String verifyParcelOtp() => '$base/v1/driver/parcel/verify-otp';

  //============== Settting===================

  static String changePassword() => '$base/v1/auth/change-password';
  static String termsConditions() => '$base/v1/settings/terms/get';
  static String privacyPolicy() => '$base/v1/settings/privacy/get';
  static String faq() => '$base/v1/settings/faq/get-all';
  static String logout() => '$base/v1/auth/logout';

  //============== Driver===================

  static String getDriverInfo() => '$base/v1/driver/get-driver-info';
  static String updateDriverInfo() => '$base/v1/driver/update-info';
  static String registerDriver() => '$base/v1/driver/info';
  static String getDriverParcels({
    required int page,
    required double currentLat,
    required double currentLng,
  }) =>
      '$base/v1/driver/available-for-driver?page=$page&limit=10&currentLat=$currentLat&currentLng=$currentLng';

  static String getParcelDetails({required String id}) =>
      '$base/v1/parcel/get/$id';

  static String getConversation({required int pageKey}) =>
      '$base/v1/chat/my-chats?page=$pageKey&limit=10';

  static String getMessageForChat({required int pageKey, required String id}) =>
      '$base/v1/chat/messages/$id?page=$pageKey&limit=10';

  static String sendMessage() => '$base/v1/chat/send';
  static String readTheMessage({required String id}) =>
      '$base/v1/chat/mark-as-read/$id';
  static String getNotification({required int pageKey}) =>
      '$base/v1/notifications/get-all?page=$pageKey&limit=10';

  static String chatInitiateP2P() => '$base/v1/chat/initiate-p2p';
  static String acceptParcel({required String id}) =>
      '$base/v1/driver/accept-parcel/$id';

  //============== Payment (DPO) ===================
  static String dpoCheckout() => '$base/v1/payments/dpo/checkout';
  static String dpoVerify() => '$base/v1/payments/dpo/verify';

  //============== Wallet ===================
  static String getWallet() => '$base/v1/wallet/me';
  static String walletTransactions({required int page}) =>
      '$base/v1/wallet/transactions?page=$page&limit=10';
  static String withdraw() => '$base/v1/wallet/withdraw';
  static String myWithdrawals({required int page}) =>
      '$base/v1/wallet/withdrawals?page=$page&limit=10';
}
