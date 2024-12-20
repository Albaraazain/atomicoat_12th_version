import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// lib/core/network/network_info.dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<InternetConnectionStatus> get connectionStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  final Connectivity _connectivity;

  NetworkInfoImpl(this.connectionChecker) : _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    // First check if we have any connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Then verify if we actually have internet
    return connectionChecker.hasConnection;
  }

  @override
  Stream<InternetConnectionStatus> get connectionStream =>
      connectionChecker.onStatusChange;
}