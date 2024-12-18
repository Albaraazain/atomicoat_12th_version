// lib/utils/navigation_helper.dart

import 'package:flutter/material.dart';
import '../enums/navigation_item.dart';
import '../screens/main_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../modules/system_operation_also_main_module/screens/recipe_management_screen.dart';
import '../modules/maintenance_module/screens/calibration_screen.dart';
import '../modules/maintenance_module/screens/reporting_screen.dart';
import '../modules/maintenance_module/screens/troubleshooting_screen.dart';
import '../modules/maintenance_module/screens/spare_parts_screen.dart';
import '../modules/maintenance_module/screens/documentation_screen.dart';
import '../modules/maintenance_module/screens/remote_assistance_screen.dart';
import '../modules/maintenance_module/screens/safety_procedures_screen.dart';
import '../modules/maintenance_module/screens/maintenance_home_screen.dart';

void handleNavigation(BuildContext context, NavigationItem item) {
  switch (item) {
    case NavigationItem.mainDashboard:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
      break;
    case NavigationItem.adminDashboard:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboardScreen()));
      break;
    case NavigationItem.recipeManagement:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RecipeManagementScreen()));
      break;
    case NavigationItem.calibration:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CalibrationScreen()));
      break;
    case NavigationItem.reporting:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReportingScreen()));
      break;
    case NavigationItem.troubleshooting:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TroubleshootingScreen()));
      break;
    case NavigationItem.spareParts:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SparePartsScreen()));
      break;
    case NavigationItem.documentation:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DocumentationScreen()));
      break;
    case NavigationItem.remoteAssistance:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RemoteAssistanceScreen()));
      break;
    case NavigationItem.safetyProcedures:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SafetyProceduresScreen()));
      break;
    case NavigationItem.overview:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MaintenanceHomeScreen()));
      break;
    case NavigationItem.schedule:
      // TODO: Implement navigation for schedule
      break;
    case NavigationItem.reports:
      // TODO: Implement navigation for reports
      break;
    default:
      break;
  }
}