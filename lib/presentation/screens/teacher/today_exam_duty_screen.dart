import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'teacher_design_system.dart';
import '../../widgets/invigilation_widgets.dart';

class TodayExamDutyScreen extends StatefulWidget {
  const TodayExamDutyScreen({super.key});

  @override
  State<TodayExamDutyScreen> createState() => _TodayExamDutyScreenState();
}

class _TodayExamDutyScreenState extends State<TodayExamDutyScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasDutyToday = true; // Set to false to see empty state

  // Mock data - Replace with actual API data
  final Map<String, dynamic> _dutyData = {
    'subject': 'DBMS',
    'examType': 'Semester Exam',
    'date': '16 Dec 2025',
    'time': '2:00 PM - 5:00 PM',
    'hall': 'Examination Hall B',
    'building': 'Main Block',
    'floor': '2nd Floor',
    'students': 120,
    'status': 'Confirmed',
    'coInvigilators': [
      {
        'name': 'Dr. Priya Kumar',
        'department': 'CSE',
        'phone': '+91 98765 43210',
      },
      {
        'name': 'Prof. Anil Sharma',
        'department': 'IT',
        'phone': '+91 98765 43211',
      },
    ],
    'reportingTime': '1:30 PM',
    'questionPaperCollectionTime': '1:30 PM',
  };

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
    final today = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMM yyyy').format(today);

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
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: TeacherColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              // Simulate refresh
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
            },
            icon: const Icon(Icons.refresh),
            color: TeacherColors.iconGray,
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

    if (_hasError) {
      return ErrorStateWidget(
        message: 'Unable to load duty information',
        onRetry: () {
          setState(() {
            _isLoading = true;
            _hasError = false;
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
        },
        onGoBack: () => Navigator.pop(context),
      );
    }

    if (!_hasDutyToday) {
      return EmptyStateWidget(
        emoji: '🎉',
        title: 'No Exam Duty Today',
        subtitle: 'Enjoy your free time!',
        buttonText: 'View Upcoming Duties',
        onButtonPressed: () {
          // Navigate to upcoming duties
          Navigator.pop(context);
        },
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
          children: [
            _buildDutyCard(),
            const SizedBox(height: 16),
            _buildHallDetailsCard(),
            const SizedBox(height: 16),
            _buildCoInvigilatorsCard(),
            const SizedBox(height: 16),
            _buildInstructionsCard(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: TeacherDecorations.tintedCard(
        backgroundColor: TeacherColors.invigilationBg,
        borderColor: TeacherColors.invigilationBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  color: TeacherColors.invigilationColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dutyData['subject'],
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: TeacherColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _dutyData['examType'],
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
          _buildInfoItem(Icons.calendar_today, 'Date', _dutyData['date']),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.access_time, 'Time', _dutyData['time']),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.location_on, 'Hall', _dutyData['hall']),
          const SizedBox(height: 12),
          _buildInfoItem(
            Icons.people,
            'Students',
            '${_dutyData['students']} students',
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: TeacherColors.invigilationBorder),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Status:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                text: _dutyData['status'],
                type: StatusType.confirmed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: TeacherColors.invigilationDark,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
        ),
      ],
    );
  }

  Widget _buildHallDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.domain,
                size: 20,
                color: TeacherColors.infoDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Hall Details',
                style: TeacherTextStyles.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.apartment,
            label: 'Building',
            value: _dutyData['building'],
            iconColor: TeacherColors.infoDark,
          ),
          InfoRow(
            icon: Icons.layers,
            label: 'Floor',
            value: _dutyData['floor'],
            iconColor: TeacherColors.infoDark,
          ),
          InfoRow(
            icon: Icons.event_seat,
            label: 'Capacity',
            value: '150 Students',
            iconColor: TeacherColors.infoDark,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            'Facilities',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: TeacherColors.labelText,
            ),
          ),
          const SizedBox(height: 8),
          _buildFacilityItem(Icons.ac_unit, 'Air Conditioned'),
          _buildFacilityItem(Icons.videocam, 'CCTV Monitoring'),
          _buildFacilityItem(Icons.exit_to_app, 'Emergency Exit Available'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // View on map
                  },
                  icon: const Icon(Icons.map, size: 18),
                  label: Text(
                    'View on Map',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TeacherColors.infoDark,
                    side: BorderSide(
                      color: TeacherColors.infoDark,
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
                    // View hall photo
                  },
                  icon: const Icon(Icons.photo_camera, size: 18),
                  label: Text(
                    'Hall Photo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TeacherColors.infoDark,
                    side: BorderSide(
                      color: TeacherColors.infoDark,
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

  Widget _buildFacilityItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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

  Widget _buildCoInvigilatorsCard() {
    final coInvigilators =
        _dutyData['coInvigilators'] as List<Map<String, dynamic>>;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                size: 20,
                color: TeacherColors.classesDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Co-Invigilators',
                style: TeacherTextStyles.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...coInvigilators.map((invigilator) {
            return CoInvigilatorCard(
              name: invigilator['name'],
              department: invigilator['department'],
              phone: invigilator['phone'],
            );
          }),
        ],
      ),
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
                Icons.info,
                size: 20,
                color: TeacherColors.infoDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Important Instructions',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionItem(
            'Report 30 minutes before exam start time',
          ),
          _buildInstructionItem(
            'Collect question papers from Exam Cell by ${_dutyData['reportingTime']}',
          ),
          _buildInstructionItem(
            'Verify student ID cards thoroughly',
          ),
          _buildInstructionItem(
            'Ensure mobile phones are collected and sealed',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: TeacherColors.infoDark,
          ),
          const SizedBox(width: 12),
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
          child: ElevatedButton(
            onPressed: () {
              _showMarkAttendanceDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherColors.invigilationColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Mark Attendance',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showReportIssueDialog();
            },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.report_problem, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Report Issue',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMarkAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Mark Attendance',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This will mark your attendance for the exam duty. Continue?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: TeacherColors.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Attendance marked successfully',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: TeacherColors.successDark,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherColors.invigilationColor,
            ),
            child: Text('Confirm', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Issue',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Describe the issue',
                labelStyle: GoogleFonts.inter(),
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: TeacherColors.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Issue reported successfully',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: TeacherColors.successDark,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherColors.errorDark,
            ),
            child: Text('Submit', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
}

