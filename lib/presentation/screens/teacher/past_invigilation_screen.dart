import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'teacher_design_system.dart';
import '../../widgets/invigilation_widgets.dart';

class PastInvigilationScreen extends StatefulWidget {
  const PastInvigilationScreen({super.key});

  @override
  State<PastInvigilationScreen> createState() => _PastInvigilationScreenState();
}

class _PastInvigilationScreenState extends State<PastInvigilationScreen> {
  bool _isLoading = false;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock data - Replace with actual API data
  final List<Map<String, dynamic>> _pastDuties = [
    {
      'id': '1',
      'date': DateTime(2025, 12, 9),
      'time': '2:00 PM - 5:00 PM',
      'subject': 'Database Management Systems',
      'subjectCode': 'DBMS',
      'examType': 'Semester End Exam',
      'hall': 'Examination Hall B',
      'studentsRegistered': 120,
      'studentsPresent': 118,
      'studentsAbsent': 2,
      'coInvigilators': ['Dr. Priya Kumar', 'Prof. Anil Sharma'],
      'malpracticeCases': 0,
      'issuesReported': 0,
      'startTime': '2:00 PM',
      'endTime': '5:00 PM',
      'submittedTo': 'Exam Cell',
      'submittedAt': '5:35 PM',
      'verifiedBy': 'Dr. Exam Controller',
      'notes': 'Exam conducted smoothly. All students cooperated well.',
    },
    {
      'id': '2',
      'date': DateTime(2025, 11, 29),
      'time': '10:00 AM - 12:00 PM',
      'subject': 'Data Structures',
      'subjectCode': 'DS',
      'examType': 'CIA-2',
      'hall': 'Lab - 301',
      'studentsRegistered': 60,
      'studentsPresent': 58,
      'studentsAbsent': 2,
      'coInvigilators': ['Prof. Rajesh Gupta'],
      'malpracticeCases': 1,
      'issuesReported': 1,
      'startTime': '10:00 AM',
      'endTime': '12:00 PM',
      'submittedTo': 'Exam Cell',
      'submittedAt': '12:30 PM',
      'verifiedBy': 'Dr. Exam Controller',
      'notes': 'One student caught with unauthorized material.',
    },
    {
      'id': '3',
      'date': DateTime(2025, 11, 15),
      'time': '2:00 PM - 5:00 PM',
      'subject': 'Computer Networks',
      'subjectCode': 'CN',
      'examType': 'Semester End Exam',
      'hall': 'Examination Hall A',
      'studentsRegistered': 100,
      'studentsPresent': 98,
      'studentsAbsent': 2,
      'coInvigilators': ['Dr. Meena Patel', 'Prof. Suresh Kumar'],
      'malpracticeCases': 0,
      'issuesReported': 0,
      'startTime': '2:00 PM',
      'endTime': '5:00 PM',
      'submittedTo': 'Exam Cell',
      'submittedAt': '5:25 PM',
      'verifiedBy': 'Dr. Exam Controller',
      'notes': 'Exam conducted without any issues.',
    },
  ];

  List<Map<String, dynamic>> get _filteredDuties {
    var duties = _pastDuties;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      duties = duties
          .where((duty) =>
              duty['subject']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              duty['subjectCode']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              duty['hall']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply date filter
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'This Semester':
        // Last 6 months
        final sixMonthsAgo = now.subtract(const Duration(days: 180));
        return duties
            .where((duty) => duty['date'].isAfter(sixMonthsAgo))
            .toList();
      case 'Last Semester':
        // 6-12 months ago
        final sixMonthsAgo = now.subtract(const Duration(days: 180));
        final oneYearAgo = now.subtract(const Duration(days: 365));
        return duties
            .where((duty) =>
                duty['date'].isAfter(oneYearAgo) &&
                duty['date'].isBefore(sixMonthsAgo))
            .toList();
      case 'Academic Year':
        // Last 12 months
        final oneYearAgo = now.subtract(const Duration(days: 365));
        return duties
            .where((duty) => duty['date'].isAfter(oneYearAgo))
            .toList();
      default:
        return duties;
    }
  }

  int get _totalThisSemester {
    final sixMonthsAgo =
        DateTime.now().subtract(const Duration(days: 180));
    return _pastDuties
        .where((duty) => duty['date'].isAfter(sixMonthsAgo))
        .length;
  }

  int get _totalThisYear {
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    return _pastDuties
        .where((duty) => duty['date'].isAfter(oneYearAgo))
        .length;
  }

  double get _avgDuration {
    // Mock calculation - in real app, calculate from actual durations
    return 3.2;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  'Invigilation History',
                  style: TeacherTextStyles.pageTitleColored(
                    TeacherColors.successDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_pastDuties.length} completed',
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
              _showSearchDialog();
            },
            icon: const Icon(Icons.search, size: 24),
            color: TeacherColors.iconGray,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingStateWidget(
        message: 'Loading history...',
      );
    }

    return Column(
      children: [
        _buildFilterBar(),
        _buildSummaryCard(),
        Expanded(
          child: _buildHistoryList(),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    final filters = ['All', 'This Semester', 'Last Semester', 'Academic Year'];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: TeacherColors.background,
        border: Border(
          bottom: BorderSide(
            color: TeacherColors.divider,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : TeacherColors.primaryText,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: TeacherColors.successDark,
              backgroundColor: TeacherColors.secondaryBackground,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? TeacherColors.successDark
                    : TeacherColors.cardBorder,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.tintedCard(
        backgroundColor: TeacherColors.successBg,
        borderColor: TeacherColors.successDark.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                size: 20,
                color: TeacherColors.successDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Completed Duties',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'This Semester',
                  '$_totalThisSemester duties',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: TeacherColors.successDark.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'This Year',
                  '$_totalThisYear duties',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: TeacherColors.successDark.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'Total',
                  '${_pastDuties.length} duties',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: TeacherColors.successDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Avg Duration: $_avgDuration hours',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TeacherColors.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: TeacherColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: TeacherColors.successDark,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    if (_filteredDuties.isEmpty) {
      return EmptyStateWidget(
        emoji: '📋',
        title: 'No Invigilation History',
        subtitle: _searchQuery.isNotEmpty
            ? 'No duties found matching your search'
            : 'Your completed duties will appear here',
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
      color: TeacherColors.successDark,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: TeacherSpacing.pageHorizontal,
        ),
        itemCount: _filteredDuties.length + 1, // +1 for export button
        itemBuilder: (context, index) {
          if (index == _filteredDuties.length) {
            return _buildExportSection();
          }
          final duty = _filteredDuties[index];
          return _buildHistoryCard(duty);
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> duty) {
    final dateStr = DateFormat('EEE, d MMM yyyy').format(duty['date']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TeacherColors.secondaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: TeacherColors.secondaryText,
                ),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TeacherColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: TeacherColors.successDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Duty Completed',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: TeacherColors.successDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  duty['subject'],
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: TeacherColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duty['examType'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: TeacherColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.access_time, duty['time']),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, duty['hall']),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.people,
                  '${duty['studentsPresent']}/${duty['studentsRegistered']} Students Present',
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricItem(
                        'Co-Invigilators',
                        '${duty['coInvigilators'].length}',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: TeacherColors.divider,
                    ),
                    Expanded(
                      child: _buildMetricItem(
                        'Malpractice',
                        '${duty['malpracticeCases']}',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: TeacherColors.divider,
                    ),
                    Expanded(
                      child: _buildMetricItem(
                        'Issues',
                        '${duty['issuesReported']}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showDutyReport(duty);
                        },
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
                        child: Text(
                          'View Report',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Download report
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Report downloaded successfully',
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor: TeacherColors.successDark,
                            ),
                          );
                        },
                        icon: const Icon(Icons.download, size: 16),
                        label: Text(
                          'Download',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TeacherColors.successDark,
                          side: BorderSide(
                            color: TeacherColors.successDark,
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
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: TeacherColors.secondaryText,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: TeacherColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: TeacherColors.primaryText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: TeacherColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExportSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Exporting all reports...',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: TeacherColors.successDark,
                  ),
                );
              },
              icon: const Icon(Icons.file_download, size: 20),
              label: Text(
                'Export All Reports',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TeacherColors.successDark,
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
                      'Emailing report...',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: TeacherColors.infoDark,
                  ),
                );
              },
              icon: const Icon(Icons.email, size: 20),
              label: Text(
                'Email Report',
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search History',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search by subject, code, or hall',
            labelStyle: GoogleFonts.inter(),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                color: TeacherColors.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherColors.successDark,
            ),
            child: Text('Search', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  void _showDutyReport(Map<String, dynamic> duty) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: TeacherColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TeacherColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Duty Report - ${duty['subjectCode']} ${duty['examType']}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: TeacherColors.primaryText,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: TeacherColors.iconGray,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReportSection('Basic Details', [
                        _buildReportRow('Date', DateFormat('d MMM yyyy')
                            .format(duty['date'])),
                        _buildReportRow('Time', duty['time']),
                        _buildReportRow('Duration', '3 hours'),
                        _buildReportRow('Hall', duty['hall']),
                      ]),
                      const SizedBox(height: 20),
                      _buildReportSection('Attendance', [
                        _buildReportRow('Registered',
                            '${duty['studentsRegistered']}'),
                        _buildReportRow(
                            'Present', '${duty['studentsPresent']}'),
                        _buildReportRow(
                            'Absent', '${duty['studentsAbsent']}'),
                      ]),
                      const SizedBox(height: 20),
                      _buildReportSection('Exam Conduct', [
                        _buildReportRow('Start Time', duty['startTime']),
                        _buildReportRow('End Time', duty['endTime']),
                        _buildReportRow(
                            'Question Papers', 'Sealed ✓'),
                        _buildReportRow('Answer Sheets',
                            '${duty['studentsPresent']} Collected ✓'),
                      ]),
                      const SizedBox(height: 20),
                      _buildReportSection('Incidents', [
                        _buildReportRow(
                            'Malpractice', '${duty['malpracticeCases']}'),
                        _buildReportRow(
                            'Technical Issues', 'None'),
                        _buildReportRow('Student Queries', '3'),
                      ]),
                      const SizedBox(height: 20),
                      _buildReportSection('Submission Details', [
                        _buildReportRow(
                            'Submitted To', duty['submittedTo']),
                        _buildReportRow(
                            'Submitted At', duty['submittedAt']),
                        _buildReportRow(
                            'Verified By', duty['verifiedBy']),
                      ]),
                      const SizedBox(height: 20),
                      _buildReportSection('Faculty Notes', [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            duty['notes'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: TeacherColors.primaryText,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'PDF downloaded successfully',
                                      style: GoogleFonts.inter(),
                                    ),
                                    backgroundColor:
                                        TeacherColors.successDark,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download, size: 18),
                              label: Text(
                                'Download PDF',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TeacherColors.successDark,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
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
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Email sent successfully',
                                      style: GoogleFonts.inter(),
                                    ),
                                    backgroundColor:
                                        TeacherColors.infoDark,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.email, size: 18),
                              label: Text(
                                'Email Copy',
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: TeacherColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: TeacherDecorations.whiteCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
    );
  }
}

