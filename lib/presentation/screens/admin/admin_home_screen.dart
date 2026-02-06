import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import '../../widgets/admin_bottom_nav.dart';
import 'exam_invigilator_screen.dart';
import 'seating_management_screen.dart';
import 'attendance_audit_screen.dart';
import 'event_approval_screen.dart';
import 'notifications_management_screen.dart';
import 'admin_profile_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // Mock data - Replace with actual data from backend
  final String _adminName = 'Admin';

  // Today's exam status
  final int _examsToday = 2;
  final bool _seatingPublished = false;
  final bool _hallTicketReleased = false;
  final bool _resultsReady = true;

  // Admin tasks
  final int _marksToApprove = 5;
  final int _seatingPending = 1;
  final int _hallTicketPending = 1;
  final int _eventRequests = 3;

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
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final dateStr =
        'Today: ${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(greeting, dateStr),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTodaysExamStatus(),
          const SizedBox(height: 20),
          _buildAdminTaskCenter(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildSystemActivity(),
          const SizedBox(height: 20),
          _buildAlertsPreview(),
          const SizedBox(height: 100), // Bottom nav spacing
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentRoute: 'home'),
    );
  }

  PreferredSizeWidget _buildAppBar(String greeting, String dateStr) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $_adminName',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            dateStr,
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
                MaterialPageRoute(
                    builder: (context) => const AdminProfileScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysExamStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TODAY\'S EXAM & SYSTEM STATUS',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildStatusRow(
                'Exams Scheduled Today',
                '$_examsToday exams',
                _examsToday > 0 ? Colors.blue : Colors.grey,
                Icons.assignment,
              ),
              const Divider(height: 24),
              _buildStatusRow(
                'Seating Publication',
                _seatingPublished ? 'Published' : 'Not Published',
                _seatingPublished ? Colors.green : Colors.orange,
                Icons.event_seat,
              ),
              const Divider(height: 24),
              _buildStatusRow(
                'Hall Ticket Release',
                _hallTicketReleased ? 'Released' : 'Not Released',
                _hallTicketReleased ? Colors.green : Colors.orange,
                Icons.badge,
              ),
              const Divider(height: 24),
              _buildStatusRow(
                'Result Publication',
                _resultsReady ? 'Ready' : 'Pending',
                _resultsReady ? Colors.green : Colors.grey,
                Icons.assessment,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(
      String label, String status, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminTaskCenter() {
    final hasTasks = _marksToApprove > 0 ||
        _seatingPending > 0 ||
        _hallTicketPending > 0 ||
        _eventRequests > 0;

    if (!hasTasks) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADMIN TASK CENTER',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (_marksToApprove > 0)
          _buildTaskCard(
            'Approve Marks',
            '$_marksToApprove submissions pending approval',
            Icons.check_circle_outline,
            const Color(0xFF10B981),
            'PENDING',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExamInvigilatorScreen(),
                ),
              );
            },
          ),
        if (_seatingPending > 0)
          _buildTaskCard(
            'Publish Seating',
            'Seating arrangement ready to publish',
            Icons.event_seat,
            const Color(0xFF3B82F6),
            'ACTION REQUIRED',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SeatingManagementScreen(),
                ),
              );
            },
          ),
        if (_hallTicketPending > 0)
          _buildTaskCard(
            'Release Hall Ticket',
            'Hall tickets ready for release',
            Icons.badge,
            const Color(0xFF8B5CF6),
            'ACTION REQUIRED',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExamInvigilatorScreen(),
                ),
              );
            },
          ),
        if (_eventRequests > 0)
          _buildTaskCard(
            'Pending Event Requests',
            '$_eventRequests events awaiting approval',
            Icons.event,
            const Color(0xFFF97316),
            'REVIEW',
            () {
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

  Widget _buildTaskCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String badge,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ADMIN ACTIONS',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'Create Exam',
                Icons.add_circle_outline,
                const Color(0xFF3B82F6),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamInvigilatorScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                'Generate Seating',
                Icons.event_seat,
                const Color(0xFF10B981),
                () {
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'Release Hall Ticket',
                Icons.badge,
                const Color(0xFF8B5CF6),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamInvigilatorScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                'Review Submissions',
                Icons.fact_check,
                const Color(0xFFF97316),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceAuditScreen(),
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

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemActivity() {
    final activities = [
      {'text': 'Marks submitted by Dr. Rajesh – DBMS', 'time': '1 hour ago'},
      {'text': 'Attendance audit generated – CSE-A', 'time': '3 hours ago'},
      {'text': 'Seating published – Semester Exams', 'time': '5 hours ago'},
      {'text': 'Event approved – Tech Fest 2025', 'time': '1 day ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SYSTEM ACTIVITY',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['text']!,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['time']!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsPreview() {
    final alerts = [
      {
        'title': 'Marks Submission Pending',
        'desc': '5 faculty submissions awaiting approval',
        'time': '30 min ago'
      },
      {
        'title': 'Seating Not Published',
        'desc': 'Semester exam seating pending publication',
        'time': '2 hours ago'
      },
      {
        'title': 'Event Request Pending',
        'desc': '3 event requests need review',
        'time': '4 hours ago'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ALERTS',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsManagementScreen(),
                  ),
                );
              },
              child: Text(
                'View All →',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...alerts.take(2).map((alert) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NotificationsManagementScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert['title']!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alert['desc']!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alert['time']!,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
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
            )),
      ],
    );
  }
}
