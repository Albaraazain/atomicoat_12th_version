// lib/domain/interfaces/core/i_local_storage.dart

abstract class ILocalStorage {
  /// Stores a value with the given key
  Future<void> write<T>(String key, T value);

  /// Retrieves a value by key
  Future<T?> read<T>(String key);

  /// Deletes a value by key
  Future<void> delete(String key);

  /// Checks if a key exists
  Future<bool> exists(String key);

  /// Clears all stored data
  Future<void> clear();

  /// Retrieves all keys
  Future<List<String>> getAllKeys();

  /// Stores multiple key-value pairs
  Future<void> writeAll<T>(Map<String, T> entries);

  /// Retrieves multiple values by their keys
  Future<Map<String, T>> readAll<T>(List<String> keys);

  /// Gets the storage size in bytes
  Future<int> getSize();

  /// Backs up storage to a file
  Future<String> backup();

  /// Restores storage from a backup file
  Future<bool> restore(String backupPath);

  /// Watches changes for a specific key
  Stream<T?> watch<T>(String key);

  /// Gets creation timestamp for a key
  Future<DateTime?> getCreatedAt(String key);

  /// Gets last modified timestamp for a key
  Future<DateTime?> getLastModified(String key);
}

