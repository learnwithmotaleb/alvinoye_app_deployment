import 'dart:io';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateParcelController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  Rx<XFile?> parcelImage = Rx<XFile?>(null);
  RxBool createParcelLoading = false.obs;

  Future<void> pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) parcelImage.value = image;
  }

  final isLoading = false.obs;
  void setLoading(bool status) => createParcelLoading.value = status;

  Future<void> createParcel({required Map<String, dynamic> body}) async {
    setLoading(true);

    final token = localService.getToken();

    try {
      final List<MultipartBody> multipart = [];

      if (parcelImage.value != null && parcelImage.value!.path.isNotEmpty) {
        multipart.add(
          MultipartBody(
            fieldKey: "parcel_images",
            file: File(parcelImage.value!.path),
          ),
        );
      }
      AppConfig.logger.i("Body before encoding: $body");

      final response = await apiClient.uploadMultipart(
        url: ApiUrls.createParcel(),
        files: multipart,
        method: 'POST',
        token: token,
        fields: body,
      );
      AppConfig.logger.i(response.data);
      setLoading(false);

      if (response.statusCode == 201) {
        final data = response.data?["data"];
        final String id = data?["_id"] ?? data?["id"] ?? "";

        AppRouter.route.goNamed(RoutePath.createDetailsParcelScreen, extra: id);
        AppToast.success(
          message: response.data?["message"] ?? "Parcel created successfully",
        );
      } else {
        AppToast.error(
          message: response.data?["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      setLoading(false);
      AppToast.error(message: e.toString());
    }
  }

  //
  Future<void> updateParcel({
    required String parcelId,
    required Map<String, dynamic> body,
  }) async {
    setLoading(true);

    final token = localService.getToken();

    try {
      final List<MultipartBody> multipart = [];

      if (parcelImage.value != null && parcelImage.value!.path.isNotEmpty) {
        multipart.add(
          MultipartBody(
            fieldKey: "parcel_images",
            file: File(parcelImage.value!.path),
          ),
        );
      }

      final response = await apiClient.uploadMultipart(
        url: ApiUrls.updateParcel(parcelId: parcelId),
        files: multipart,
        method: "PATCH",
        token: token,
        fields: body,
      );

      setLoading(false);

      if (response.statusCode == 200) {
        AppToast.success(
          message: response.data?["message"] ?? "Parcel updated successfully",
        );

        AppRouter.route.pop();
      } else {
        AppToast.error(message: response.data?["message"] ?? "Update failed");
      }
    } catch (e) {
      setLoading(false);

      AppToast.error(message: e.toString());
    }
  }
}
