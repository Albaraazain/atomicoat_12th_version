import 'package:dio/dio.dart';
import 'package:experiment_planner/core/error/exceptions.dart';

class NetworkClient {
  final Dio _dio;

  NetworkClient({
    required String baseUrl,
    Duration timeout = const Duration(seconds: 30),
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: timeout,
            receiveTimeout: timeout,
            sendTimeout: timeout,
          ),
        );

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: 'Connection timeout',
          code: 'TIMEOUT',
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
          stackTrace: error.stackTrace,
        );
      default:
        return NetworkException(
          message: error.message ?? 'Unknown network error',
          code: error.response?.statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
    }
  }
}
