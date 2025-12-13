import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/exam_invigilator_screen.dart';
import '../screens/admin/seating_management_screen.dart';
import '../screens/admin/attendance_audit_screen.dart';
import '../screens/admin/notifications_management_screen.dart';
import '../screens/admin/admin_design_system.dart';

/// Admin Bottom Navigation Bar
/// 5 tabs: Home, Exams & Invigilation, Seating & Allocation, Attendance & Audit, Notifications
/// Used across all main admin screens except Profile and Settings (modal screens)
class AdminBottomNav extends StatelessWidget {
  final String currentRoute;

  const AdminBottomNav({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000), // 8% opacity for elevation 8
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
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
            Icons.assignment,
            'Exams',
            'exams',
          ),
          _buildNavItem(
            context,
            Icons.event_seat,
            'Seating',
            'seating',
          ),
          _buildNavItem(
            context,
            Icons.fact_check,
            'Audit',
            'audit',
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
            targetScreen = const AdminDashboard();
            break;
          case 'exams':
            targetScreen = const ExamInvigilatorScreen();
            break;
          case 'seating':
            targetScreen = const SeatingManagementScreen();
            break;
          case 'audit':
            targetScreen = const AttendanceAuditScreen();
            break;
          case 'alerts':
            targetScreen = const NotificationsManagementScreen();
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
        decoration: isActive
            ? const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.bottomNavActive,
                    width: 3,
                  ),
                ),
              )
            : null,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.bottomNavActive : AppColors.bottomNavInactive,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.bottomNavActive : AppColors.bottomNavInactiveLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
