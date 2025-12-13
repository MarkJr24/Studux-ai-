import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import 'teacher_classes_screen.dart';
import 'teacher_alerts_screen.dart';
import 'teacher_profile_screen.dart';
import 'duty_exam_management_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  // Mock data - Replace with actual data from backend
  final String _teacherName = 'Dr. Rajesh Kumar';
  
  // Today's schedule
  final List<Map<String, String>> _todaysClasses = [
    {'subject': 'Data Structures', 'section': 'CSE-A', 'time': '10:00 AM - 11:00 AM'},
    {'subject': 'DBMS', 'section': 'CSE-B', 'time': '11:00 AM - 12:00 PM'},
    {'subject': 'Operating Systems', 'section': 'CSE-A', 'time': '02:00 PM - 03:00 PM'},
  ];
  
  final bool _hasExamDuty = true;
  final String _examDutySubject = 'Data Structures - CIA 1';
  final String _examDutyTime = '10:00 AM - 12:00 PM';
  final String _examDutyHall = 'Main Hall A';
  
  // Quick stats
  final int _upcomingInvigilation = 2;
  final int _classesToday = 3;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = 'Today: ${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(greeting, dateStr),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
                children: [
                  // Today's Invigilation (if assigned)
                  if (_hasExamDuty) ...[
                    _buildTodaysInvigilation(),
                    const SizedBox(height: 20),
                  ],
                  
                  // Quick Stats
                  _buildQuickStats(),
                  const SizedBox(height: 20),
                  
                  // Quick Actions
                  _buildSectionTitle('QUICK ACTIONS'),
                  const SizedBox(height: 12),
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  
                  // Today's Classes
                  _buildSectionTitle('TODAY\'S CLASSES'),
                  const SizedBox(height: 12),
                  _buildTodaysSchedule(),
                  const SizedBox(height: 20),
                  
                  // Alerts Preview
                  _buildSectionTitle('RECENT ALERTS'),
                  const SizedBox(height: 12),
                  _buildAlertsPreview(),
                  
                  const SizedBox(height: TeacherSpacing.bottomNavClearance),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String greeting, String dateStr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: TeacherColors.background,
        border: Border(
          bottom: BorderSide(color: TeacherColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $_teacherName',
                  style: TeacherTextStyles.greeting,
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: TeacherTextStyles.dateText,
                ),
              ],
            ),
          ),
          
          // Profile Icon
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
                color: TeacherColors.profileBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: TeacherColors.profileIcon,
                size: 24,
              ),
            ),
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

  Widget _buildTodaysInvigilation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.tintedCard(
        backgroundColor: TeacherColors.invigilationBg,
        borderColor: TeacherColors.invigilationBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY\'S INVIGILATION',
            style: TeacherTextStyles.sectionTitleColored(TeacherColors.invigilationColor),
          ),
          const SizedBox(height: 12),
          
          Text(
            _examDutySubject,
            style: TeacherTextStyles.largeCardTitle,
          ),
          const SizedBox(height: 12),
          
          // Time Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: TeacherDecorations.badge(TeacherColors.invigilationBg),
            child: Text(
              _examDutyTime,
              style: TeacherTextStyles.timeBadgeText,
            ),
          ),
          const SizedBox(height: 12),
          
          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: TeacherColors.invigilationColor),
              const SizedBox(width: 8),
              Text(
                _examDutyHall,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TeacherColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Upcoming Invigilation',
            _upcomingInvigilation.toString(),
            Icons.assignment,
            TeacherColors.invigilationBg,
            TeacherColors.invigilationColor,
            TeacherColors.invigilationColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Classes Today',
            _classesToday.toString(),
            Icons.class_,
            TeacherColors.classesBg,
            TeacherColors.classesColor,
            TeacherColors.classesColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color bgColor,
    Color accentColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: TeacherDecorations.cardWithLeftBorder(
        borderColor: borderColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: accentColor),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TeacherTextStyles.cardNumber,
          ),
          const SizedBox(height: 4),
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            'Mark Attendance',
            Icons.qr_code_scanner,
            TeacherColors.infoBg,
            TeacherColors.infoDark,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherClassesScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            'View Schedule',
            Icons.calendar_today,
            TeacherColors.invigilationBg,
            TeacherColors.invigilationColor,
            () {
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

  Widget _buildQuickActionCard(
    String label,
    IconData icon,
    Color bgColor,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: TeacherDecorations.whiteCard,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: accentColor),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysSchedule() {
    return Column(
      children: _todaysClasses.map((classInfo) => _buildClassCard(classInfo)).toList(),
    );
  }

  Widget _buildClassCard(Map<String, String> classInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TeacherClassesScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: TeacherDecorations.whiteCard,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TeacherColors.classesBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.class_,
                color: TeacherColors.classesColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classInfo['subject']!,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${classInfo['section']} • ${classInfo['time']}',
                    style: TeacherTextStyles.bodyText,
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: TeacherColors.arrowIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsPreview() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TeacherAlertsScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: TeacherDecorations.whiteCard,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: TeacherColors.errorBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: TeacherColors.errorColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Text(
                'Notifications',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ),
            
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: TeacherDecorations.circularBadge(TeacherColors.badgeRed),
              child: Text(
                '3',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            Text(
              'View All',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TeacherColors.primaryButton,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: TeacherColors.primaryButton,
            ),
          ],
        ),
      ),
    );
  }
}
