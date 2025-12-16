import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import 'today_exam_duty_screen.dart';
import 'reporting_details_screen.dart';
import 'upcoming_invigilation_screen.dart';
import 'past_invigilation_screen.dart';

class DutyExamManagementScreen extends StatelessWidget {
  const DutyExamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      'View Today\'s Exam Duty & Halls',
                      Icons.event_note,
                      TeacherColors.invigilationColor,
                      TeacherColors.invigilationBg,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TodayExamDutyScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      context,
                      'Reporting Time & Subject Details',
                      Icons.schedule,
                      TeacherColors.invigilationColor,
                      TeacherColors.invigilationBg,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportingDetailsScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      context,
                      'Upcoming Invigilation Schedule',
                      Icons.calendar_today,
                      TeacherColors.infoDark,
                      TeacherColors.infoBg,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpcomingInvigilationScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      context,
                      'Past Invigilation History',
                      Icons.history,
                      TeacherColors.successDark,
                      TeacherColors.successBg,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PastInvigilationScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TeacherSpacing.headerHorizontal,
        vertical: TeacherSpacing.headerVertical,
      ),
      decoration: const BoxDecoration(
        color: TeacherColors.background,
        border: Border(
          bottom: BorderSide(
            color: TeacherColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: TeacherColors.backButtonBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              color: TeacherColors.iconGray,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 16),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Invigilation Schedule',
                  style: TeacherTextStyles.pageTitleColored(TeacherColors.invigilationColor),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your exam duties',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Color accentColor,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: TeacherDecorations.whiteCard,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: TeacherColors.arrowIcon,
            ),
          ],
        ),
      ),
    );
  }
}
