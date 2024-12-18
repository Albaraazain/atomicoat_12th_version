import 'package:experiment_planner/features/alarm/bloc/alarm_bloc.dart';
import 'package:experiment_planner/features/alarm/repository/alarm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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

// New Alarm BLoC

class ProviderConfig {
  static List<SingleChildWidget> get providers => [
        // Services
        Provider<NavigationService>(
          create: (_) => NavigationService(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<SystemStateRepository>(
          create: (_) => SystemStateRepository(),
        ),

        // Repositories
        Provider<AlarmRepository>(
          create: (_) => AlarmRepository(),
        ),

        // Global Providers
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => SystemComponentProvider(),
        ),

        // BLoC Providers
        BlocProvider<AlarmBloc>(
          create: (context) => AlarmBloc(
            context.read<AlarmRepository>(),
            context.read<AuthService>().currentUserId,
          ),
        ),

        // Maintenance Module Providers
        ChangeNotifierProvider(
          create: (context) => MaintenanceProvider(
            context.read<SystemComponentProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CalibrationProvider(
            context.read<SystemComponentProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SparePartsProvider(),
        ),

        // System Operation Module Providers
        ChangeNotifierProvider(
          create: (context) => SafetyErrorProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => RecipeProvider(context.read<AuthService>()),
        ),

        // System State Provider
        ChangeNotifierProxyProvider4<SystemComponentProvider, RecipeProvider,
            SystemStateRepository, AuthService, SystemStateProvider>(
          create: (context) => SystemStateProvider(
            context.read<SystemComponentProvider>(),
            context.read<RecipeProvider>(),
            context.read<AlarmBloc>(), // Now passing AlarmBloc instead of AlarmProvider
            context.read<SystemStateRepository>(),
            context.read<AuthService>(),
          ),
          update: (context, componentProvider, recipeProvider,
                  systemStateRepository, authService, previous) =>
              previous!..updateProviders(recipeProvider),
        ),

        // Maintenance Module Report Provider
        ChangeNotifierProxyProvider2<MaintenanceProvider, CalibrationProvider,
            ReportProvider>(
          create: (context) => ReportProvider(
            context.read<MaintenanceProvider>(),
            context.read<CalibrationProvider>(),
          ),
          update: (context, maintenance, calibration, previous) =>
              previous!..updateProviders(maintenance, calibration),
        ),
      ];
}