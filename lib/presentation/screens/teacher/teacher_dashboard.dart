import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation_service.dart';
import 'teacher_design_system.dart';
import 'duty_exam_management_screen.dart';
import 'attendance_system_screen.dart';
import 'teacher_classes_screen.dart';
import 'teacher_evaluation_screen.dart';
import 'teacher_insights_screen.dart';
import 'teacher_alerts_screen.dart';
import 'teacher_profile_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  // Mock data
  final int _upcomingInvigilation = 2;
  final int _classesToday = 3;

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
                padding: EdgeInsets.only(
                  left: TeacherSpacing.pageHorizontal,
                  right: TeacherSpacing.pageHorizontal,
                  top: 16,
                  bottom: TeacherSpacing.bottomNavClearance,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Block
                    _buildWelcomeBlock(),
                    const SizedBox(height: TeacherSpacing.sectionVertical),

                    // Quick Stats
                    _buildSectionTitle('QUICK STATS'),
                    const SizedBox(height: 12),
                    _buildQuickStats(),
                    const SizedBox(height: TeacherSpacing.sectionVertical),

                    // Quick Access
                    _buildSectionTitle('QUICK ACCESS'),
                    const SizedBox(height: 12),
                    _buildQuickAccessSection(context),
                    const SizedBox(height: TeacherSpacing.sectionVertical),

                    // Manage Modules
                    _buildSectionTitle('MANAGE MODULES'),
                    const SizedBox(height: 12),
                    _buildDashboardGrid(context),
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
      padding: EdgeInsets.symmetric(
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
              onPressed: () => LogoutHandler.handleBackToLogin(context),
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
                  'Teacher Dashboard',
                  style: TeacherTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Welcome, Faculty',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),

          // Profile Icon with Pink-to-Orange Gradient
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherProfileScreen(),
                ),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF02262), // Top: Pink/Red
                    Color(0xFFFFEB70), // Bottom: Orange/Yellow
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: TeacherColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your classes, duties, and evaluations',
            style: TeacherTextStyles.bodyText,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TeacherTextStyles.sectionTitle,
    );
  }

  Widget _buildQuickStats() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatCard(
              title: 'Upcoming Invigilation',
              count: _upcomingInvigilation.toString(),
              icon: Icons.assignment,
              backgroundColor: TeacherColors.invigilationBg,
              accentColor: TeacherColors.invigilationColor,
              borderColor: TeacherColors.invigilationColor,
            ),
          ),
          const SizedBox(width: TeacherSpacing.cardSpacing),
          Expanded(
            child: _StatCard(
              title: 'Classes Today',
              count: _classesToday.toString(),
              icon: Icons.class_,
              backgroundColor: TeacherColors.classesBg,
              accentColor: TeacherColors.classesColor,
              borderColor: TeacherColors.classesColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            label: 'Mark Attendance',
            icon: Icons.qr_code_scanner,
            backgroundColor: TeacherColors.infoBg,
            accentColor: TeacherColors.infoDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceSystemScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: TeacherSpacing.cardSpacing),
        Expanded(
          child: _QuickActionCard(
            label: 'View Schedule',
            icon: Icons.calendar_today,
            backgroundColor: TeacherColors.invigilationBg,
            accentColor: TeacherColors.invigilationColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DutyExamManagementScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final tiles = [
      _DashboardTile(
        title: 'My Classes',
        icon: Icons.class_,
        backgroundColor: TeacherColors.classesBg,
        accentColor: TeacherColors.classesColor,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherClassesScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Exam Duties',
        icon: Icons.assignment,
        backgroundColor: TeacherColors.invigilationBg,
        accentColor: TeacherColors.invigilationColor,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DutyExamManagementScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Attendance',
        icon: Icons.qr_code_scanner,
        backgroundColor: TeacherColors.infoBg,
        accentColor: TeacherColors.infoDark,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceSystemScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Evaluation',
        icon: Icons.edit_note,
        backgroundColor: TeacherColors.attendanceBg,
        accentColor: TeacherColors.attendanceDark,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherEvaluationScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Insights',
        icon: Icons.insights,
        backgroundColor: TeacherColors.successBg,
        accentColor: TeacherColors.successDark,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherInsightsScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Alerts',
        icon: Icons.notifications,
        backgroundColor: TeacherColors.errorBg,
        accentColor: TeacherColors.errorDark,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherAlertsScreen(),
            ),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) => tiles[index],
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final Color borderColor;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TeacherSpacing.cardPadding),
      decoration: TeacherDecorations.cardWithLeftBorder(
        borderColor: borderColor,
        backgroundColor: TeacherColors.cardBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 12),

          // Count
          Text(
            count,
            style: TeacherTextStyles.cardNumber,
          ),
          const SizedBox(height: 4),

          // Label
          Text(
            title,
            style: TeacherTextStyles.cardLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: TeacherDecorations.whiteCard,
        child: Padding(
          padding: const EdgeInsets.all(TeacherSpacing.cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),

              // Label
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard Tile Widget
class _DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: TeacherDecorations.tintedCard(
          backgroundColor: backgroundColor,
          borderColor: accentColor.withOpacity(0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
