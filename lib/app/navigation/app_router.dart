import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../plugin_catalog/plugin_catalog_screen.dart';

class AppRouter {
  static const String catalogRoute = '/';
  static const String dashboardRoute = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case catalogRoute:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const PluginCatalogScreen(),
          settings: settings,
        );
    }
  }
}
