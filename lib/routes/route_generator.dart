import 'package:flutter/material.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../../routes/app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments if any
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.roleSelection:
        // You'll need to pass theme toggle and mode from the app
        return MaterialPageRoute(
          builder: (_) => RoleSelectionScreen(
            onThemeToggle: () {}, // Will be handled by provider later
            themeMode: ThemeMode.light,
          ),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            onThemeToggle: () {}, // Will be handled by provider later
            themeMode: ThemeMode.light,
          ),
        );

      // Add more routes here as you create screens
      // case AppRoutes.register:
      //   return MaterialPageRoute(builder: (_) => RegisterScreen());
      
      // case AppRoutes.studentDashboard:
      //   return MaterialPageRoute(builder: (_) => StudentDashboard());

      default:
        // Return error page for undefined routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
