import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../network/api_endpoints.dart';
import '../utils/app_logger.dart';

/// Manages a single Socket.IO connection for real-time ledger updates.
/// One instance per app session — registered as a lazy singleton in DI.
class LedgerSocketService {
  static const _m = 'LedgerWS';

  io.Socket? _socket;
  bool _connected = false;

  // Broadcast stream of raw 'notification:new' payloads from the server.
  final _notifController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get notificationStream =>
      _notifController.stream;

  // Broadcast stream of WebSocket connection status (true = connected).
  // UI can listen to show a live/offline indicator without polling.
  final _connController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connController.stream;

  static String get _socketUrl =>
      // Strip /api/v1 — socket.io runs at the root of the HTTP server
      ApiEndpoints.baseUrl.replaceFirst('/api/v1', '');

  /// Connect to the WebSocket server using the user's access token.
  void connect(String accessToken) {
    if (_connected) return;

    AppLogger.i(_m, 'Connecting to $_socketUrl...');

    _socket = io.io(
      _socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!
      ..onConnect((_) {
        _connected = true;
        _connController.add(true);
        AppLogger.i(_m, 'Connected');
      })
      ..on('notification:new', (raw) {
        // Socket.IO may deliver data as Map or as List<dynamic> where [0] is the payload.
        final Map<String, dynamic>? payload;
        if (raw is Map<String, dynamic>) {
          payload = raw;
        } else if (raw is List && raw.isNotEmpty && raw[0] is Map<String, dynamic>) {
          payload = raw[0] as Map<String, dynamic>;
        } else {
          payload = null;
        }
        if (payload != null) {
          AppLogger.v(_m, 'Received notification:new');
          _notifController.add(payload);
        } else {
          AppLogger.w(_m, 'notification:new — unexpected payload type: ${raw.runtimeType}');
        }
      })
      ..onDisconnect((reason) {
        _connected = false;
        _connController.add(false);
        AppLogger.w(_m, 'Disconnected: $reason');
      })
      ..onConnectError((err) => AppLogger.e(_m, 'Connect error', err))
      ..onError((err) => AppLogger.e(_m, 'Socket error', err))
      ..connect();
  }

  /// Join a ledger room so this socket receives updates for that link.
  void joinLedger(String linkId) {
    AppLogger.i(_m, 'Joining room link:$linkId');
    _socket?.emit('ledger:join', {'linkId': linkId});
  }

  /// Leave a ledger room (called when the ledger screen is disposed).
  void leaveLedger(String linkId) {
    AppLogger.i(_m, 'Leaving room link:$linkId');
    _socket?.emit('ledger:leave', {'linkId': linkId});
  }

  Map<String, dynamic>? _coerceMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is List && raw.isNotEmpty && raw[0] is Map<String, dynamic>) {
      return raw[0] as Map<String, dynamic>;
    }
    return null;
  }

  /// Listen for a new entry being added to the ledger.
  /// Clears any existing handler for this event before registering to prevent accumulation.
  void onEntryAdded(void Function(Map<String, dynamic> data) handler) {
    _socket?.off('ledger:entry_added');
    _socket?.on('ledger:entry_added', (raw) {
      final payload = _coerceMap(raw);
      if (payload != null) {
        AppLogger.v(_m, 'Received ledger:entry_added');
        handler(payload);
      }
    });
  }

  /// Listen for an existing entry being updated (confirm / dispute).
  /// Clears any existing handler for this event before registering to prevent accumulation.
  void onEntryUpdated(void Function(Map<String, dynamic> data) handler) {
    _socket?.off('ledger:entry_updated');
    _socket?.on('ledger:entry_updated', (raw) {
      final payload = _coerceMap(raw);
      if (payload != null) {
        AppLogger.v(_m, 'Received ledger:entry_updated');
        handler(payload);
      }
    });
  }

  /// Listen for a membership change on the current ledger link (assign / request /
  /// approve / decline). Payload carries `{ linkId }`; the client refetches status.
  /// Clears any existing handler for this event before registering to prevent accumulation.
  void onMembershipUpdated(void Function(Map<String, dynamic> data) handler) {
    _socket?.off('membership:updated');
    _socket?.on('membership:updated', (raw) {
      final payload = _coerceMap(raw);
      if (payload != null) {
        AppLogger.v(_m, 'Received membership:updated');
        handler(payload);
      }
    });
  }

  /// Remove all listeners for a given event (call on screen dispose).
  void off(String event) {
    _socket?.off(event);
  }

  /// Disconnect — call on logout.
  void disconnect() {
    AppLogger.i(_m, 'Disconnecting');
    _socket?.disconnect();
    _socket = null;
    _connected = false;
  }

  void dispose() {
    _notifController.close();
    _connController.close();
    disconnect();
  }

  bool get isConnected => _connected;
}
