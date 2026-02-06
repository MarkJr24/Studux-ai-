import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/teacher/teacher_dashboard.dart';
import '../screens/teacher/teacher_classes_screen.dart';
import '../screens/teacher/teacher_evaluation_screen.dart';
import '../screens/teacher/teacher_insights_screen.dart';
import '../screens/teacher/teacher_alerts_screen.dart';
import '../screens/teacher/teacher_design_system.dart';

/// Teacher Bottom Navigation Bar
/// 5 tabs: Home, Classes, Evaluation, Insights, Alerts
/// Used across all main teacher screens except Profile and Settings (modal screens)
class TeacherBottomNav extends StatelessWidget {
  final String currentRoute;

  const TeacherBottomNav({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: TeacherColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: TeacherColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            Icons.home,
            'Home',
            'home',
          ),
          _buildNavItem(
            context,
            Icons.class_,
            'Classes',
            'classes',
          ),
          _buildNavItem(
            context,
            Icons.edit_note,
            'Evaluation',
            'evaluation',
          ),
          _buildNavItem(
            context,
            Icons.insights,
            'Insights',
            'insights',
          ),
          _buildNavItem(
            context,
            Icons.notifications,
            'Alerts',
            'alerts',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    final isActive = currentRoute == route;

    return GestureDetector(
      onTap: () {
        if (isActive) return; // Already on this screen

        // Navigate to correct screen based on route
        Widget targetScreen;
        switch (route) {
          case 'home':
            targetScreen = const TeacherDashboard();
            break;
          case 'classes':
            targetScreen = const TeacherClassesScreen();
            break;
          case 'evaluation':
            targetScreen = const TeacherEvaluationScreen();
            break;
          case 'insights':
            targetScreen = const TeacherInsightsScreen();
            break;
          case 'alerts':
            targetScreen = const TeacherAlertsScreen();
            break;
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top indicator for active tab
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? TeacherColors.bottomNavActive
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 6),

            Icon(
              icon,
              color: isActive
                  ? TeacherColors.bottomNavActive
                  : TeacherColors.bottomNavInactive,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                color: isActive
                    ? TeacherColors.bottomNavActive
                    : TeacherColors.bottomNavInactiveLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
