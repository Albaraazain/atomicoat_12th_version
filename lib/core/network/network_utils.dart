import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class NetworkUtils {
  static bool isNetworkError(Exception error) {
    return error is NetworkException || error is DioException;
  }

  static String getErrorMessage(Exception error) {
    if (error is NetworkException) {
      return error.message;
    } else if (error is DioException) {
      return error.message ?? 'Network error occurred';
    }
    return 'An unexpected error occurred';
  }

  static bool shouldRetry(Exception error) {
    if (error is NetworkException) {
      return error.code == 'TIMEOUT' || error.code == 'NO_CONNECTION';
    }
    return false;
  }
}
