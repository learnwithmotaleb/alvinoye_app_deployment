import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/details_my_parcel_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:get/get.dart';

class DetailsMyParcelController extends GetxController {
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  //===================  Single Details My Parcel ===================
  final loading = ApiStatus.loading.obs;
  void loadingMethod(ApiStatus status) => loading.value = status;
  Rx<DetailsMyParcelModel?> detailsMyParcel = Rx<DetailsMyParcelModel?>(null);

  Future<void> singleDetailsMyParcel({required String id}) async {
    try {
      loadingMethod(ApiStatus.loading);
      final token = localService.getToken();
      final response = await apiClient.get(
        url: ApiUrls.createDetailsParcel(id: id),
        token: token,
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        detailsMyParcel.value = DetailsMyParcelModel.fromJson(response.data);
        if (detailsMyParcel.value?.data == null) {
          loadingMethod(ApiStatus.noDataFound);
        } else {
          loadingMethod(ApiStatus.completed);
        }
        return;
      } else {
        loadingMethod(ApiStatus.error);
        AppConfig.logger.e(response.data);
        AppToast.error(message: response.data["message"].toString());
      }
    } catch (e) {
      loadingMethod(ApiStatus.error);
      AppToast.error(message: e.toString());
    }
  }

  //=================== reject and counter offer ===================

  final loadingRejectAndCounterOffer = false.obs;
  void loadingRejectAndCounterOfferMethod(bool status) =>
      loadingRejectAndCounterOffer.value = status;

  Future<void> rejectAndCounterOffer({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    try {
      loadingRejectAndCounterOfferMethod(true);
      final token = localService.getToken();
      final response = await apiClient.patch(
        url: ApiUrls.rejectAndCounterOffer(id: id),
        token: token,
        body: body,
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        loadingRejectAndCounterOfferMethod(false);
        AppToast.success(message: response.data["message"].toString());

        // Refresh parcel details using parcel_id from body
        if (body["parcel_id"] != null) {
          await singleDetailsMyParcel(id: body["parcel_id"]);
        }

        AppRouter.route.pop();
        return;
      } else {
        loadingRejectAndCounterOfferMethod(false);
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      loadingRejectAndCounterOfferMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  //=================== reject final offer ===================

  final loadingRejectFinalOffer = false.obs;
  void loadingRejectFinalOfferMethod(bool status) =>
      loadingRejectFinalOffer.value = status;
  Future<void> rejectFinalOffer({required String id}) async {
    try {
      loadingRejectFinalOfferMethod(true);
      final response = await apiClient.patch(
        url: ApiUrls.rejectFinalOffer(id: id),
      );
      AppConfig.logger.i(ApiUrls.rejectFinalOffer(id: id));
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        loadingRejectFinalOfferMethod(false);
        AppToast.success(message: response.data["message"].toString());
        AppRouter.route.pop();
        return;
      } else {
        loadingRejectFinalOfferMethod(false);
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      loadingRejectFinalOfferMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  //=================== accept final offer ===================

  final loadingAcceptFinalOffer = false.obs;
  void loadingAcceptFinalOfferMethod(bool status) =>
      loadingAcceptFinalOffer.value = status;
  Future<void> acceptFinalOffer({
    required String id,
    required dynamic parcel,
  }) async {
    try {
      loadingAcceptFinalOfferMethod(true);
      final response = await apiClient.patch(
        url: ApiUrls.acceptFinalOffer(id: id),
      );
      AppConfig.logger.i(ApiUrls.acceptFinalOffer(id: id));
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        loadingAcceptFinalOfferMethod(false);
        AppToast.success(message: response.data["message"].toString());

        // Navigate to payment screen with parcel data
        AppRouter.route.pushNamed(RoutePath.paymentScreen, extra: parcel);
        return;
      } else {
        loadingAcceptFinalOfferMethod(false);
        AppToast.error(message: response.data["message"].toString());
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      loadingAcceptFinalOfferMethod(false);
      AppToast.error(message: e.toString());
    }
  }
}
