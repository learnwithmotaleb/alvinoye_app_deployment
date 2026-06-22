import 'dart:io';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:delivery_app/features/chat/model/chat_model.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delivery_app/core/di/injection.dart';

class ChatController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final LocalService localService = sl<LocalService>();

  var isLoading = false;
  var chatModel = ChatModel().obs;
  RxString userId = "".obs;

  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImages = <XFile>[].obs;

  void getUserId() async {
    try {
      userId.value = await localService.getUserId();
    } catch (e) {
      debugPrint('Error getting userId: $e');
    }
  }

  Future<List<ChatMessage>> getChatList({
    required int pageKey,
    required String id,
  }) async {
    if (isLoading) return [];
    isLoading = true;

    try {
      final response = await apiClient.get(
        url: ApiUrls.getMessageForChat(pageKey: pageKey, id: id),
      );

      if (response.statusCode == 200) {
        final newData = ChatModel.fromJson(response.data);
        if (pageKey == 1) chatModel.value = newData;

        return newData.data ?? [];
      } else {
        throw Exception('Error fetching messages');
      }
    } catch (e) {
      debugPrint('Error in getChatList: $e');
      throw Exception('Error fetching messages');
    } finally {
      isLoading = false;
    }
  }

  Future<void> pickImages() async {
    selectedImages.clear();
    final images = await _picker.pickMultiImage(imageQuality: 50, limit: 6);
    if (images.isNotEmpty) selectedImages.addAll(images);
  }

  Future<void> pickCameraImage() async {
    selectedImages.clear();
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) selectedImages.add(image);
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<UploadImage> sendMessage({
    required Map<String, String> body,
  }) async {
    final token = await localService.getToken();
    try {
      List<MultipartBody> multipartBody = [];
      for (var img in selectedImages) {
        multipartBody.add(
          MultipartBody(fieldKey: 'attachments', file: File(img.path)),
        );
      }

      final response = await apiClient.uploadMultipart(
        url: ApiUrls.sendMessage(),
        files: multipartBody,
        method: 'POST',
        token: token,
        fields: body,
      );

      if (response.statusCode == 201) {
        selectedImages.clear();
        return UploadImage.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
    return UploadImage();
  }

  void listenForNewMessages({
    required String chatId,
    required Function(ChatMessage) onNewMessage,
  }) {
    SocketApi.socket?.off('new_message');

    // join chat room first
    SocketApi.socket?.emit('join_chat', chatId);

    SocketApi.socket?.on('new_message', (data) {
      debugPrint("Socket new_message payload: $data");
      final newMessage = ChatMessage.fromJson(data);

      if (newMessage.chatId == chatId) {
        onNewMessage(newMessage);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getUserId();
  }

  @override
  void onClose() {
    selectedImages.clear();
    super.onClose();
  }
}

class UploadImage {
  final bool? success;
  final String? message;
  final Data? data;

  UploadImage({this.success, this.message, this.data});

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? chatId;
  final SenderId? senderId;
  final String? senderRole;
  final String? content;
  final List<dynamic>? attachments;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Data({
    this.chatId,
    this.senderId,
    this.senderRole,
    this.content,
    this.attachments,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chatId: json["chat_id"],
    senderId: json["sender_id"] == null
        ? null
        : SenderId.fromJson(json["sender_id"]),
    senderRole: json["sender_role"],
    content: json["content"],
    attachments: json["attachments"] == null
        ? []
        : List<dynamic>.from(json["attachments"]!.map((x) => x)),
    id: json["_id"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "chat_id": chatId,
    "sender_id": senderId?.toJson(),
    "sender_role": senderRole,
    "content": content,
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x)),
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class SenderId {
  final String? id;
  final String? fullName;
  final String? profilePicture;
  final String? senderIdId;

  SenderId({this.id, this.fullName, this.profilePicture, this.senderIdId});

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
    id: json["_id"],
    fullName: json["full_name"],
    profilePicture: json["profile_picture"],
    senderIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "profile_picture": profilePicture,
    "id": senderIdId,
  };
}
