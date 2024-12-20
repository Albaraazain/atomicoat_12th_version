// lib/domain/interfaces/core/i_cache_manager.dart

abstract class ICacheManager {
  /// Stores a value in the cache with the specified key
  Future<void> put<T>(String key, T value, {Duration? expiration});

  /// Retrieves a value from the cache by key
  Future<T?> get<T>(String key);

  /// Checks if a key exists in the cache
  Future<bool> containsKey(String key);

  /// Removes a value from the cache by key
  Future<bool> remove(String key);

  /// Clears all values from the cache
  Future<void> clear();

  /// Checks if a key has expired
  Future<bool> hasExpired(String key);

  /// Updates the expiration time for a key
  Future<bool> updateExpiration(String key, Duration expiration);

  /// Gets all keys matching a pattern
  Future<List<String>> getKeysByPattern(String pattern);

  /// Gets multiple values by their keys
  Future<Map<String, T>> getMultiple<T>(List<String> keys);

  /// Stores multiple key-value pairs
  Future<void> putMultiple<T>(Map<String, T> entries, {Duration? expiration});
}