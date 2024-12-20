class NetworkException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  NetworkException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  CacheException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'CacheException: $message';
}

class MonitoringException implements Exception {
  final String message;

  MonitoringException(this.message);

  @override
  String toString() => 'MonitoringException: $message';
}
