// lib/core/services/websocket/websocket_service.dart
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:rxdart/rxdart.dart';

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error
}

class WebSocketService {
  final String baseUrl;
  final Duration pingInterval;
  final Duration reconnectDelay;
  final int maxReconnectAttempts;

  WebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  final _connectionStateController = BehaviorSubject<ConnectionState>
    .seeded(ConnectionState.disconnected);
  final _messagesController = BehaviorSubject<dynamic>();

  WebSocketService({
    required this.baseUrl,
    this.pingInterval = const Duration(seconds: 30),
    this.reconnectDelay = const Duration(seconds: 5),
    this.maxReconnectAttempts = 5,
  });

  Stream<ConnectionState> get connectionState => _connectionStateController.stream;
  Stream<dynamic> get messages => _messagesController.stream;

  Future<void> connect() async {
    if (_channel != null) return;

    try {
      _connectionStateController.add(ConnectionState.connecting);

      _channel = WebSocketChannel.connect(
        Uri.parse('$baseUrl/ws'),
      );

      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
          _resetReconnectAttempts();
        },
        onError: (error) {
          print('WebSocket error: $error');
          _handleError(error);
        },
        onDone: () {
          print('WebSocket connection closed');
          _handleDisconnection();
        },
      );

      _connectionStateController.add(ConnectionState.connected);
      _startPingTimer();
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _handleError(e);
    }
  }

  void _handleMessage(dynamic message) {
    if (message == 'pong') {
      // Handle ping response
      return;
    }
    _messagesController.add(message);
  }

  void _handleError(dynamic error) {
    _connectionStateController.add(ConnectionState.error);
    _scheduleReconnect();
  }

  void _handleDisconnection() {
    _connectionStateController.add(ConnectionState.disconnected);
    _cleanupConnection();
    _scheduleReconnect();
  }

  void _cleanupConnection() {
    _channel?.sink.close();
    _channel = null;
    _stopPingTimer();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      print('Max reconnection attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      reconnectDelay * (_reconnectAttempts + 1),
      () {
        _reconnectAttempts++;
        _connectionStateController.add(ConnectionState.reconnecting);
        connect();
      },
    );
  }

  void _resetReconnectAttempts() {
    _reconnectAttempts = 0;
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(pingInterval, (timer) {
      if (_channel != null) {
        _channel!.sink.add('ping');
      }
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> disconnect() async {
    _cleanupConnection();
    _reconnectTimer?.cancel();
    await _messagesController.close();
    await _connectionStateController.close();
  }
}