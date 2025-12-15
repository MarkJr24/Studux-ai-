import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import 'student_home_screen.dart';
import 'student_academics_screen.dart';
import 'student_alerts_screen.dart';
import 'student_profile_screen.dart';
import 'exam_schedule_screen.dart';
import 'hall_ticket_screen.dart';
import 'seating_information_screen.dart';
import 'marks_results_screen.dart';
import 'exam_guidelines_screen.dart';
import 'exam_history_screen.dart';

class StudentExamsScreen extends StatefulWidget {
  const StudentExamsScreen({super.key});

  @override
  State<StudentExamsScreen> createState() => _StudentExamsScreenState();
}

class _StudentExamsScreenState extends State<StudentExamsScreen> {
  // Mock data - Replace with actual API calls
  final bool _hasExamToday = true;
  final String _todayExamSubject = 'Data Structures';
  final String _todayExamType = 'CIA';
  final String _todayExamTime = '10:00 AM – 01:00 PM';
  final DateTime _examStartTime = DateTime.now().add(const Duration(hours: 2, minutes: 15));
  
  final bool _hallTicketReleased = true;
  final bool _seatingPublished = true;
  final bool _resultsAvailable = true;

  Timer? _countdownTimer;
  Duration _timeUntilExam = const Duration();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    setState(() {
      _timeUntilExam = _examStartTime.difference(DateTime.now());
    });
  }

  String _formatCountdown() {
    final hours = _timeUntilExam.inHours;
    final minutes = _timeUntilExam.inMinutes % 60;
    return 'Starts in $hours hours $minutes minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExamOverview(),
          const SizedBox(height: 24),
          _buildExamActions(),
          const SizedBox(height: 24),
          _buildQuickStatus(),
          const SizedBox(height: 80), // Bottom nav spacing
        ],
      ),
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
            'Exams',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Exam schedules, hall tickets & results',
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

  Widget _buildExamOverview() {
    if (_hasExamToday) {
      return _buildTodayExamCard();
    } else {
      return _buildNoExamCard();
    }
  }

  Widget _buildTodayExamCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'EXAM OVERVIEW',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              const Text('🎯', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Today\'s Exam: $_todayExamSubject',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _todayExamType,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Time: $_todayExamTime',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Status: Upcoming',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatCountdown(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoExamCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'EXAM OVERVIEW',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              const Text('✅', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'No exams scheduled for today',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Next Exam: Operating Systems',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Date: Dec 15, 2025 | 10:00 AM',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXAM ACTIONS',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.calendar_today,
          iconColor: Colors.blue,
          title: 'Exam Schedule',
          subtitle: 'View upcoming & past exams',
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExamScheduleScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.confirmation_number,
          iconColor: Colors.purple,
          title: 'Hall Ticket',
          subtitle: _hallTicketReleased
              ? 'Download your hall ticket'
              : 'Not released yet',
          enabled: _hallTicketReleased,
          statusBadge: _hallTicketReleased ? '✅' : '🔒',
          onTap: _hallTicketReleased
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HallTicketScreen()),
                  );
                }
              : null,
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.event_seat,
          iconColor: Colors.orange,
          title: 'Seating Information',
          subtitle: _seatingPublished
              ? 'View your seat allocation'
              : 'Not available yet',
          enabled: _seatingPublished,
          statusBadge: _seatingPublished ? '✅' : '🔒',
          onTap: _seatingPublished
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SeatingInformationScreen()),
                  );
                }
              : null,
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.assessment,
          iconColor: Colors.green,
          title: 'Marks / Results',
          subtitle: 'View your exam results',
          enabled: true,
          badge: _resultsAvailable ? 'New' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarksResultsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.info_outline,
          iconColor: Colors.teal,
          title: 'Exam Guidelines',
          subtitle: 'Important exam instructions',
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExamGuidelinesScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.history,
          iconColor: Colors.indigo,
          title: 'Exam History',
          subtitle: 'View past exam records',
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExamHistoryScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool enabled,
    String? statusBadge,
    String? badge,
    VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (statusBadge != null)
                    Text(statusBadge, style: const TextStyle(fontSize: 20)),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (enabled) const SizedBox(width: 8),
                  if (enabled)
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatus() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[100]!, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'QUICK STATUS',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.touch_app,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            icon: Icons.confirmation_number,
            label: 'Hall Ticket',
            status: _hallTicketReleased ? 'Released' : 'Not Released',
            isAvailable: _hallTicketReleased,
            onTap: () {
              if (_hallTicketReleased) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HallTicketScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Hall ticket will be available soon',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _buildStatusItem(
            icon: Icons.event_seat,
            label: 'Seating',
            status: _seatingPublished ? 'Published' : 'Not Available',
            isAvailable: _seatingPublished,
            onTap: () {
              if (_seatingPublished) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeatingInformationScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Seating information will be available soon',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _buildStatusItem(
            icon: Icons.assessment,
            label: 'Results',
            status: _resultsAvailable ? 'Announced' : 'Not Announced',
            isAvailable: _resultsAvailable,
            onTap: () {
              if (_resultsAvailable) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarksResultsScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Results will be announced soon',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String status,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: isAvailable ? Colors.green : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Icon(
              isAvailable ? Icons.check_circle : Icons.cancel,
              color: isAvailable ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '$label: ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isAvailable ? Colors.grey[700] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (isAvailable)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 20,
              ),
          ],
        ),
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
          _buildNavItem(Icons.description, 'Exams', true),
          _buildNavItem(Icons.notifications, 'Alerts', false),
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
        } else if (label == 'Alerts') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentAlertsScreen()),
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
}
