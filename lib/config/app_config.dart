import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:experiment_planner/config/provider_config.dart';
import 'package:experiment_planner/config/theme_config.dart';
import 'package:experiment_planner/config/route_config.dart';
import 'package:experiment_planner/services/navigation_service.dart';

class AppConfig {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (e) {
      print('Failed to initialize Firebase: $e');
    }
  }

  static Widget buildApp(NavigationService navigationService) {
    return MultiProvider(
      providers: ProviderConfig.providers,
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: 'ALD Machine Maintenance',
            navigatorKey: Provider.of<NavigationService>(context, listen: false)
                .navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.teslaTheme,
            initialRoute: '/',
            routes: RouteConfig.routes,
          );
        },
      ),
    );
  }
}