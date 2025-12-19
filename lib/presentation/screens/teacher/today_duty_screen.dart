import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'teacher_design_system.dart';
import '../../widgets/invigilation_widgets.dart';

class TodayDutyScreen extends StatefulWidget {
  const TodayDutyScreen({super.key});

  @override
  State<TodayDutyScreen> createState() => _TodayDutyScreenState();
}

class _TodayDutyScreenState extends State<TodayDutyScreen> {
  bool _isLoading = false;

  // Mock data - Replace with actual API data
  final Map<String, dynamic> _todayDuty = {
    'id': '1',
    'date': DateTime.now(),
    'time': '2:00 PM - 5:00 PM',
    'subject': 'Database Management Systems',
    'subjectCode': 'DBMS',
    'examType': 'Semester End Exam',
    'hall': 'Examination Hall B',
    'building': 'Main Block',
    'floor': '2nd Floor',
    'capacity': 150,
    'students': 120,
    'status': 'Confirmed',
    'coInvigilators': [
      {'name': 'Dr. Priya Kumar', 'dept': 'CSE', 'phone': '+91 98765 43210'},
      {'name': 'Prof. Anil Sharma', 'dept': 'IT', 'phone': '+91 98765 43211'},
    ],
  };

  // Set to null to test empty state
  // final Map<String, dynamic>? _todayDuty = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final today = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Today\'s Exam Duty',
                  style: TeacherTextStyles.pageTitleColored(
                    TeacherColors.invigilationColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  today,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: TeacherColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingStateWidget(
        message: 'Loading today\'s duty...',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      color: TeacherColors.invigilationColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDutyCard(),
            const SizedBox(height: 16),
            _buildInstructionsCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDutyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(32),
        decoration: TeacherDecorations.whiteCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'No Exam Duty Today',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: TeacherColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your free time!',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TeacherColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to upcoming duties
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TeacherColors.invigilationColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Upcoming Duties',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyCard() {
    final duty = _todayDuty;
    final statusType = duty['status'] == 'Confirmed'
        ? StatusType.confirmed
        : StatusType.tentative;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: TeacherDecorations.tintedCard(
        backgroundColor: TeacherColors.invigilationBg,
        borderColor: TeacherColors.invigilationBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  size: 24,
                  color: TeacherColors.invigilationColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      duty['subjectCode'],
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: TeacherColors.invigilationDark,
                      ),
                    ),
                    Text(
                      duty['examType'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: TeacherColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Exam Details
          _buildDetailRow(
            Icons.calendar_today,
            'Date',
            DateFormat('d MMM yyyy').format(duty['date']),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.access_time,
            'Time',
            duty['time'],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.location_on,
            'Hall',
            duty['hall'],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.people,
            'Students',
            '${duty['students']} students',
          ),
          const SizedBox(height: 16),

          // Status Badge
          Row(
            children: [
              Text(
                'Status:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TeacherColors.secondaryText,
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                text: duty['status'],
                type: statusType,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Co-Invigilators Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TeacherColors.invigilationBorder,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Co-Invigilators',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TeacherColors.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  duty['coInvigilators'].length,
                  (index) {
                    final coInvig = duty['coInvigilators'][index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < duty['coInvigilators'].length - 1
                            ? 8
                            : 0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: TeacherColors.invigilationColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              coInvig['name'],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: TeacherColors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Opening hall layout...',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: TeacherColors.invigilationColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.map, size: 16),
                  label: Text(
                    'Hall Layout',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TeacherColors.invigilationDark,
                    side: BorderSide(
                      color: TeacherColors.invigilationDark,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Opening directions...',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: TeacherColors.invigilationColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions, size: 16),
                  label: Text(
                    'Directions',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TeacherColors.invigilationDark,
                    side: BorderSide(
                      color: TeacherColors.invigilationDark,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: TeacherColors.invigilationColor,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: TeacherColors.secondaryText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: TeacherColors.primaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.tintedCard(
        backgroundColor: TeacherColors.infoBg,
        borderColor: TeacherColors.infoDark.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: TeacherColors.infoDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Important Instructions',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionItem('Report 30 minutes before exam'),
          _buildInstructionItem(
            'Collect question papers from Exam Cell by 1:30 PM',
          ),
          _buildInstructionItem('Verify student ID cards'),
          _buildInstructionItem('Ensure mobile phones collected'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: TeacherColors.successDark,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TeacherColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening attendance marking...',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: TeacherColors.successDark,
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: Text(
              'Mark Attendance',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherColors.invigilationColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening issue report form...',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: TeacherColors.errorDark,
                ),
              );
            },
            icon: const Icon(Icons.report_problem_outlined, size: 20),
            label: Text(
              'Report Issue',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: TeacherColors.errorDark,
              side: BorderSide(
                color: TeacherColors.errorDark,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
