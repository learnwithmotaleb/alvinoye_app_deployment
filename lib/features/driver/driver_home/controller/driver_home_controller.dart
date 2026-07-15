import 'dart:async';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:delivery_app/features/driver/driver_home/model/driver_home_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DriverHomeController extends GetxController {
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  // ─── Toggle this for testing — set false in production ────────────────────
  static const bool kMockMode = false;

  // ─── Paging controller for REST-based infinite scroll ─────────────────────
  final PagingController<int, ParcelInformation> pagingController =
      PagingController(firstPageKey: 1);

  // ─── Real-time parcel list from socket (driver:available-parcels) ──────────
  final RxList<ParcelInformation> realtimeParcels = <ParcelInformation>[].obs;
  final RxBool isSocketLoading = false.obs;

  // ─── Current GPS position ──────────────────────────────────────────────────
  double _currentLat = 0.0;
  double _currentLng = 0.0;
  double? _currentHeading;

  // ─── Timer: emit location every 2 seconds (real or mock) ──────────────────
  Timer? _locationEmitTimer;

  // ─── Per-parcel accept loading: parcelId → isLoading ──────────────────────
  final RxMap<String, bool> acceptLoadingMap = <String, bool>{}.obs;

  // ─── Mock route points (Dhaka area) ───────────────────────────────────────
  final List<({double lat, double lng})> _mockPoints = const [
    (lat: 23.7925, lng: 90.4078),
    (lat: 23.7929, lng: 90.4082),
    (lat: 23.7933, lng: 90.4087),
    (lat: 23.7937, lng: 90.4091),
    (lat: 23.7941, lng: 90.4096),
    (lat: 23.7946, lng: 90.4100),
    (lat: 23.7951, lng: 90.4104),
    (lat: 23.7956, lng: 90.4109),
    (lat: 23.7960, lng: 90.4114),
    (lat: 23.7964, lng: 90.4119),
    (lat: 23.7968, lng: 90.4123),
    (lat: 23.7972, lng: 90.4125),
    (lat: 23.7977, lng: 90.4124),
    (lat: 23.7982, lng: 90.4122),
    (lat: 23.7988, lng: 90.4126),
    (lat: 23.7994, lng: 90.4131),
    (lat: 23.8000, lng: 90.4137),
    (lat: 23.8007, lng: 90.4143),
    (lat: 23.8014, lng: 90.4150),
    (lat: 23.8021, lng: 90.4157),
    (lat: 23.8028, lng: 90.4164),
    (lat: 23.8034, lng: 90.4170),
    (lat: 23.8040, lng: 90.4176),
    (lat: 23.8046, lng: 90.4182),
    (lat: 23.8053, lng: 90.4189),
    (lat: 23.8060, lng: 90.4196),
    (lat: 23.8067, lng: 90.4203),
    (lat: 23.8073, lng: 90.4208),
    (lat: 23.8079, lng: 90.4212),
    (lat: 23.8085, lng: 90.4216),
    (lat: 23.8092, lng: 90.4222),
    (lat: 23.8099, lng: 90.4229),
    (lat: 23.8106, lng: 90.4236),
    (lat: 23.8113, lng: 90.4243),
    (lat: 23.8120, lng: 90.4250),
  ];

  int _mockIndex = 0;

  // ──────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    _listenToAvailableParcels();
    _startLocationTracking();
    pagingController.addPageRequestListener(fetchPage);
  }

  // ─── STEP 1: Listen for backend's real-time parcel push ───────────────────
  void _listenToAvailableParcels() {
    SocketApi.socket?.on('driver:available-parcels', (data) {
      try {
        AppConfig.logger.d('📦 driver:available-parcels → $data');

        final rawList = data?['data'] as List<dynamic>?;
        if (rawList != null) {
          final parcels = rawList
              .map(
                (item) =>
                    ParcelInformation.fromJson(item as Map<String, dynamic>),
              )
              .toList();

          realtimeParcels.assignAll(parcels);
          isSocketLoading.value = false;
        }
      } catch (e) {
        AppConfig.logger.e('driver:available-parcels parse error → $e');
      }
    });
  }

  // ─── STEP 2: Branch into mock or real GPS tracking ────────────────────────
  Future<void> _startLocationTracking() async {
    if (kMockMode) {
      AppConfig.logger.d('🧪 Mock mode — starting mock location stream');
      _startMockStream();
      return;
    }

    // ── Real GPS path ────────────────────────────────────────────────────────
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      AppConfig.logger.w('Location permission denied — skipping socket emit.');
      return;
    }

    await _updateCurrentPosition();

    _locationEmitTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _updateCurrentPosition();
      _emitLocationToSocket();
    });
  }

  // ─── Mock stream: cycles through _mockPoints every 2 seconds ──────────────
  void _startMockStream() {
    // Seed the first position immediately so the socket gets data right away
    _applyMockPoint();

    _locationEmitTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _applyMockPoint();
    });
  }

  /// Advance to the next mock point, update internal lat/lng, then emit.
  void _applyMockPoint() {
    final point = _mockPoints[_mockIndex % _mockPoints.length];
    _mockIndex++;

    _currentLat = point.lat;
    _currentLng = point.lng;
    _currentHeading = null; // no heading in mock

    AppConfig.logger.d(
      '🧪 Mock tick [$_mockIndex]: lat=$_currentLat, lng=$_currentLng',
    );

    _emitLocationToSocket();
  }

  /// Call this from a debug FAB to manually advance one mock step.
  void injectMockStep() {
    if (!kMockMode) return;
    AppConfig.logger.d('🧪 Manual mock step triggered');
    _applyMockPoint();
  }

  // ─── Get current device GPS position (real mode only) ─────────────────────
  Future<void> _updateCurrentPosition() async {
    try {
      final Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      _currentLat = pos.latitude;
      _currentLng = pos.longitude;
      _currentHeading = pos.heading;
      AppConfig.logger.d(
        '📍 GPS → lat=$_currentLat, lng=$_currentLng, heading=$_currentHeading',
      );
    } catch (e) {
      AppConfig.logger.e('GPS error: $e');
    }
  }

  // ─── STEP 3: Emit driver:location-update (shared by real + mock) ──────────
  void _emitLocationToSocket() {
    if (SocketApi.socket == null || !SocketApi.socket!.connected) {
      AppConfig.logger.w('Socket not connected — skipping emit.');
      return;
    }

    if (_currentLat == 0.0 && _currentLng == 0.0) {
      AppConfig.logger.w('GPS not ready — skipping emit.');
      return;
    }

    isSocketLoading.value = true;

    final payload = {
      'currentLat': _currentLat,
      'currentLng': _currentLng,
      if (_currentHeading != null) 'heading': _currentHeading,
      'radiusMeters': 1500,
    };

    AppConfig.logger.d('📡 Emitting driver:location-update → $payload');
    SocketApi.socket!.emit('driver:location-update', payload);
  }

  // ─── STEP 4: REST paginated fetch ─────────────────────────────────────────
  Future<void> fetchPage(int pageKey) async {
    try {
      final response = await apiClient.get(
        url: ApiUrls.getDriverParcels(
          page: pageKey,
          currentLat: _currentLat,
          currentLng: _currentLng,
        ),
      );
      AppConfig.logger.d(response.data);

      if (response.statusCode == 200) {
        final driverHomeModel = DriverHomeModel.fromJson(response.data);
        final newItems = driverHomeModel.data?.data ?? <ParcelInformation>[];
        final isLastPage = newItems.length < 10;

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = response.data['message'];
      }
    } catch (error) {
      AppConfig.logger.e(error);
      pagingController.error = error;
    }
  }

  // ─── Accept a parcel ──────────────────────────────────────────────────────
  Future<void> acceptParcel({required String id}) async {
    acceptLoadingMap[id] = true;
    try {
      final response = await apiClient.patch(url: ApiUrls.acceptParcel(id: id));
      AppConfig.logger.d(response.data);

      if (response.statusCode == 200) {
        pagingController.refresh();
        realtimeParcels.removeWhere((p) => p.id == id);
        AppToast.success(message: response.data['message']);
      } else {
        AppConfig.logger.e(response.data['message']);
      }
    } catch (error) {
      AppConfig.logger.e(error);
      AppToast.error(message: error.toString());
    } finally {
      acceptLoadingMap[id] = false;
    }
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────
  @override
  void onClose() {
    _locationEmitTimer?.cancel();
    SocketApi.socket?.off('driver:available-parcels');
    pagingController.dispose();
    super.onClose();
  }
}
