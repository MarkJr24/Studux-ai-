import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import 'student_home_screen.dart';
import 'student_exams_screen.dart';
import 'student_alerts_screen.dart';
import 'student_profile_screen.dart';

class StudentAcademicsScreen extends StatefulWidget {
  const StudentAcademicsScreen({super.key});

  @override
  State<StudentAcademicsScreen> createState() => _StudentAcademicsScreenState();
}

class _StudentAcademicsScreenState extends State<StudentAcademicsScreen> {
  // Mock data for Academic Snapshot
  final String _semester = 'II (2025)';
  final int _credits = 22;
  final double _attendance = 84.0;
  final String _nextClass = 'DBMS – 10:00 AM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAcademicSnapshot(),
          const SizedBox(height: 20),
          _buildCoreAcademics(),
          const SizedBox(height: 20),
          _buildSmartLearning(),
          const SizedBox(height: 20),
          _buildEventsParticipation(),
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
            'Academics',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Learning tools & academic resources',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF2196F3)), // Brighter blue
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

  Widget _buildAcademicSnapshot() {
    Color attendanceColor = Colors.green;
    IconData attendanceIcon = Icons.check_circle;
    
    if (_attendance < 70) {
      attendanceColor = Colors.red;
      attendanceIcon = Icons.error;
    } else if (_attendance < 75) {
      attendanceColor = Colors.orange;
      attendanceIcon = Icons.warning;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                'ACADEMIC SNAPSHOT',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'View Only',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSnapshotRow('Semester', _semester, Icons.school),
          const SizedBox(height: 12),
          _buildSnapshotRow('Credits', _credits.toString(), Icons.credit_card),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Text(
                'Attendance',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '${_attendance.toStringAsFixed(0)}%',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(attendanceIcon, size: 20, color: attendanceColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSnapshotRow('Next Class', _nextClass, Icons.schedule),
        ],
      ),
    );
  }

  Widget _buildSnapshotRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCoreAcademics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CORE ACADEMICS',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildAcademicCard('Timetable', Icons.calendar_today, const Color(0xFF42A5F5), () { // Brighter blue
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Timetable...')),
          );
        }),
        const SizedBox(height: 12),
        _buildAcademicCard('Academic Calendar', Icons.calendar_month, const Color(0xFFAB47BC), () { // Brighter purple
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Academic Calendar...')),
          );
        }),
        const SizedBox(height: 12),
        _buildAcademicCard('Attendance', Icons.check_circle, const Color(0xFF66BB6A), () { // Brighter green
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Attendance...')),
          );
        }),
        const SizedBox(height: 12),
        _buildAcademicCard('Fees', Icons.account_balance_wallet, const Color(0xFFFFA726), () { // Brighter orange
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Fees...')),
          );
        }),
        const SizedBox(height: 12),
        _buildAcademicCard('Study Materials', Icons.book, const Color(0xFF26A69A), () { // Brighter teal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Study Materials...')),
          );
        }),
      ],
    );
  }

  Widget _buildSmartLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SMART LEARNING',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildAcademicCard('Study Chatbot (AI)', Icons.chat, Colors.indigo, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Study Chatbot...')),
          );
        }),
      ],
    );
  }

  Widget _buildEventsParticipation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EVENTS & PARTICIPATION',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildAcademicCard('View Events', Icons.celebration, Colors.pink, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Events...')),
          );
        }),
        const SizedBox(height: 12),
        _buildAcademicCard('Request Event', Icons.add_circle, Colors.deepPurple, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Request Event...')),
          );
        }),
      ],
    );
  }

  Widget _buildAcademicCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
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
          _buildNavItem(Icons.school, 'Academics', true),
          _buildNavItem(Icons.description, 'Exams', false),
          _buildNavItem(Icons.notifications, 'Alerts', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (isActive) return;
        
        if (label == 'Home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
          );
        } else if (label == 'Exams') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentExamsScreen()),
          );
        } else if (label == 'Alerts') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentAlertsScreen()),
          );
        }
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
