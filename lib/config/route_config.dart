import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:experiment_planner/providers/auth_provider.dart';
import 'package:experiment_planner/screens/admin_dashboard_screen.dart';
import 'package:experiment_planner/screens/login_screen.dart';
import 'package:experiment_planner/screens/main_screen.dart';
import 'package:experiment_planner/screens/status/loading_screen.dart';
import 'package:experiment_planner/screens/status/pending_approval_screen.dart';
import 'package:experiment_planner/screens/status/access_denied_screen.dart';

// Import all screens from maintenance module
import 'package:experiment_planner/modules/maintenance_module/screens/calibration_screen.dart';
import 'package:experiment_planner/modules/maintenance_module/screens/documentation_screen.dart';
import 'package:experiment_planner/modules/maintenance_module/screens/remote_assistance_screen.dart';
import 'package:experiment_planner/modules/maintenance_module/screens/reporting_screen.dart';
import 'package:experiment_planner/modules/maintenance_module/screens/safety_procedures_screen.dart';
import 'package:experiment_planner/modules/maintenance_module/screens/spare_parts_screen.dart';
import 'package:experiment_planner/modules/maintenance_module/screens/troubleshooting_screen.dart';

// Import all screens from system operation module
import 'package:experiment_planner/modules/system_operation_also_main_module/screens/main_dashboard.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/screens/recipe_management_screen.dart';
import 'package:experiment_planner/modules/system_operation_also_main_module/screens/system_overview_screen.dart';

class RouteConfig {
  static Map<String, Widget Function(BuildContext)> get routes => {
        '/': (context) => _handleAuthState(context),
        '/main_dashboard': (context) => MainDashboard(),
        '/system_overview': (context) => SystemOverviewScreen(),
        '/calibration': (context) => CalibrationScreen(),
        '/reporting': (context) => ReportingScreen(),
        '/troubleshooting': (context) => TroubleshootingScreen(),
        '/spare_parts': (context) => SparePartsScreen(),
        '/documentation': (context) => DocumentationScreen(),
        '/remote_assistance': (context) => RemoteAssistanceScreen(),
        '/safety_procedures': (context) => SafetyProceduresScreen(),
        '/recipe_management': (context) => RecipeManagementScreen(),
        '/overview': (context) => SystemOverviewScreen(),
        '/admin_dashboard': (context) => AdminDashboardScreen(),
      };

  static Widget _handleAuthState(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, authProvider, _) {
        if (authProvider.isLoading()) {
          return LoadingScreen();
        }
        if (authProvider.isAuthenticated) {
          if (authProvider.userStatus == 'approved' ||
              authProvider.userStatus == 'active') {
            return MainScreen();
          } else if (authProvider.userStatus == 'pending') {
            return PendingApprovalScreen();
          } else {
            return AccessDeniedScreen();
          }
        } else {
          return LoginScreen();
        }
      },
    );
  }
}