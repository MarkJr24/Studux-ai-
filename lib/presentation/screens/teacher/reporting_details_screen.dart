import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import '../../widgets/invigilation_widgets.dart';

class ReportingDetailsScreen extends StatefulWidget {
  const ReportingDetailsScreen({super.key});

  @override
  State<ReportingDetailsScreen> createState() => _ReportingDetailsScreenState();
}

class _ReportingDetailsScreenState extends State<ReportingDetailsScreen> {
  bool _isLoading = false;

  // Mock data - Replace with actual API data
  final Map<String, dynamic> _examData = {
    'subject': 'DBMS',
    'examType': 'Semester Exam',
    'subjectCode': 'CS401',
    'subjectName': 'Database Management Systems',
    'duration': '3 Hours',
    'maxMarks': '100',
    'department': 'CSE',
    'semester': 'IV',
    'section': 'A, B, C (Combined)',
    'hallName': 'Examination Hall B',
    'building': 'Main Block',
    'floor': '2nd Floor',
    'capacity': '150 Students',
    'registered': '120 Students',
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
  };

  final List<TimelineItem> _timeline = [
    TimelineItem(
      time: '1:30 PM',
      description: 'Reporting Time',
    ),
    TimelineItem(
      time: '1:45 PM',
      description: 'Briefing Session',
    ),
    TimelineItem(
      time: '2:00 PM',
      description: 'Exam Starts',
    ),
    TimelineItem(
      time: '5:00 PM',
      description: 'Exam Ends',
    ),
    TimelineItem(
      time: '5:30 PM',
      description: 'Answer Sheet Submission',
    ),
  ];

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
                  'Reporting Details',
                  style: TeacherTextStyles.pageTitleColored(
                    TeacherColors.invigilationColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_examData['subject']} - ${_examData['examType']}',
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
        message: 'Loading reporting details...',
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
            TimelineWidget(items: _timeline),
            const SizedBox(height: 16),
            _buildSubjectDetailsCard(),
            const SizedBox(height: 16),
            _buildHallDetailsCard(),
            const SizedBox(height: 16),
            _buildCoInvigilatorsCard(),
            const SizedBox(height: 16),
            _buildInvigilationGuidelines(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.book,
                size: 20,
                color: TeacherColors.invigilationColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Subject Information',
                style: TeacherTextStyles.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Subject Code', _examData['subjectCode']),
          _buildDetailRow('Subject Name', _examData['subjectName']),
          _buildDetailRow('Exam Type', _examData['examType']),
          _buildDetailRow('Duration', _examData['duration']),
          _buildDetailRow('Max Marks', _examData['maxMarks']),
          _buildDetailRow('Department', _examData['department']),
          _buildDetailRow('Semester', _examData['semester']),
          _buildDetailRow('Section', _examData['section'], isLast: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: TeacherColors.secondaryText,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
        ],
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
                'Examination Hall Details',
                style: TeacherTextStyles.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.meeting_room,
            label: 'Hall Name',
            value: _examData['hallName'],
            iconColor: TeacherColors.infoDark,
          ),
          InfoRow(
            icon: Icons.apartment,
            label: 'Building',
            value: _examData['building'],
            iconColor: TeacherColors.infoDark,
          ),
          InfoRow(
            icon: Icons.layers,
            label: 'Floor',
            value: _examData['floor'],
            iconColor: TeacherColors.infoDark,
          ),
          InfoRow(
            icon: Icons.event_seat,
            label: 'Capacity',
            value: _examData['capacity'],
            iconColor: TeacherColors.infoDark,
          ),
          InfoRow(
            icon: Icons.people,
            label: 'Registered',
            value: _examData['registered'],
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
        _examData['coInvigilators'] as List<Map<String, dynamic>>;

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

  Widget _buildInvigilationGuidelines() {
    return ExpandableSection(
      title: 'Invigilation Guidelines',
      icon: Icons.warning,
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuidelineSection(
            'Before Exam',
            [
              'Collect sealed question papers',
              'Verify student list',
              'Check hall arrangement',
              'Test PA system',
            ],
          ),
          const SizedBox(height: 16),
          _buildGuidelineSection(
            'During Exam',
            [
              'Verify student ID cards',
              'Announce exam rules',
              'Monitor student behavior',
              'Record malpractice cases',
            ],
          ),
          const SizedBox(height: 16),
          _buildGuidelineSection(
            'After Exam',
            [
              'Collect all answer sheets',
              'Count and verify sheets',
              'Submit to exam cell',
              'Complete duty report',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TeacherColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: TeacherColors.warningDark,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: TeacherColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Download instructions PDF
            },
            icon: const Icon(Icons.download, size: 20),
            label: Text(
              'Download Instructions PDF',
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
              _showContactExamCellDialog();
            },
            icon: const Icon(Icons.phone, size: 20),
            label: Text(
              'Contact Exam Cell',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: TeacherColors.infoDark,
              side: BorderSide(
                color: TeacherColors.infoDark,
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

  void _showContactExamCellDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contact Exam Cell',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(Icons.phone, '+91 80 1234 5678'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.email, 'examcell@university.edu'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.location_on, 'Admin Block, 1st Floor'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: TeacherColors.invigilationColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TeacherColors.infoDark),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

