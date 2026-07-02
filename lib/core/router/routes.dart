import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/features/auth/active/active_otp_screen.dart';
import 'package:delivery_app/features/auth/admin_approval/admin_approval_screen.dart';
import 'package:delivery_app/features/auth/forget/forget_password_screen.dart';
import 'package:delivery_app/features/auth/login/login_screen.dart';
import 'package:delivery_app/features/auth/reset/reset_password_screen.dart';
import 'package:delivery_app/features/auth/sign_up/sign_up_screen.dart';
import 'package:delivery_app/features/auth/vendor_selection/vendor_selection_screen.dart';
import 'package:delivery_app/features/auth/verify_otp/verify_otp_screen.dart';
import 'package:delivery_app/features/chat/chat_screen.dart';
import 'package:delivery_app/features/driver/commuter_registration/commuter_registration_screen.dart';
import 'package:delivery_app/features/driver/customer_review/customer_review_screen.dart';
import 'package:delivery_app/features/driver/driver_nav/driver_nav_screen.dart';
import 'package:delivery_app/features/driver/parcel_details/parcel_details_screen.dart';
import 'package:delivery_app/features/driver/parcel_details/parcel_otp_screen.dart';
import 'package:delivery_app/features/driver/parcel_details/transaction_screen.dart';
import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart'
    show DriverParcelItem;
import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
import 'package:delivery_app/features/driver/parcels/parcels_screen.dart';
import 'package:delivery_app/features/driver/professional_info/professional_info_edit_screen.dart';
import 'package:delivery_app/features/driver/professional_info/professional_info_screen.dart';
import 'package:delivery_app/features/driver/track_parcel/track_parcel_screen.dart';
import 'package:delivery_app/features/driver/wallet/wallet_screen.dart';
import 'package:delivery_app/features/notification/view/notification_screen.dart';
import 'package:delivery_app/features/onboarding/onboarding_screen.dart';
import 'package:delivery_app/features/other/change_password_screen.dart';
import 'package:delivery_app/features/other/password_and_security_screen.dart';
import 'package:delivery_app/features/other/privacy_policy_screen.dart';
import 'package:delivery_app/features/other/support_help_screen.dart';
import 'package:delivery_app/features/other/terms_and_conditions_screen.dart';
import 'package:delivery_app/features/parcel_owner/all_commuter/commuter_profile_screen.dart';
import 'package:delivery_app/features/parcel_owner/create_parcel/create_details_parcel/create_details_parcel_screen.dart';
import 'package:delivery_app/features/parcel_owner/create_parcel/create_parcel_screen.dart';
import 'package:delivery_app/features/parcel_owner/create_parcel/edit_parcel/edit_parcel_screen.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/details_my_parcel_screen.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_nav/parcel_owner_nav_screen.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/parcel_owner_review_screen.dart';
import 'package:delivery_app/features/parcel_owner/payment/dpo_webview_screen.dart';
import 'package:delivery_app/features/parcel_owner/payment/payment_screen.dart';
import 'package:delivery_app/features/parcel_owner/refund/refund_screen.dart';
import 'package:delivery_app/features/parcel_owner/track_parcel_owner/track_parcel_owner_screen.dart';
import 'package:delivery_app/features/profile/edit_profile_screen.dart';
import 'package:delivery_app/features/splash/splash_screen.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter initRoute = GoRouter(
    initialLocation: RoutePath.splashScreen.addBasePath,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,

    routes: [
      ///======================= Initial Route =======================
      GoRoute(
        name: RoutePath.splashScreen,
        path: RoutePath.splashScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const SplashScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.onboardingScreen,
        path: RoutePath.onboardingScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: OnboardingScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.vendorSelectionScreen,
        path: RoutePath.vendorSelectionScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const VendorSelectionScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.loginScreen,
        path: RoutePath.loginScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const LoginScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.signUpScreen,
        path: RoutePath.signUpScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const SignUpScreen(),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.forgetPasswordScreen,
        path: RoutePath.forgetPasswordScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const ForgetPasswordScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.verifyOtpScreen,
        path: RoutePath.verifyOtpScreen.addBasePath,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final token = args?['token'] as String? ?? '';
          final email = args?['email'] as String? ?? '';
          final isSignUp = args?['isSignUp'] as bool? ?? false;
          return _buildPageWithAnimation(
            child: VerifyOtpScreen(
              token: token,
              isSignUp: isSignUp,
              email: email,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.resetPasswordScreen,
        path: RoutePath.resetPasswordScreen.addBasePath,
        pageBuilder: (context, state) {
          final token = state.extra as String? ?? '';
          return _buildPageWithAnimation(
            child: ResetPasswordScreen(token: token),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.activeOtpScreen,
        path: RoutePath.activeOtpScreen.addBasePath,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final email = args?['email'] as String? ?? '';
          final isSignUp = args?['isSignUp'] as bool? ?? false;
          final token = args?['token'] as String?;

          return _buildPageWithAnimation(
            child: ActiveOtpScreen(
              email: email,
              isSignUp: isSignUp,
              token: token,
            ),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.driverNavScreen,
        path: RoutePath.driverNavScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: DriverNavScreen(),
            state: state,
          );
        },
      ),

      //=================Profile ===================
      // GoRoute(
      //   name: RoutePath.profileScreen,
      //   path: RoutePath.profileScreen.addBasePath,
      //   pageBuilder: (context, state) {
      //     return _buildPageWithAnimation(child: ProfileScreen(), state: state);
      //   },
      // ),
      GoRoute(
        name: RoutePath.editProfileScreen,
        path: RoutePath.editProfileScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: EditProfileScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.professionalInfoEditScreen,
        path: RoutePath.professionalInfoEditScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: ProfessionalInfoEditScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.professionalInfoScreen,
        path: RoutePath.professionalInfoScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: ProfessionalInfoScreen(),
            state: state,
          );
        },
      ),

      //=============Setting==========
      GoRoute(
        name: RoutePath.changePasswordScreen,
        path: RoutePath.changePasswordScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: ChangePasswordScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.customerReviewScreen,
        path: RoutePath.customerReviewScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: CustomerReviewScreen(),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.privacyPolicyScreen,
        path: RoutePath.privacyPolicyScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: PrivacyPolicyScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.termsAndConditionsScreen,
        path: RoutePath.termsAndConditionsScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: TermsAndConditionsScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.passwordAndSecurityScreen,
        path: RoutePath.passwordAndSecurityScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: PasswordAndSecurityScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.chatScreen,
        path: RoutePath.chatScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          String chatId = '';
          if (extra != null) {
            if (extra is String) {
              chatId = extra;
            } else if (extra is Map<String, dynamic>) {
              chatId = extra['id'] ?? extra['_id'] ?? '';
            } else {
              chatId = (extra as dynamic).id ?? '';
            }
          }
          return _buildPageWithAnimation(
            child: ChatScreen(chatId: chatId),
            state: state,
          );
        },
      ),

      // GoRoute(
      //   name: RoutePath.audioCallScreen,
      //   path: RoutePath.audioCallScreen.addBasePath,
      //   pageBuilder: (context, state) {
      //     return _buildPageWithAnimation(
      //       child: AudioCallScreen(),
      //       state: state,
      //     );
      //   },
      // ),
      GoRoute(
        name: RoutePath.parcelDetailsScreen,
        path: RoutePath.parcelDetailsScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          String parcelId;

          if (extra is String) {
            parcelId = extra;
          } else if (extra is Map<String, dynamic>) {
            parcelId = extra['_id'] ?? extra['id'] ?? '';
          } else {
            parcelId = (extra as dynamic).id ?? '';
          }

          return _buildPageWithAnimation(
            child: ParcelDetailsScreen(parcelId: parcelId),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.notificationScreen,
        path: RoutePath.notificationScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: NotificationScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.supportHelpScreen,
        path: RoutePath.supportHelpScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: SupportHelpScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.commuterRegistrationScreen,
        path: RoutePath.commuterRegistrationScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: CommuterRegistrationScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.adminApprovalScreen,
        path: RoutePath.adminApprovalScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const AdminApprovalScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.parcelOwnerNavScreen,
        path: RoutePath.parcelOwnerNavScreen.addBasePath,
        pageBuilder: (context, state) {
          final int? initialIndex = state.extra is int
              ? state.extra as int
              : null;

          print("initialIndex: $initialIndex");
          return _buildPageWithAnimation(
            child: ParcelOwnerNavScreen(initialIndex: initialIndex),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.transactionScreen,
        path: RoutePath.transactionScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: TransactionScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.parcelOtpScreen,
        path: RoutePath.parcelOtpScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          String parcelId;

          if (extra == null) {
            parcelId = '';
          } else if (extra is String) {
            parcelId = extra;
          } else if (extra is Map<String, dynamic>) {
            parcelId = extra['_id'] ?? extra['id'] ?? '';
          } else {
            parcelId = (extra as dynamic).id ?? '';
          }
          return _buildPageWithAnimation(
            child: ParcelOtpScreen(parcelId: parcelId),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.parcelsScreen,
        path: RoutePath.parcelsScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(child: ParcelsScreen(), state: state);
        },
      ),
      GoRoute(
        name: RoutePath.trackParcelScreen,
        path: RoutePath.trackParcelScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final DriverParcelItem parcel;

          if (extra is Map<String, dynamic>) {
            parcel = DriverParcelItem.fromJson(extra);
          } else {
            parcel = extra as DriverParcelItem;
          }
          return _buildPageWithAnimation(
            child: TrackParcelScreen(parcelItem: parcel),
            state: state,
          );
        },
      ),

      GoRoute(
        name: RoutePath.createParcelScreen,
        path: RoutePath.createParcelScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: CreateParcelScreen(),
            state: state,
          );
        },
      ),

      // GoRoute(
      //   name: RoutePath.allCommuterScreen,
      //   path: RoutePath.allCommuterScreen.addBasePath,
      //   pageBuilder: (context, state) {
      //     return _buildPageWithAnimation(
      //       child: const AllCommuterScreen(),
      //       state: state,
      //     );
      //   },
      // ),
      GoRoute(
        name: RoutePath.commuterProfileScreen,
        path: RoutePath.commuterProfileScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const CommuterProfileScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.refundScreen,
        path: RoutePath.refundScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const RefundScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.parcelOwnerReviewScreen,
        path: RoutePath.parcelOwnerReviewScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          String parcelId;

          if (extra is String) {
            parcelId = extra;
          } else if (extra is Map<String, dynamic>) {
            parcelId = extra['_id'] ?? extra['id'] ?? '';
          } else {
            parcelId = (extra as dynamic).id ?? '';
          }
          return _buildPageWithAnimation(
            child: ParcelOwnerReviewScreen(parcelId: parcelId),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.createDetailsParcelScreen,
        path: RoutePath.createDetailsParcelScreen.addBasePath,
        pageBuilder: (context, state) {
          final id = state.extra as String;
          return _buildPageWithAnimation(
            child: CreateDetailsParcelScreen(id: id),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.editParcelScreen,
        path: RoutePath.editParcelScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const EditParcelScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.detailsMyParcelScreen,
        path: RoutePath.detailsMyParcelScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final ParcelItem parcel;

          if (extra is Map<String, dynamic>) {
            parcel = ParcelItem.fromJson(extra);
          } else {
            parcel = extra as ParcelItem;
          }

          return _buildPageWithAnimation(
            child: DetailsMyParcelScreen(parcel: parcel),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.paymentScreen,
        path: RoutePath.paymentScreen.addBasePath,
        pageBuilder: (context, state) {
          final parcel = state.extra as ParcelItem;
          return _buildPageWithAnimation(
            child: PaymentScreen(parcel: parcel),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.dpoWebviewScreen,
        path: RoutePath.dpoWebviewScreen.addBasePath,
        pageBuilder: (context, state) {
          final url = state.extra as String;
          return _buildPageWithAnimation(
            child: DpoWebviewScreen(url: url),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.walletScreen,
        path: RoutePath.walletScreen.addBasePath,
        pageBuilder: (context, state) {
          return _buildPageWithAnimation(
            child: const WalletScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        name: RoutePath.trackParcelOwnerScreen,
        path: RoutePath.trackParcelOwnerScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final ParcelItem parcel;

          if (extra is Map<String, dynamic>) {
            parcel = ParcelItem.fromJson(extra);
          } else {
            parcel = extra as ParcelItem;
          }
          return _buildPageWithAnimation(
            child: TrackParcelOwnerScreen(parcelItem: parcel),
            state: state,
          );
        },
      ),
      // GoRoute(
      //   name: RoutePath.bookingsScreen,
      //   path: RoutePath.bookingsScreen.addBasePath,
      //   pageBuilder: (context, state) {
      //     return _buildPageWithAnimation(child: BookingsScreen(), state: state);
      //   },
      // ),
      /*GoRoute(
        name: RoutePath.categoryEventsScreen,
        path: RoutePath.categoryEventsScreen.addBasePath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final map = (extra is Map<String, dynamic>) ? extra : {};

          final id = map['id'] as String? ?? '';
          final title = map['title'] as String? ?? '';

          return _buildPageWithAnimation(
            child: CategoryEventsScreen(id: id, title: title),
            state: state,
          );
        },
      ),*/
    ],
  );

  static CustomTransitionPage _buildPageWithAnimation({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static GoRouter get route => initRoute;
}
