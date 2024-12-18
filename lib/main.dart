import 'package:flutter/material.dart';
import 'package:experiment_planner/config/app_config.dart';
import 'package:experiment_planner/services/auth_service.dart';
import 'package:experiment_planner/services/navigation_service.dart';

void main() async {
  await AppConfig.initializeApp();

  final authService = AuthService();
  final navigationService = NavigationService();

  runApp(AppConfig.buildApp(navigationService));
}