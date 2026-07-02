import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/driver/wallet/model/wallet_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WalletController extends GetxController {
  static WalletController get to => Get.find();

  final ApiClient apiClient = sl<ApiClient>();
  final LocalService localService = sl();

  final Rx<ApiStatus> status = ApiStatus.loading.obs;
  final Rxn<WalletModel> wallet = Rxn<WalletModel>();
  final RxBool isWithdrawing = false.obs;

  final PagingController<int, WalletTransaction> transactionController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    transactionController.addPageRequestListener((pageKey) {
      _getTransactions(pageKey: pageKey);
    });
  }

  @override
  void onClose() {
    transactionController.dispose();
    super.onClose();
  }

  Future<void> getWallet() async {
    status.value = ApiStatus.loading;
    try {
      final token = await localService.getToken();
      final response = await apiClient.get(
        url: ApiUrls.getWallet(),
        token: token,
      );
      if (response.statusCode == 200) {
        wallet.value = WalletModel.fromJson(response.data);
        status.value = ApiStatus.completed;
      } else {
        status.value = ApiStatus.error;
      }
    } catch (e) {
      AppConfig.logger.e(e);
      status.value = ApiStatus.error;
    }
  }

  Future<void> _getTransactions({required int pageKey}) async {
    try {
      final token = await localService.getToken();
      final response = await apiClient.get(
        url: ApiUrls.walletTransactions(page: pageKey),
        token: token,
      );
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? [];
        final newItems = list
            .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
            .toList();
        final isLastPage = newItems.length < 10;
        if (isLastPage) {
          transactionController.appendLastPage(newItems);
        } else {
          transactionController.appendPage(newItems, pageKey + 1);
        }
      } else {
        transactionController.error = 'Error fetching transactions';
      }
    } catch (e) {
      AppConfig.logger.e(e);
      transactionController.error = e;
    }
  }

  void refreshAll() {
    getWallet();
    transactionController.refresh();
  }

  Future<void> requestWithdraw(double amount) async {
    isWithdrawing.value = true;
    try {
      final token = await localService.getToken();
      final response = await apiClient.post(
        url: ApiUrls.withdraw(),
        body: {'amount': amount},
        token: token,
      );
      if (response.statusCode == 200) {
        AppToast.success(
          message:
              response.data?['message']?.toString() ?? 'Withdrawal requested',
        );
        refreshAll();
      } else {
        AppToast.error(
          message: response.data?['message']?.toString() ?? 'Withdrawal failed',
        );
      }
    } catch (e) {
      AppConfig.logger.e(e);
      AppToast.error(message: 'Withdrawal failed');
    } finally {
      isWithdrawing.value = false;
    }
  }
}
