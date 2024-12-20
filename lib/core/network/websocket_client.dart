import 'dart:async';
import 'dart:convert';
import 'package:experiment_planner/core/error/exceptions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String baseUrl;
  final Map<String, WebSocketChannel> _connections = {};
  final Duration pingInterval;

  WebSocketClient({
    required this.baseUrl,
    this.pingInterval = const Duration(seconds: 30),
  });

  Stream<Map<String, dynamic>> connect(String path) {
    final uri = Uri.parse('$baseUrl/$path');

    if (_connections.containsKey(path)) {
      return _connections[path]!.stream
          .map((data) => jsonDecode(data) as Map<String, dynamic>);
    }

    final channel = WebSocketChannel.connect(uri);
    _connections[path] = channel;

    // Setup ping/pong mechanism
    Timer.periodic(pingInterval, (timer) {
      if (channel.closeCode != null) {
        timer.cancel();
        _connections.remove(path);
        return;
      }
      channel.sink.add(jsonEncode({'type': 'ping'}));
    });

    return channel.stream
        .map((data) => jsonDecode(data) as Map<String, dynamic>)
        .handleError((error) {
          throw NetworkException(
            message: 'WebSocket error: $error',
            code: 'WS_ERROR',
          );
        });
  }

  void disconnect(String path) {
    final channel = _connections[path];
    if (channel != null) {
      channel.sink.close();
      _connections.remove(path);
    }
  }

  void disconnectAll() {
    for (final channel in _connections.values) {
      channel.sink.close();
    }
    _connections.clear();
  }
}
