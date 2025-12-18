import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seating_management_screen.dart';
import 'exam_invigilator_screen.dart';
import 'attendance_audit_screen.dart';
import 'event_approval_screen.dart';
import 'notifications_management_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_design_system.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Mock data - Replace with actual data from backend
  final int _upcomingExams = 5;
  final int _pendingSeating = 2;
  final int _pendingAudits = 1;
  final int _pendingEvents = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            // Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.pageHorizontal,
                  right: AppSpacing.pageHorizontal,
                  top: 16,
                  bottom: AppSpacing.bottomNavClearance,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // System Status Overview
                    _buildSectionTitle('SYSTEM STATUS OVERVIEW'),
                    const SizedBox(height: 12),
                    _buildSystemStatusOverview(context),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Action Required
                    _buildSectionTitle('ACTION REQUIRED'),
                    const SizedBox(height: 12),
                    _buildActionRequiredSection(context),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Quick Actions
                    _buildSectionTitle('QUICK ACTIONS'),
                    const SizedBox(height: 12),
                    _buildQuickActionsSection(context),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Manage Modules
                    _buildSectionTitle('MANAGE MODULES'),
                    const SizedBox(height: 12),
                    _buildDashboardGrid(context),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Recent Activity
                    _buildSectionTitle('RECENT ACTIVITY'),
                    const SizedBox(height: 12),
                    _buildRecentActivitySection(context),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Notifications
                    _buildSectionTitle('NOTIFICATIONS'),
                    const SizedBox(height: 12),
                    _buildNotificationPreviewSection(context),
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
        horizontal: AppSpacing.headerHorizontal,
        vertical: AppSpacing.headerVertical,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
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
              color: AppColors.backButtonBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              color: AppColors.primaryText,
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
                  'Admin Dashboard',
                  style: AppTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Welcome, Admin',
                  style: AppTextStyles.subtitle,
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
                  builder: (context) => const AdminProfileScreen(),
                ),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.profileBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.profileIcon,
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
      style: AppTextStyles.sectionTitle,
    );
  }

  Widget _buildSystemStatusOverview(BuildContext context) {
    return Column(
      children: [
        // First row: 2 cards
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: 'Upcoming Exams',
                count: _upcomingExams.toString(),
                icon: Icons.event,
                backgroundColor: AppColors.upcomingExamsBg,
                accentColor: AppColors.upcomingExamsAccent,
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _StatusCard(
                title: 'Pending Seating',
                count: _pendingSeating.toString(),
                icon: Icons.event_seat,
                backgroundColor: AppColors.pendingSeatingBg,
                accentColor: AppColors.pendingSeatingAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardSpacing),

        // Second row: 2 cards
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: 'Pending Audits',
                count: _pendingAudits.toString(),
                icon: Icons.fact_check,
                backgroundColor: AppColors.pendingAuditsBg,
                accentColor: AppColors.pendingAuditsAccent,
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _StatusCard(
                title: 'Pending Events',
                count: _pendingEvents.toString(),
                icon: Icons.approval,
                backgroundColor: AppColors.pendingEventsBg,
                accentColor: AppColors.pendingEventsAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRequiredSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActionRequiredTile(
          title: 'Seating not published',
          subtitle: 'Publish seating arrangements for upcoming exams',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SeatingManagementScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _ActionRequiredTile(
          title: 'Audit pending',
          subtitle: 'Review and complete attendance audit',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttendanceAuditScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _ActionRequiredTile(
          title: 'Event approval pending',
          subtitle: '$_pendingEvents events waiting for approval',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventApprovalScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Create Exam',
                icon: Icons.add_circle_outline,
                backgroundColor: AppColors.createExamBg,
                accentColor: AppColors.createExamAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamInvigilatorScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _QuickActionButton(
                label: 'Generate Seating',
                icon: Icons.event_seat,
                backgroundColor: AppColors.generateSeatingBg,
                accentColor: AppColors.generateSeatingAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SeatingManagementScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardSpacing),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Generate Audit',
                icon: Icons.fact_check,
                backgroundColor: AppColors.generateAuditBg,
                accentColor: AppColors.generateAuditAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceAuditScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _QuickActionButton(
                label: 'Review Events',
                icon: Icons.approval,
                backgroundColor: AppColors.reviewEventsBg,
                accentColor: AppColors.reviewEventsAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventApprovalScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final tiles = [
      _DashboardTile(
        title: 'Seating Management',
        icon: Icons.event_seat,
        backgroundColor: AppColors.pendingSeatingBg,
        accentColor: AppColors.pendingSeatingAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SeatingManagementScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Exam & Invigilator',
        icon: Icons.assignment,
        backgroundColor: AppColors.upcomingExamsBg,
        accentColor: AppColors.upcomingExamsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExamInvigilatorScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Attendance & Audit',
        icon: Icons.fact_check,
        backgroundColor: AppColors.pendingAuditsBg,
        accentColor: AppColors.pendingAuditsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceAuditScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Event Approval',
        icon: Icons.approval,
        backgroundColor: AppColors.pendingEventsBg,
        accentColor: AppColors.pendingEventsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventApprovalScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Notifications',
        icon: Icons.notifications_active,
        backgroundColor: AppColors.createExamBg,
        accentColor: AppColors.createExamAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsManagementScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Admin Profile',
        icon: Icons.person,
        backgroundColor: Color(0xFFE3F2FD),
        accentColor: Color(0xFF1976D2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminProfileScreen(),
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

  Widget _buildRecentActivitySection(BuildContext context) {
    final activities = [
      _ActivityItem(
        title: 'Seating published',
        timestamp: '2 hours ago',
        icon: Icons.event_seat,
        accentColor: AppColors.pendingSeatingAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SeatingManagementScreen(),
            ),
          );
        },
      ),
      _ActivityItem(
        title: 'Audit generated',
        timestamp: '5 hours ago',
        icon: Icons.fact_check,
        accentColor: AppColors.pendingAuditsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceAuditScreen(),
            ),
          );
        },
      ),
      _ActivityItem(
        title: 'Event approved',
        timestamp: '1 day ago',
        icon: Icons.approval,
        accentColor: AppColors.pendingEventsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventApprovalScreen(),
            ),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          activities.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index < activities.length - 1 ? 8 : 0),
            child: _RecentActivityTile(
              activity: activities[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationPreviewSection(BuildContext context) {
    const unreadCount = 3;

    return _NotificationPreview(
      unreadCount: unreadCount,
      onViewAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationsManagementScreen(),
          ),
        );
      },
    );
  }

}

// Status Card Widget
class _StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.statusCard(
        backgroundColor: backgroundColor,
      ),
      child: Column(
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
            style: AppTextStyles.cardNumber,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Label
          Text(
            title,
            style: AppTextStyles.cardLabel,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Action Required Tile Widget
class _ActionRequiredTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionRequiredTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.actionCard(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Red dot indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.actionRequiredDot,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.actionRequiredTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyText,
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.arrowIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Quick Action Button Widget
class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: AppDecorations.quickActionCard(
        backgroundColor: backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
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
                  style: AppTextStyles.quickActionLabel,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
    return Container(
      decoration: AppDecorations.statusCard(
        backgroundColor: backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
                    color: AppColors.primaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Activity Item Data Class
class _ActivityItem {
  final String title;
  final String timestamp;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActivityItem({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });
}

// Recent Activity Tile Widget
class _RecentActivityTile extends StatelessWidget {
  final _ActivityItem activity;

  const _RecentActivityTile({
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.whiteCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: activity.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: activity.accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activity.icon,
                    size: 20,
                    color: activity.accentColor,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    activity.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),

                Text(
                  activity.timestamp,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.arrowIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Notification Preview Widget
class _NotificationPreview extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onViewAll;

  const _NotificationPreview({
    required this.unreadCount,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.whiteCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewAll,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.createExamBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    size: 24,
                    color: AppColors.createExamAccent,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Notifications',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),

                // Unread count badge
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.actionRequiredDot,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                const SizedBox(width: 12),

                // View All arrow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.createExamAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.createExamAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
