import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/local/local_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/logger/app_logger.dart';

class LocalService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception("LocalService not initialized");
    }
    return _prefs!;
  }

  String getToken() {
    return _prefs!.getString(LocalKeys.token) ?? "";
  }

  // Future<String> getToken() async {
  //   final prefs = await _prefs;
  //   return prefs!.getString(LocalKeys.token) ?? "";
  // }

  Future<String> getRole() async {
    final prefs = _prefs;
    return prefs!.getString(LocalKeys.role) ?? "";
  }

  Future<String> getRefreshToken() async {
    final prefs = _prefs;
    return prefs!.getString(LocalKeys.refreshToken) ?? "";
  }

  Future<String> getUserId() async {
    final prefs = _prefs;
    return prefs!.getString(LocalKeys.userId) ?? "";
  }

  Future<String> getStatus() async {
    final prefs = _prefs;
    return prefs!.getString(LocalKeys.status) ?? "";
  }

  Future<bool> getIsProfileCompleted() async {
    final prefs = _prefs;
    return prefs!.getBool(LocalKeys.isProfileCompleted) ?? false;
  }

  Future<bool> getIsEmailVerified() async {
    final prefs = _prefs;
    return prefs!.getBool(LocalKeys.isEmailVerified) ?? false;
  }

  Future<String> getEmail() async {
    final prefs = _prefs;
    return prefs!.getString(LocalKeys.email) ?? "";
  }

  Future<bool> isViewOnboarding() async {
    final prefs = _prefs;
    return prefs!.getBool(LocalKeys.onboarding) ?? false;
  }

  Future<String> getLanguage() async {
    final prefs = _prefs;
    return prefs!.getString(LocalKeys.languageKey) ?? "";
  }

  Future<bool> saveUserdata({
    required String token,
    required String refreshToken,
    required String id,
    required String role,
  }) async {
    try {
      final prefs = _prefs;
      final success =
          await prefs!.setString(LocalKeys.token, token) &&
          await prefs.setString(LocalKeys.refreshToken, refreshToken) &&
          await prefs.setString(LocalKeys.userId, id) &&
          await prefs.setString(LocalKeys.role, role);

      if (!success) {
        AppLogger.log("Failed to save user data", type: AppLogType.error);
      }
      return success;
    } catch (e, stack) {
      AppLogger.log(
        "Error saving user data: $e\n$stack",
        type: AppLogType.error,
      );
      return false;
    }
  }

  Future<bool> saveToken({required String token}) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setString(LocalKeys.token, token);
      if (!success) {
        AppLogger.log("Failed to save token", type: AppLogType.error);
      }
      return success;
    } catch (e, stack) {
      AppLogger.log("Error saving token: $e\n$stack", type: AppLogType.error);
      return false;
    }
  }

  Future<bool> viewOnboarding({required bool isView}) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setBool(LocalKeys.onboarding, isView);
      if (!success) {
        AppLogger.log(
          "Failed to save onboarding status",
          type: AppLogType.error,
        );
      }
      return success;
    } catch (e, stack) {
      AppLogger.log(
        "Error saving onboarding status: $e\n$stack",
        type: AppLogType.error,
      );
      return false;
    }
  }

  Future<bool> saveLanguage({required String value}) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setString(LocalKeys.languageKey, value);
      if (!success) {
        AppLogger.log("Failed to save language", type: AppLogType.error);
      }
      return success;
    } catch (e, stack) {
      AppLogger.log(
        "Error saving language: $e\n$stack",
        type: AppLogType.error,
      );
      return false;
    }
  }

  Future<bool> saveStatus(String status) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setString(LocalKeys.status, status);
      if (!success) {
        AppLogger.log("Failed to save status", type: AppLogType.error);
      }
      return success;
    } catch (e, stack) {
      AppLogger.log("Error saving status: $e\n$stack", type: AppLogType.error);
      return false;
    }
  }

  Future<bool> saveIsProfileCompleted(bool isProfileCompleted) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setBool(
        LocalKeys.isProfileCompleted,
        isProfileCompleted,
      );
      if (!success) {
        AppLogger.log(
          "Failed to save profile completed status",
          type: AppLogType.error,
        );
      }
      return success;
    } catch (e, stack) {
      AppLogger.log(
        "Error saving profile completed status: $e\n$stack",
        type: AppLogType.error,
      );
      return false;
    }
  }

  Future<bool> saveIsEmailVerified(bool isEmailVerified) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setBool(
        LocalKeys.isEmailVerified,
        isEmailVerified,
      );
      if (!success) {
        AppLogger.log(
          "Failed to save email verified status",
          type: AppLogType.error,
        );
      }
      return success;
    } catch (e, stack) {
      AppLogger.log(
        "Error saving email verified status: $e\n$stack",
        type: AppLogType.error,
      );
      return false;
    }
  }

  Future<bool> saveEmail(String email) async {
    try {
      final prefs = _prefs;
      final success = await prefs!.setString(LocalKeys.email, email);
      if (!success) {
        AppLogger.log("Failed to save email", type: AppLogType.error);
      }
      return success;
    } catch (e, stack) {
      AppLogger.log("Error saving email: $e\n$stack", type: AppLogType.error);
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      final prefs = _prefs;
      final lang = prefs!.getString(LocalKeys.languageKey) ?? "";
      final cleared = await prefs.clear();

      if (!cleared) {
        AppLogger.log("Logout failed", type: AppLogType.error);
        return false;
      }

      final langSaved = await prefs.setString(LocalKeys.languageKey, lang);
      if (!langSaved) {
        AppLogger.log(
          "Language not restored after logout",
          type: AppLogType.warning,
        );
      }

      AppLogger.log("User logged out successfully", type: AppLogType.success);
      return true;
    } catch (e, stack) {
      AppLogger.log("Logout error: $e\n$stack", type: AppLogType.error);
      return false;
    }
  }
}
