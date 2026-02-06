import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/auth/role_selection_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'StudX',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            final navigator = navigatorKey.currentState;
            if (navigator != null && navigator.canPop()) {
              // Centralized back navigation logic:
              // Whenever a back action is triggered and there's a route to pop,
              // we instead clear the stack and return to Role Selection.
              // This ensures "no intermediate screens" and avoids broken history.
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => RoleSelectionScreen(
                    onThemeToggle: () {},
                    themeMode: ThemeMode.light,
                  ),
                ),
                (route) => false,
              );
              return false; // Prevent default pop
            }
            return true; // Allow exit if at root
          },
          child: child!,
        );
      },
      home: RoleSelectionScreen(
        onThemeToggle: () {},
        themeMode: ThemeMode.light,
      ),
    );
  }
}
