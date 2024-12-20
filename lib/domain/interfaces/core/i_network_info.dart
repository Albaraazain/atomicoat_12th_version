// lib/domain/interfaces/core/i_network_info.dart

import 'package:experiment_planner/domain/enums/network_enums.dart';

abstract class INetworkInfo {
  /// Checks if the device has an active internet connection
  Future<bool> get isConnected;

  /// Gets the current connection type (wifi, ethernet, cellular, etc.)
  Future<ConnectionType> get connectionType;

  /// Gets the current network quality metrics
  Future<NetworkQuality> get networkQuality;

  /// Streams network connectivity changes
  Stream<bool> get onConnectivityChanged;

  /// Streams connection type changes
  Stream<ConnectionType> get onConnectionTypeChanged;

  /// Tests the connection to a specific host
  Future<ConnectionTestResult> testConnection(String host, {Duration? timeout});

  /// Gets the current IP address
  Future<String?> get ipAddress;

  /// Gets detailed network interface information
  Future<List<NetworkInterface>> get networkInterfaces;

  /// Checks if a specific port is accessible
  Future<bool> isPortAccessible(String host, int port);

  /// Gets network statistics
  Future<NetworkStats> get networkStats;
}

/// Represents network quality metrics
class NetworkQuality {
  final double latency; // in milliseconds
  final double downloadSpeed; // in Mbps
  final double uploadSpeed; // in Mbps
  final double packetLoss; // percentage
  final DateTime timestamp;

  NetworkQuality({
    required this.latency,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.packetLoss,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isGoodQuality =>
      latency < 100 && downloadSpeed > 5 && uploadSpeed > 2 && packetLoss < 1;
}

/// Represents the result of a connection test
class ConnectionTestResult {
  final bool isSuccessful;
  final double latency;
  final String? errorMessage;
  final DateTime timestamp;

  ConnectionTestResult({
    required this.isSuccessful,
    required this.latency,
    this.errorMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Represents network interface information
class NetworkInterface {
  final String name;
  final String address;
  final ConnectionType type;
  final bool isUp;
  final Map<String, dynamic> metadata;

  NetworkInterface({
    required this.name,
    required this.address,
    required this.type,
    required this.isUp,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};
}

/// Represents network statistics
class NetworkStats {
  final int bytesSent;
  final int bytesReceived;
  final int packetsSent;
  final int packetsReceived;
  final int errorCount;
  final DateTime since;
  final DateTime timestamp;

  NetworkStats({
    required this.bytesSent,
    required this.bytesReceived,
    required this.packetsSent,
    required this.packetsReceived,
    required this.errorCount,
    required this.since,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}