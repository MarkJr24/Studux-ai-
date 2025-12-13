import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_design_system.dart';
import 'seating_management_screen.dart';
import 'attendance_audit_screen.dart';
import 'event_approval_screen.dart';

// Alert data model
class AlertItem {
  final String id;
  final String type; // critical, warning, info, success
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color textColor;
  final Widget? targetScreen;

  AlertItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.textColor,
    this.targetScreen,
  });

  AlertItem copyWith({bool? isRead}) {
    return AlertItem(
      id: id,
      type: type,
      title: title,
      description: description,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      icon: icon,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      iconBackgroundColor: iconBackgroundColor,
      textColor: textColor,
      targetScreen: targetScreen,
    );
  }
}

class NotificationsManagementScreen extends StatefulWidget {
  const NotificationsManagementScreen({super.key});

  @override
  State<NotificationsManagementScreen> createState() => _NotificationsManagementScreenState();
}

class _NotificationsManagementScreenState extends State<NotificationsManagementScreen> {
  late List<AlertItem> alerts;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  void _loadAlerts() {
    alerts = [
      // Critical Alert
      AlertItem(
        id: '1',
        type: 'critical',
        title: 'Seating not published',
        description: 'Exam on 15th March - seating arrangement pending',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        icon: Icons.event_seat,
        backgroundColor: AppColors.errorBg,
        borderColor: AppColors.alertCriticalBorder,
        iconBackgroundColor: AppColors.alertCriticalIconBg,
        textColor: AppColors.errorDark,
        targetScreen: const SeatingManagementScreen(),
      ),
      
      // Warning Alert
      AlertItem(
        id: '2',
        type: 'warning',
        title: 'Audit pending',
        description: 'Review attendance audit for Data Structures - CIA 1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: Icons.fact_check,
        backgroundColor: AppColors.pendingBg,
        borderColor: AppColors.alertWarningBorder,
        iconBackgroundColor: AppColors.alertWarningIconBg,
        textColor: AppColors.warningDark,
        targetScreen: const AttendanceAuditScreen(),
      ),
      
      // Warning Alert 2
      AlertItem(
        id: '3',
        type: 'warning',
        title: 'Event approval pending',
        description: '3 events waiting for your approval',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        icon: Icons.approval,
        backgroundColor: AppColors.warningBg,
        borderColor: AppColors.alertWarningBorder,
        iconBackgroundColor: Color(0xFFFFCC80),
        textColor: AppColors.warningDark,
        targetScreen: const EventApprovalScreen(),
      ),
      
      // Success Alert
      AlertItem(
        id: '4',
        type: 'success',
        title: 'Seating published',
        description: 'Seating arrangement for DBMS exam has been published',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        icon: Icons.check_circle,
        backgroundColor: AppColors.successBg,
        borderColor: AppColors.alertSuccessBorder,
        iconBackgroundColor: AppColors.alertSuccessIconBg,
        textColor: AppColors.successDark,
        isRead: true,
      ),
      
      // Info Alert
      AlertItem(
        id: '5',
        type: 'info',
        title: 'Exam created',
        description: 'New exam scheduled: Operating Systems - CIA 2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.assignment,
        backgroundColor: AppColors.infoBg,
        borderColor: AppColors.alertInfoBorder,
        iconBackgroundColor: AppColors.alertInfoIconBg,
        textColor: AppColors.infoDark,
        isRead: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = alerts.where((a) => !a.isRead).length;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(unreadCount),
            
            Expanded(
              child: alerts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        return _buildAlertItem(alerts[index]);
                      },
                    ),
            ),
            
            if (alerts.isNotEmpty) _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int unreadCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
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
              color: AppColors.iconGray,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Alerts',
                      style: AppTextStyles.pageTitleColored(AppColors.alertsAccent),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: AppDecorations.circularBadge(AppColors.badgeRed),
                        child: Text(
                          '$unreadCount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'System notifications and alerts',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(AlertItem alert) {
    return GestureDetector(
      onTap: () => _handleAlertTap(alert),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.alertCard(
          backgroundColor: alert.backgroundColor,
          borderColor: alert.borderColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: alert.iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                alert.icon,
                color: alert.textColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unread indicator + Title
                  Row(
                    children: [
                      if (!alert.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: alert.borderColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          alert.title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: alert.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    alert.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Timestamp
                  Text(
                    _formatTimestamp(alert.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.labelText,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColors.arrowIcon,
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
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColors.labelText,
          ),
          const SizedBox(height: 16),
          Text(
            'No Alerts',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: AppTextStyles.bodyText,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _markAllAsRead,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.infoBg,
                foregroundColor: AppColors.infoDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Mark All as Read',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.infoDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _clearAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorBg,
                foregroundColor: AppColors.errorDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Clear All',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.errorDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAlertTap(AlertItem alert) {
    setState(() {
      final index = alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        alerts[index] = alerts[index].copyWith(isRead: true);
      }
    });
    
    if (alert.targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => alert.targetScreen!),
      );
    }
  }

  void _markAllAsRead() {
    setState(() {
      alerts = alerts.map((alert) => alert.copyWith(isRead: true)).toList();
    });
  }

  void _clearAll() {
    setState(() {
      alerts.clear();
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
