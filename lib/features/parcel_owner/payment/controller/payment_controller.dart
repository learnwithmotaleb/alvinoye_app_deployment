import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  static PaymentController get to => Get.find();

  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  final RxBool isCreating = false.obs;
  final RxBool isVerifying = false.obs;

  /// Create a DPO transaction for [parcelId] and return the hosted payment URL.
  Future<String?> createCheckout(String parcelId) async {
    isCreating.value = true;
    try {
      final token = localService.getToken();
      final response = await apiClient.post(
        url: ApiUrls.dpoCheckout(),
        body: {'parcel_id': parcelId},
        token: token,
      );
      if (response.statusCode == 200) {
        final url = response.data?['data']?['url'] as String?;
        if (url != null && url.isNotEmpty) return url;
      }
      AppToast.error(
        message:
            response.data?['message']?.toString() ?? 'Failed to start payment',
      );
      return null;
    } catch (e) {
      AppConfig.logger.e(e);
      AppToast.error(message: 'Failed to start payment');
      return null;
    } finally {
      isCreating.value = false;
    }
  }

  /// Confirm a DPO payment server-to-server. Returns true when paid.
  Future<bool> verify(String parcelId) async {
    isVerifying.value = true;
    try {
      final token = localService.getToken();
      final response = await apiClient.post(
        url: ApiUrls.dpoVerify(),
        body: {'parcel_id': parcelId},
        token: token,
      );
      if (response.statusCode == 200) {
        return response.data?['data']?['paid'] == true;
      }
      return false;
    } catch (e) {
      AppConfig.logger.e(e);
      return false;
    } finally {
      isVerifying.value = false;
    }
  }
}
