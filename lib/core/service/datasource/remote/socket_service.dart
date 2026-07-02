import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketApi {
  factory SocketApi() {
    return _socketApi;
  }
  SocketApi._internal();
  static io.Socket? _socket;
  static io.Socket? get socket => _socket;

  ///<------------------------- Socket Initialization with dynamic User ID ---------------->
  static Future<void> init() async {
    if (_socket != null && _socket!.connected) {
      debugPrint('Socket is already initialized and connected.');
      return;
    }

    final LocalService localService = sl<LocalService>();

    String token = localService.getToken();
    String id = await localService.getUserId();
    if (token.isEmpty || token == "null" || id.isEmpty || id == "null") {
      debugPrint(
        'Socket Connected >>>>>>>>>>>> FALSE token/userId empty <<<<<<<<<<<<',
      );
      return;
    }
    debugPrint('Socket token: $token, userId: $id');
    _socket = io.io(
      ApiUrls.socketUrl(),
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .setReconnectionDelay(2000)
          .setReconnectionAttempts(5)
          .setTimeout(10000)
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setAuth({'userId': id})
          .build(),
    );

    // Explicitly connect — required even when enableAutoConnect() is set
    _socket?.connect();

    debugPrint(
      '$id=============> Socket initialization, connected: ${_socket?.connected}',
    );
    // Listen for socket connection
    _socket?.onConnect((_) {
      _socket?.on('pong', (data) {
        debugPrint('Received pong from server');
      });
      debugPrint(
        '==============>>>>>>> Socket Connected ${_socket?.connected} ===============<<<<<<<',
      );
    });
    _socket?.on('unauthorized', (dynamic data) {
      debugPrint('Unauthorized');
    });
    // Listen for errors
    _socket?.onError((dynamic error) {
      debugPrint('Socket error: $error');
    });
    // Listen for disconnection
    _socket?.onDisconnect((dynamic data) {
      debugPrint('>>>>>>>>>> Socket instance disconnected <<<<<<<<<<<<$data');
      reconnect();
    });
    _socket?.on('pong', (data) {
      debugPrint('Received pong from server');
    });
  }

  static void reconnect() {
    if (_socket != null && !_socket!.connected) {
      debugPrint('Attempting to reconnect...');
      _socket?.connect();
    }
  }

  static final SocketApi _socketApi = SocketApi._internal();
}

// import 'package:delivery_app/core/di/injection.dart';
// import 'package:delivery_app/core/service/datasource/local/local_service.dart';
// import 'package:delivery_app/utils/api_urls/api_urls.dart';
// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// class SocketApi {
//   factory SocketApi() => _socketApi;
//   SocketApi._internal();
//   static final SocketApi _socketApi = SocketApi._internal();

//   static io.Socket? _socket;
//   static io.Socket? get socket => _socket;

//   // ─── Initialize & Connect ────────────────────────────────────────────────
//   static Future<void> init() async {
//     if (_socket != null && _socket!.connected) {
//       debugPrint('Socket already connected.');
//       return;
//     }

//     final LocalService localService = sl<LocalService>();
//     final String token = await localService.getToken();
//     final String id = await localService.getUserId();

//     if (token.isEmpty || token == 'null' || id.isEmpty || id == 'null') {
//       debugPrint('Socket init skipped: token/userId empty');
//       return;
//     }

//     _socket = io.io(
//       ApiUrls.socketUrl(),
//       io.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           .setReconnectionDelay(2000)
//           .setReconnectionAttempts(5)
//           .setTimeout(5000)
//           // Backend socketAuth middleware reads auth.accessToken
//           .setAuth({'accessToken': token})
//           .build(),
//     );

//     _socket?.onConnect((_) {
//       debugPrint('✅ Socket connected | id: ${_socket?.id}');
//     });

//     _socket?.onError((e) => debugPrint('❌ Socket error: $e'));

//     _socket?.onDisconnect((data) {
//       debugPrint('🔴 Socket disconnected: $data');
//       reconnect();
//     });
//   }

//   static void reconnect() {
//     if (_socket != null && !_socket!.connected) {
//       debugPrint('🔄 Reconnecting socket...');
//       _socket?.connect();
//     }
//   }

//   static void dispose() {
//     _socket?.disconnect();
//     _socket?.dispose();
//     _socket = null;
//   }

//   // ─── Customer Events ─────────────────────────────────────────────────────
// }
