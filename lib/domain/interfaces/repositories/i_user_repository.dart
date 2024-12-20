// lib/domain/interfaces/repositories/i_user_repository.dart

import 'package:dartz/dartz.dart';
import 'package:experiment_planner/domain/entities/user/user.dart';
import 'package:experiment_planner/domain/enums/user_enums.dart';
import 'package:experiment_planner/domain/failures/failures.dart';
import 'package:experiment_planner/domain/interfaces/datasources/i_user_datasource.dart';

abstract class IUserRepository {
  /// Registers a new user
  Future<Either<Failure, String>> registerUser(
    String email,
    String password,
    String machineSerial,
  );

  /// Authenticates a user
  Future<Either<Failure, AuthResponse>> authenticateUser(
    String email,
    String password,
  );

  /// Gets user by ID
  Future<Either<Failure, User>> getUser(String userId);

  /// Gets current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Updates user information
  Future<Either<Failure, void>> updateUser(User user);

  /// Updates user password
  Future<Either<Failure, void>> updatePassword(
    String userId,
    String currentPassword,
    String newPassword,
  );

  /// Gets users for a specific machine
  Future<Either<Failure, List<User>>> getMachineUsers(String machineId);

  /// Updates user role
  Future<Either<Failure, void>> updateUserRole(
    String userId,
    UserRole newRole,
    String updatedBy,
  );

  /// Gets user permissions
  Future<Either<Failure, UserPermissions>> getUserPermissions(String userId);

  /// Updates user permissions
  Future<Either<Failure, void>> updateUserPermissions(
    String userId,
    UserPermissions permissions,
    String updatedBy,
  );

  /// Deactivates a user account
  Future<Either<Failure, void>> deactivateUser(String userId);

  /// Reactivates a user account
  Future<Either<Failure, void>> reactivateUser(String userId);

  /// Gets user activity history
  Future<Either<Failure, List<UserActivity>>> getUserActivity(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    ActivityType? type,
  });

  /// Validates user credentials
  Future<Either<Failure, bool>> validateCredentials(
    String email,
    String password,
  );

  /// Requests password reset
  Future<Either<Failure, void>> requestPasswordReset(String email);

  /// Resets password with token
  Future<Either<Failure, void>> resetPassword(
    String token,
    String newPassword,
  );

  /// Gets user preferences
  Future<Either<Failure, UserPreferences>> getUserPreferences(String userId);

  /// Updates user preferences
  Future<Either<Failure, void>> updateUserPreferences(
    String userId,
    UserPreferences preferences,
  );

  /// Gets user session data
  Future<Either<Failure, UserSession?>> getCurrentSession();

  /// Records user action for audit
  Future<Either<Failure, void>> recordUserAction(UserAction action);

  /// Gets user statistics
  Future<Either<Failure, UserStatistics>> getUserStatistics(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Authentication response
class AuthResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final User user;
  final UserPermissions permissions;

  AuthResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
    required this.permissions,
  });
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
  final Map<String, PermissionLevel> moduleAccess;

  UserPermissions({
    required this.canModifyRecipes,
    required this.canStartExperiments,
    required this.canModifySettings,
    required this.canExportData,
    required this.canManageUsers,
    required this.canAccessMaintenance,
    required this.accessibleMachines,
    required this.componentAccess,
    required this.moduleAccess,
  });

  bool hasAccessToMachine(String machineId) => accessibleMachines.contains(machineId);

  bool hasAccessToComponent(String machineId, String componentId) =>
      componentAccess[machineId]?.contains(componentId) ?? false;

  bool hasModuleAccess(String module, PermissionLevel requiredLevel) {
    final userLevel = moduleAccess[module] ?? PermissionLevel.none;
    return userLevel.index >= requiredLevel.index;
  }
}

/// Permission levels
enum PermissionLevel {
  none,
  read,
  write,
  admin
}

/// User preferences
class UserPreferences {
  final Map<String, dynamic> displaySettings;
  final Map<String, dynamic> notificationSettings;
  final Map<String, dynamic> experimentDefaults;
  final List<String> favoriteRecipes;
  final Map<String, dynamic> dashboardLayout;
  final ThemePreference themePreference;
  final ExperimentPreferences experimentPreferences;

  UserPreferences({
    required this.displaySettings,
    required this.notificationSettings,
    required this.experimentDefaults,
    required this.favoriteRecipes,
    required this.dashboardLayout,
    required this.themePreference,
    required this.experimentPreferences,
  });
}

/// Theme preferences
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

/// Experiment preferences
class ExperimentPreferences {
  final Map<String, double> defaultParameters;
  final Map<String, AlertThreshold> alertThresholds;
  final Duration defaultMonitoringInterval;
  final List<String> preferredCharts;
  final Map<String, bool> autoExport;

  ExperimentPreferences({
    required this.defaultParameters,
    required this.alertThresholds,
    required this.defaultMonitoringInterval,
    required this.preferredCharts,
    required this.autoExport,
  });
}

/// Alert threshold settings
class AlertThreshold {
  final double warningLevel;
  final double criticalLevel;
  final bool enabled;
  final String? unit;

  AlertThreshold({
    required this.warningLevel,
    required this.criticalLevel,
    required this.enabled,
    this.unit,
  });
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

/// User action record
class UserAction {
  final String userId;
  final DateTime timestamp;
  final ActionType type;
  final String description;
  final String? targetId;
  final Map<String, dynamic>? metadata;
  final ActionResult result;

  UserAction({
    required this.userId,
    required this.timestamp,
    required this.type,
    required this.description,
    this.targetId,
    this.metadata,
    required this.result,
  });
}

/// Action types
enum ActionType {
  login,
  logout,
  recipeCreation,
  recipeModification,
  experimentStart,
  experimentEnd,
  parameterChange,
  systemConfiguration,
  userManagement,
  dataExport
}

/// Action result
enum ActionResult {
  success,
  failure,
  warning,
  cancelled
}

/// User statistics
class UserStatistics {
  final int totalExperiments;
  final int successfulExperiments;
  final Duration totalExperimentTime;
  final Map<String, int> experimentsByRecipe;
  final Map<ActionType, int> actionCounts;
  final double successRate;
  final List<UserActivity> recentActivity;

  UserStatistics({
    required this.totalExperiments,
    required this.successfulExperiments,
    required this.totalExperimentTime,
    required this.experimentsByRecipe,
    required this.actionCounts,
    required this.successRate,
    required this.recentActivity,
  });
}