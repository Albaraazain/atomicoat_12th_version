import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';
import '../network/network_info.dart';
import '../network/network_client.dart';
import '../network/websocket_client.dart';
import '../config/app_config.dart';

@module
abstract class NetworkModule {
  @singleton
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 10),
        checkInterval: const Duration(seconds: 60),
      );

  @singleton
  NetworkInfo get networkInfo => NetworkInfoImpl(connectionChecker);

  @singleton
  NetworkClient getNetworkClient(AppConfig config) => NetworkClient(
        baseUrl: config.apiBaseUrl,
        timeout: const Duration(seconds: 30),
      );

  @singleton
  WebSocketClient getWebSocketClient(AppConfig config) => WebSocketClient(
        baseUrl: config.websocketUrl,
      );
}
