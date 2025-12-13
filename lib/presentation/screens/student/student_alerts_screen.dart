import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import 'student_home_screen.dart';
import 'student_academics_screen.dart';
import 'student_exams_screen.dart';
import 'student_profile_screen.dart';

// Alert Types
enum AlertType {
  exam,
  academic,
  fee,
  event,
  system,
}

// Alert Priority
enum AlertPriority {
  critical, // Red - Exam today, Fee overdue
  important, // Orange - Hall ticket, Seating
  informational, // Blue - General info
}

// Alert Model
class AlertItem {
  final String id;
  final AlertType type;
  final AlertPriority priority;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isUnread;

  AlertItem({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isUnread,
  });

  AlertItem copyWith({bool? isUnread}) {
    return AlertItem(
      id: id,
      type: type,
      priority: priority,
      title: title,
      description: description,
      timestamp: timestamp,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}

class StudentAlertsScreen extends StatefulWidget {
  const StudentAlertsScreen({super.key});

  @override
  State<StudentAlertsScreen> createState() => _StudentAlertsScreenState();
}

class _StudentAlertsScreenState extends State<StudentAlertsScreen> {
  // Mock alerts data - Replace with actual API/state management
  List<AlertItem> _alerts = [
    AlertItem(
      id: '1',
      type: AlertType.exam,
      priority: AlertPriority.critical,
      title: 'Exam Today',
      description: 'Data Structures CIA at 10:00 AM',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isUnread: true,
    ),
    AlertItem(
      id: '2',
      type: AlertType.exam,
      priority: AlertPriority.important,
      title: 'Hall Ticket Released',
      description: 'Download your hall ticket for upcoming exams',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isUnread: true,
    ),
    AlertItem(
      id: '3',
      type: AlertType.academic,
      priority: AlertPriority.critical,
      title: 'Attendance Shortage',
      description: 'Your attendance in Operating Systems is below 75%',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isUnread: false,
    ),
    AlertItem(
      id: '4',
      type: AlertType.academic,
      priority: AlertPriority.informational,
      title: 'New Study Material',
      description: 'DBMS - Unit 3 notes uploaded',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isUnread: false,
    ),
    AlertItem(
      id: '5',
      type: AlertType.fee,
      priority: AlertPriority.critical,
      title: 'Fee Due',
      description: 'Semester fee payment due by Dec 15, 2025',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isUnread: false,
    ),
    AlertItem(
      id: '6',
      type: AlertType.exam,
      priority: AlertPriority.important,
      title: 'Seating Published',
      description: 'Check your seat allocation for upcoming exams',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isUnread: true,
    ),
    AlertItem(
      id: '7',
      type: AlertType.exam,
      priority: AlertPriority.informational,
      title: 'Results Announced',
      description: 'CIA marks for Data Structures are now available',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isUnread: false,
    ),
    AlertItem(
      id: '8',
      type: AlertType.event,
      priority: AlertPriority.informational,
      title: 'Event Approved',
      description: 'Tech Fest 2025 has been approved',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hasAlerts = _alerts.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: hasAlerts ? _buildAlertsList() : _buildEmptyState(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alerts',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Important updates & notifications',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(Icons.person, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentProfileScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsList() {
    final groupedAlerts = _groupAlertsByTime();
    final hasUnread = _alerts.any((alert) => alert.isUnread);

    return Column(
      children: [
        if (hasUnread) _buildActionBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (groupedAlerts['Today']!.isNotEmpty) ...[
                _buildSectionHeader('Today'),
                const SizedBox(height: 12),
                ...groupedAlerts['Today']!.map((alert) => _buildAlertCard(alert)),
              ],
              if (groupedAlerts['Yesterday']!.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionHeader('Yesterday'),
                const SizedBox(height: 12),
                ...groupedAlerts['Yesterday']!.map((alert) => _buildAlertCard(alert)),
              ],
              if (groupedAlerts['Earlier']!.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionHeader('Earlier'),
                const SizedBox(height: 12),
                ...groupedAlerts['Earlier']!.map((alert) => _buildAlertCard(alert)),
              ],
              const SizedBox(height: 80), // Bottom nav spacing
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            'Mark All as Read',
            Icons.done_all,
            _markAllAsRead,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            'Clear Read',
            Icons.delete_outline,
            _clearReadAlerts,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[700],
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAlertCard(AlertItem alert) {
    final priorityColor = _getPriorityColor(alert.priority);
    final timeAgo = _getTimeAgo(alert.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleAlertTap(alert),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: alert.isUnread ? Colors.blue[50] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: alert.isUnread ? Colors.blue[200]! : Colors.grey[200]!,
              ),
              boxShadow: alert.isUnread
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority indicator
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getAlertIcon(alert.type),
                    color: priorityColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (alert.isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeAgo,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'No New Alerts',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.school, 'Academics', false),
          _buildNavItem(Icons.description, 'Exams', false),
          _buildNavItem(Icons.notifications, 'Alerts', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (isActive) return; // Already on this screen
        
        if (label == 'Home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
          );
        } else if (label == 'Academics') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentAcademicsScreen()),
          );
        } else if (label == 'Exams') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentExamsScreen()),
          );
        }
        // Academics will be added later
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods

  Map<String, List<AlertItem>> _groupAlertsByTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<AlertItem>> grouped = {
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };

    // Sort alerts: Critical → Unread → Newest first
    final sortedAlerts = List<AlertItem>.from(_alerts);
    sortedAlerts.sort((a, b) {
      // Critical alerts always first
      if (a.priority == AlertPriority.critical && b.priority != AlertPriority.critical) {
        return -1;
      }
      if (b.priority == AlertPriority.critical && a.priority != AlertPriority.critical) {
        return 1;
      }
      // Then unread
      if (a.isUnread && !b.isUnread) return -1;
      if (!a.isUnread && b.isUnread) return 1;
      // Then newest
      return b.timestamp.compareTo(a.timestamp);
    });

    for (var alert in sortedAlerts) {
      final alertDate = DateTime(
        alert.timestamp.year,
        alert.timestamp.month,
        alert.timestamp.day,
      );

      if (alertDate == today) {
        grouped['Today']!.add(alert);
      } else if (alertDate == yesterday) {
        grouped['Yesterday']!.add(alert);
      } else {
        grouped['Earlier']!.add(alert);
      }
    }

    return grouped;
  }

  Color _getPriorityColor(AlertPriority priority) {
    switch (priority) {
      case AlertPriority.critical:
        return Colors.red;
      case AlertPriority.important:
        return Colors.orange;
      case AlertPriority.informational:
        return Colors.blue;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.exam:
        return Icons.description;
      case AlertType.academic:
        return Icons.school;
      case AlertType.fee:
        return Icons.account_balance_wallet;
      case AlertType.event:
        return Icons.event;
      case AlertType.system:
        return Icons.info;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _handleAlertTap(AlertItem alert) {
    // Mark as read
    setState(() {
      final index = _alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(isUnread: false);
      }
    });

    // Deep-link navigation based on alert type and title
    String destination = '';
    
    if (alert.title.contains('Exam Today') || alert.title.contains('Exam Scheduled')) {
      destination = 'Exams → Exam Schedule';
    } else if (alert.title.contains('Hall Ticket')) {
      destination = 'Exams → Hall Ticket';
    } else if (alert.title.contains('Seating')) {
      destination = 'Exams → Seating Information';
    } else if (alert.title.contains('Results')) {
      destination = 'Exams → Marks/Results';
    } else if (alert.title.contains('Attendance')) {
      destination = 'Academics → Attendance';
    } else if (alert.title.contains('Study Material')) {
      destination = 'Academics → Study Materials';
    } else if (alert.title.contains('Fee')) {
      destination = 'Academics → Fees';
    } else if (alert.title.contains('Event')) {
      destination = 'Academics → Events';
    } else {
      destination = 'Alert marked as read';
    }

    // Show navigation feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to: $destination'),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual navigation
    // Navigator.push(context, MaterialPageRoute(builder: (context) => TargetScreen()));
  }

  void _markAllAsRead() {
    setState(() {
      _alerts = _alerts.map((alert) => alert.copyWith(isUnread: false)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All alerts marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearReadAlerts() {
    setState(() {
      _alerts = _alerts.where((alert) => alert.isUnread).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Read alerts cleared'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
