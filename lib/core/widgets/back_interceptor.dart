import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Back Button Interceptor
/// 
/// Wraps screens to intercept system back button
/// 
/// BEHAVIOR:
/// - On Home screens: Double-back-to-exit pattern
/// - On internal screens: Pop to previous screen (naturally returns to Home)
/// - NEVER allows navigation back to login screens
/// 
/// Usage:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return BackInterceptor(
///     isHomeScreen: true,
///     child: Scaffold(...),
///   );
/// }
/// ```
class BackInterceptor extends StatefulWidget {
  final Widget child;
  final bool isHomeScreen;
  final VoidCallback? onBackPressed;

  const BackInterceptor({
    super.key,
    required this.child,
    this.isHomeScreen = false,
    this.onBackPressed,
  });

  @override
  State<BackInterceptor> createState() => _BackInterceptorState();
}

class _BackInterceptorState extends State<BackInterceptor> {
  DateTime? _lastBackPress;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isHomeScreen) {
          // HOME SCREEN: Double-back-to-exit pattern
          return _handleHomeScreenBack();
        } else {
          // INTERNAL SCREEN: Allow normal pop (returns to Home)
          if (widget.onBackPressed != null) {
            widget.onBackPressed!();
            return false;
          }
          return true; // Allow default pop behavior
        }
      },
      child: widget.child,
    );
  }

  /// Handle back button on Home screens
  /// Implements double-back-to-exit pattern
  Future<bool> _handleHomeScreenBack() async {
    final now = DateTime.now();
    
    if (_lastBackPress == null || 
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      // First back press - show toast
      _lastBackPress = now;
      
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      
      return false; // Don't exit
    }
    
    // Second back press within 2 seconds - exit app
    SystemNavigator.pop();
    return false;
  }
}

/// Alternative: Minimize app instead of exit
/// 
/// Use this if you want back button to minimize app instead of exit
/// 
/// ```dart
/// class BackInterceptorMinimize extends StatelessWidget {
///   final Widget child;
///   final bool isHomeScreen;
/// 
///   const BackInterceptorMinimize({
///     super.key,
///     required this.child,
///     this.isHomeScreen = false,
///   });
/// 
///   @override
///   Widget build(BuildContext context) {
///     return WillPopScope(
///       onWillPop: () async {
///         if (isHomeScreen) {
///           // Minimize app to background
///           SystemChannels.platform.invokeMethod('SystemNavigator.pop');
///           return false;
///         }
///         return true; // Allow normal pop
///       },
///       child: child,
///     );
///   }
/// }
/// ```

/// Global Back Button Handler
/// 
/// Alternative approach using Navigator observer
/// Can be added to MaterialApp's navigatorObservers
class BackButtonObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    
    // Log navigation for debugging
    debugPrint('Popped from: ${route.settings.name}');
    debugPrint('Returned to: ${previousRoute?.settings.name}');
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    
    // Log navigation for debugging
    debugPrint('Pushed to: ${route.settings.name}');
    debugPrint('From: ${previousRoute?.settings.name}');
  }
}
