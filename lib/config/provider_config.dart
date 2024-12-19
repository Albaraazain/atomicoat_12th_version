import 'package:experiment_planner/features/alarm/bloc/alarm_bloc.dart';
import 'package:experiment_planner/features/alarm/repository/alarm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

// Services
import 'package:experiment_planner/services/auth_service.dart';
import 'package:experiment_planner/services/navigation_service.dart';

// Repositories
import 'package:experiment_planner/repositories/system_state_repository.dart';

// Providers
import 'package:experiment_planner/providers/auth_provider.dart';

// Maintenance Module Providers
import 'package:experiment_planner/modules/maintenance_module/providers/maintenance_provider.dart';
import 'package:experiment_planner/modules/maintenance_module/providers/calibration_provider.dart';
import 'package:experiment_planner/modules/maintenance_module/providers/spare_parts_provider.dart';
import 'package:experiment_planner/modules/maintenance_module/providers/report_provider.dart';

// System Operation Module Providers
import 'package:experiment_planner/modules/system_operation_also_main_module/providers/recipe_provider.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/providers/safety_error_provider.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/providers/system_copmonent_provider.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/providers/system_state_provider.dart';

// Services
import 'package:experiment_planner/modules/system_operation_also_main_module/services/system_logging_service.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/services/system_validation_service.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/services/recipe_execution_service.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/services/alarm_handling_service.dart';

class ProviderConfig {
  static List<SingleChildWidget> get providers => [
        // Core Services
        Provider<NavigationService>(
          create: (_) => NavigationService(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<SystemStateRepository>(
          create: (_) => SystemStateRepository(),
        ),
        Provider<AlarmRepository>(
          create: (_) => AlarmRepository(),
        ),

        // BLoC Providers
        BlocProvider<AlarmBloc>(
          create: (context) => AlarmBloc(
            context.read<AlarmRepository>(),
            context.read<AuthService>().currentUserId,
          ),
        ),

        // Base Providers
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<SystemComponentProvider>(
          create: (_) => SystemComponentProvider(),
        ),

        // System Operation Services - These need to be before providers that depend on them
        Provider<SystemLoggingService>(
          create: (context) => SystemLoggingService(
            context.read<SystemStateRepository>(),
          ),
        ),
        Provider<SystemValidationService>(
          create: (context) => SystemValidationService(
            context.read<SystemComponentProvider>(),
          ),
        ),
        Provider<RecipeExecutionService>(
          create: (context) => RecipeExecutionService(
            context.read<SystemComponentProvider>(),
          ),
        ),
        Provider<AlarmHandlingService>(
          create: (context) => AlarmHandlingService(
            context.read<AlarmBloc>(),
          ),
        ),

        // Recipe and Safety Providers
        ChangeNotifierProxyProvider<AuthService, RecipeProvider>(
          create: (context) => RecipeProvider(context.read<AuthService>()),
          update: (context, auth, previous) =>
              previous ?? RecipeProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, SafetyErrorProvider>(
          create: (context) => SafetyErrorProvider(context.read<AuthService>()),
          update: (context, auth, previous) =>
              previous ?? SafetyErrorProvider(auth),
        ),

        // SystemStateProvider with Dependencies
        ChangeNotifierProxyProvider6<
            SystemComponentProvider,
            AuthService,
            SystemLoggingService,
            SystemValidationService,
            RecipeExecutionService,
            AlarmHandlingService,
            SystemStateProvider>(
          lazy: false, // Important: ensures immediate initialization
          create: (context) => SystemStateProvider(
            context.read<SystemComponentProvider>(),
            context.read<AuthService>(),
            context.read<SystemLoggingService>(),
            context.read<SystemValidationService>(),
            context.read<RecipeExecutionService>(),
            context.read<AlarmHandlingService>(),
            context.read<RecipeProvider>(),
          ),
          update: (context, componentProvider, authService, loggingService,
              validationService, recipeExecutionService, alarmService, previous) {
            if (previous == null) {
              return SystemStateProvider(
                componentProvider,
                authService,
                loggingService,
                validationService,
                recipeExecutionService,
                alarmService,
                context.read<RecipeProvider>(),
              );
            }
            return previous;
          },
        ),

        // Maintenance Module Providers
        ChangeNotifierProvider<MaintenanceProvider>(
          create: (context) => MaintenanceProvider(
            context.read<SystemComponentProvider>(),
          ),
        ),
        ChangeNotifierProvider<CalibrationProvider>(
          create: (context) => CalibrationProvider(
            context.read<SystemComponentProvider>(),
          ),
        ),
        ChangeNotifierProvider<SparePartsProvider>(
          create: (_) => SparePartsProvider(),
        ),

        // Report Provider (depends on Maintenance and Calibration)
        ChangeNotifierProxyProvider2<MaintenanceProvider, CalibrationProvider, ReportProvider>(
          create: (context) => ReportProvider(
            context.read<MaintenanceProvider>(),
            context.read<CalibrationProvider>(),
          ),
          update: (context, maintenance, calibration, previous) =>
              previous!..updateProviders(maintenance, calibration),
        ),
      ];
}
