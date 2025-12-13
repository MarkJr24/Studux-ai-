import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';

class TeacherAlertsScreen extends StatefulWidget {
  const TeacherAlertsScreen({super.key});

  @override
  State<TeacherAlertsScreen> createState() => _TeacherAlertsScreenState();
}

class _TeacherAlertsScreenState extends State<TeacherAlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'title': 'Attendance Pending',
      'description': 'Mark attendance for Data Structures - CSE 3A',
      'timestamp': '10 minutes ago',
      'type': 'attendance',
      'isRead': false,
    },
    {
      'title': 'Exam Duty Assigned',
      'description': 'You have been assigned to Hall 301 for tomorrow\'s exam',
      'timestamp': '1 hour ago',
      'type': 'invigilation',
      'isRead': false,
    },
    {
      'title': 'Class Schedule Update',
      'description': 'Operating Systems class has been rescheduled to 3:00 PM',
      'timestamp': '2 hours ago',
      'type': 'class',
      'isRead': false,
    },
    {
      'title': 'System Update',
      'description': 'New features added to the evaluation module',
      'timestamp': '1 day ago',
      'type': 'info',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _alerts.where((a) => !a['isRead']).length;
    final hasUnread = unreadCount > 0;

    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, unreadCount),
            if (hasUnread) _buildActionButtons(),
            Expanded(
              child: hasUnread
                  ? _buildAlertsList()
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unreadCount) {
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
                  'Notifications',
                  style: TeacherTextStyles.pageTitleColored(TeacherColors.primaryButton),
                ),
                const SizedBox(height: 2),
                Text(
                  'Stay updated with alerts',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),

          // Notification Badge
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: TeacherColors.badgeRed,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (var alert in _alerts) {
                    alert['isRead'] = true;
                  }
                });
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: TeacherColors.infoBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TeacherColors.infoDark.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    'Mark All as Read',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.infoDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _alerts.removeWhere((alert) => alert['isRead']);
                });
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: TeacherColors.errorBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TeacherColors.errorDark.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.errorDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    final actionRequired = _alerts.where((a) => !a['isRead'] && a['type'] == 'attendance').toList();
    final today = _alerts.where((a) => !a['isRead'] && a['type'] != 'attendance').toList();
    final earlier = _alerts.where((a) => a['isRead']).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (actionRequired.isNotEmpty) ...[
            _buildSectionHeader('ACTION REQUIRED'),
            const SizedBox(height: 12),
            ...actionRequired.map((alert) => _buildAlertCard(alert)),
            const SizedBox(height: 20),
          ],
          if (today.isNotEmpty) ...[
            _buildSectionHeader('TODAY'),
            const SizedBox(height: 12),
            ...today.map((alert) => _buildAlertCard(alert)),
            const SizedBox(height: 20),
          ],
          if (earlier.isNotEmpty) ...[
            _buildSectionHeader('EARLIER'),
            const SizedBox(height: 12),
            ...earlier.map((alert) => _buildAlertCard(alert)),
          ],
          const SizedBox(height: TeacherSpacing.bottomNavClearance),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TeacherTextStyles.sectionTitle,
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color backgroundColor;
    Color borderColor;
    Color iconBgColor;
    Color accentColor;

    switch (alert['type']) {
      case 'attendance':
        backgroundColor = TeacherColors.notifAttendanceBg;
        borderColor = TeacherColors.notifAttendanceBorder;
        iconBgColor = TeacherColors.notifAttendanceIconBg;
        accentColor = TeacherColors.attendanceDark;
        break;
      case 'invigilation':
        backgroundColor = TeacherColors.notifInvigilationBg;
        borderColor = TeacherColors.notifInvigilationBorder;
        iconBgColor = TeacherColors.notifInvigilationIconBg;
        accentColor = TeacherColors.invigilationColor;
        break;
      case 'class':
        backgroundColor = TeacherColors.notifClassBg;
        borderColor = TeacherColors.notifClassBorder;
        iconBgColor = TeacherColors.notifClassIconBg;
        accentColor = TeacherColors.classesDark;
        break;
      default:
        backgroundColor = TeacherColors.notifGeneralBg;
        borderColor = TeacherColors.notifGeneralBorder;
        iconBgColor = TeacherColors.notifGeneralIconBg;
        accentColor = TeacherColors.infoDark;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          alert['isRead'] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to ${alert['type']} module'),
            duration: const Duration(seconds: 1),
            backgroundColor: TeacherColors.successColor,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: TeacherDecorations.notificationCard(
          backgroundColor: backgroundColor,
          borderColor: borderColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForType(alert['type']),
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!alert['isRead'])
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          alert['title'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert['description'],
                    style: TeacherTextStyles.bodyText,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert['timestamp'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: TeacherColors.labelText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: TeacherDecorations.whiteCard,
            child: Column(
              children: [
                Icon(
                  Icons.celebration,
                  size: 64,
                  color: TeacherColors.successColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No new alerts',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: TeacherColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re all caught up.',
                  style: TeacherTextStyles.bodyText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'attendance':
        return Icons.qr_code_scanner;
      case 'invigilation':
        return Icons.assignment;
      case 'class':
        return Icons.class_;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
