/// Storage categories for organizing data
enum StorageCategory {
  settings,
  monitoring,
  machine,
  session,
  recipe,
  analysis,
  user
}

/// Storage operations result
class StorageResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final DateTime timestamp;

  StorageResult({
    required this.success,
    this.data,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get hasError => error != null;
}