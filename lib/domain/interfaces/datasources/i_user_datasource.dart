// lib/domain/interfaces/datasources/i_user_datasource.dart

import 'package:experiment_planner/domain/entities/user/user.dart';
import 'package:experiment_planner/domain/enums/user_enums.dart';

abstract class IUserDataSource {
  /// Registers a new user
  Future<String> registerUser(String email, String password, String machineSerial);

  /// Authenticates a user
  Future<User> authenticateUser(String email, String password);

  /// Gets user by ID
  Future<User?> getUser(String userId);

  /// Updates user information
  Future<void> updateUser(User user);

  /// Updates user password
  Future<void> updatePassword(
    String userId,
    String currentPassword,
    String newPassword,
  );

  /// Gets users for a specific machine
  Future<List<User>> getMachineUsers(String machineId);

  /// Updates user role
  Future<void> updateUserRole(String userId, UserRole newRole);

  /// Gets user preferences
  Future<UserPreferences> getUserPreferences(String userId);

  /// Updates user preferences
  Future<void> updateUserPreferences(String userId, UserPreferences preferences);

  /// Deactivates a user account
  Future<void> deactivateUser(String userId);

  /// Reactivates a user account
  Future<void> reactivateUser(String userId);

  /// Gets user activity history
  Future<List<UserActivity>> getUserActivity(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Validates user credentials
  Future<bool> validateCredentials(String email, String password);

  /// Gets user permissions
  Future<UserPermissions> getUserPermissions(String userId);

  /// Updates user permissions
  Future<void> updateUserPermissions(
    String userId,
    UserPermissions permissions,
  );

  /// Requests password reset
  Future<void> requestPasswordReset(String email);

  /// Resets password with token
  Future<void> resetPassword(String token, String newPassword);

  /// Gets user session data
  Future<UserSession?> getCurrentSession(String userId);
}

/// User preferences
class UserPreferences {
  final Map<String, dynamic> displaySettings;
  final Map<String, dynamic> notificationSettings;
  final Map<String, dynamic> experimentDefaults;
  final List<String> favoriteRecipes;
  final Map<String, dynamic> dashboardLayout;
  final ThemePreference themePreference;

  UserPreferences({
    required this.displaySettings,
    required this.notificationSettings,
    required this.experimentDefaults,
    required this.favoriteRecipes,
    required this.dashboardLayout,
    required this.themePreference,
  });
}

/// Theme preference settings
class ThemePreference {
  final bool isDarkMode;
  final String? accentColor;
  final double fontSize;
  final bool useSystemTheme;

  ThemePreference({
    required this.isDarkMode,
    this.accentColor,
    required this.fontSize,
    required this.useSystemTheme,
  });
}

/// User activity record
class UserActivity {
  final String id;
  final DateTime timestamp;
  final ActivityType type;
  final String description;
  final Map<String, dynamic>? metadata;
  final String? targetId;

  UserActivity({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.description,
    this.metadata,
    this.targetId,
  });
}

/// Types of user activities
enum ActivityType {
  login,
  logout,
  experimentStart,
  experimentEnd,
  recipeModification,
  systemConfiguration,
  userPreferencesUpdate,
  dataExport,
  passwordChange
}

/// User permissions
class UserPermissions {
  final bool canModifyRecipes;
  final bool canStartExperiments;
  final bool canModifySettings;
  final bool canExportData;
  final bool canManageUsers;
  final bool canAccessMaintenance;
  final Set<String> accessibleMachines;
  final Map<String, Set<String>> componentAccess;

  UserPermissions({
    required this.canModifyRecipes,
    required this.canStartExperiments,
    required this.canModifySettings,
    required this.canExportData,
    required this.canManageUsers,
    required this.canAccessMaintenance,
    required this.accessibleMachines,
    required this.componentAccess,
  });

  bool hasAccessToMachine(String machineId) => accessibleMachines.contains(machineId);
  bool hasAccessToComponent(String machineId, String componentId) =>
      componentAccess[machineId]?.contains(componentId) ?? false;
}

/// User session information
class UserSession {
  final String sessionId;
  final DateTime loginTime;
  final String deviceInfo;
  final String ipAddress;
  final DateTime lastActivityTime;
  final Map<String, dynamic> sessionData;

  UserSession({
    required this.sessionId,
    required this.loginTime,
    required this.deviceInfo,
    required this.ipAddress,
    required this.lastActivityTime,
    required this.sessionData,
  });

  bool get isExpired =>
      DateTime.now().difference(lastActivityTime) > Duration(hours: 24);
}