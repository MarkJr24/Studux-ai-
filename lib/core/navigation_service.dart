import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../presentation/screens/auth/role_selection_screen.dart';
import '../presentation/screens/auth/student_login_screen.dart';
import '../presentation/screens/auth/teacher_login_screen.dart';
import '../presentation/screens/auth/admin_login_screen.dart';
import '../presentation/screens/student/student_home_screen.dart';
import '../presentation/screens/teacher/teacher_home_screen.dart';
import '../presentation/screens/admin/admin_home_screen.dart';

/// Navigation Service - Handles secure role-based navigation
/// 
/// CRITICAL RULES:
/// 1. After login → Use pushAndRemoveUntil to clear entire stack
/// 2. Home screens become permanent root for each role
/// 3. Back button NEVER returns to login screens
/// 4. Logout is the ONLY way back to login
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  /// Navigate to login screen (used only on logout)
  /// Clears entire navigation stack
  void navigateToLogin() {
    if (context == null) return;
    
    Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false, // Remove ALL previous routes
    );
  }

  /// Navigate to Student Home after successful login
  /// SECURITY: Clears login screens from stack permanently
  void navigateToStudentHome() {
    if (context == null) return;
    
    Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
      (route) => false, // Remove ALL previous routes including login
    );
  }

  /// Navigate to Teacher/Faculty Home after successful login
  /// SECURITY: Clears login screens from stack permanently
  void navigateToTeacherHome() {
    if (context == null) return;
    
    Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute(builder: (_) => const TeacherHomeScreen()),
      (route) => false, // Remove ALL previous routes including login
    );
  }

  /// Navigate to Admin Home after successful login
  /// SECURITY: Clears login screens from stack permanently
  void navigateToAdminHome() {
    if (context == null) return;
    
    Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
      (route) => false, // Remove ALL previous routes including login
    );
  }

  /// Navigate to any screen (used for internal navigation)
  /// Uses regular push - back button will return to previous screen
  void navigateTo(Widget screen) {
    if (context == null) return;
    
    Navigator.push(
      context!,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Navigate and replace current screen
  /// Used for bottom nav tab switching
  void navigateAndReplace(Widget screen) {
    if (context == null) return;
    
    Navigator.pushReplacement(
      context!,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Pop current screen
  void pop() {
    if (context == null) return;
    if (Navigator.canPop(context!)) {
      Navigator.pop(context!);
    }
  }

  /// Check if can pop
  bool canPop() {
    if (context == null) return false;
    return Navigator.canPop(context!);
  }
}

/// Login Success Handler
/// 
/// Example usage in login screens:
/// ```dart
/// void _handleLoginSuccess(String role) {
///   final nav = NavigationService();
///   
///   switch (role) {
///     case 'student':
///       nav.navigateToStudentHome();
///       break;
///     case 'teacher':
///       nav.navigateToTeacherHome();
///       break;
///     case 'admin':
///       nav.navigateToAdminHome();
///       break;
///   }
/// }
/// ```
class LoginSuccessHandler {
  static void handleStudentLogin(BuildContext context) {
    // Clear any cached data, initialize session, etc.
    
    // Navigate to Student Home and clear entire stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
      (route) => false, // CRITICAL: Removes ALL routes including login
    );
  }

  static void handleTeacherLogin(BuildContext context) {
    // Clear any cached data, initialize session, etc.
    
    // Navigate to Teacher Home and clear entire stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TeacherHomeScreen()),
      (route) => false, // CRITICAL: Removes ALL routes including login
    );
  }

  static void handleAdminLogin(BuildContext context) {
    // Clear any cached data, initialize session, etc.
    
    // Navigate to Admin Home and clear entire stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
      (route) => false, // CRITICAL: Removes ALL routes including login
    );
  }
}

/// Logout Handler
/// 
/// Example usage in profile screens:
/// ```dart
/// void _handleLogout() {
///   LogoutHandler.logout(context);
/// }
/// ```
class LogoutHandler {
  static void logout(BuildContext context) {
    // Clear session data, tokens, cached data, etc.
    
    // Navigate back to login and clear entire stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false, // Remove ALL routes
    );
  }
}
