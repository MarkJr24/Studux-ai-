import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exam_detail_screen.dart';

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'CIA', 'Semester'];

  final List<ExamItem> _exams = [
    ExamItem(
      subject: 'Data Structures',
      type: 'CIA',
      date: '15 Dec 2025',
      time: '10:00 AM - 01:00 PM',
      venue: 'Hall A',
      status: 'Upcoming',
      icon: Icons.code,
    ),
    ExamItem(
      subject: 'Database Management Systems',
      type: 'CIA',
      date: '18 Dec 2025',
      time: '10:00 AM - 01:00 PM',
      venue: 'Hall B',
      status: 'Upcoming',
      icon: Icons.storage,
    ),
    ExamItem(
      subject: 'Operating Systems',
      type: 'Semester',
      date: '20 Dec 2025',
      time: '09:00 AM - 12:00 PM',
      venue: 'Hall C',
      status: 'Upcoming',
      icon: Icons.computer,
    ),
    ExamItem(
      subject: 'Computer Networks',
      type: 'CIA',
      date: '22 Dec 2025',
      time: '02:00 PM - 05:00 PM',
      venue: 'Hall A',
      status: 'Upcoming',
      icon: Icons.wifi,
    ),
    ExamItem(
      subject: 'AI & Machine Learning',
      type: 'Semester',
      date: '10 Dec 2025',
      time: '10:00 AM - 01:00 PM',
      venue: 'Hall B',
      status: 'Completed',
      icon: Icons.psychology,
    ),
  ];

  List<ExamItem> get _filteredExams {
    if (_selectedFilter == 'All') {
      return _exams;
    }
    return _exams.where((e) => e.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exam Schedule',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF2196F3)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2196F3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2196F3)
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.inter(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF757575),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Exams list
          Expanded(
            child: _filteredExams.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredExams.length,
                    itemBuilder: (context, index) {
                      return _buildExamCard(_filteredExams[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(ExamItem exam) {
    final isUpcoming = exam.status == 'Upcoming';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExamDetailScreen(exam: exam),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(exam.icon, color: const Color(0xFF2196F3), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.subject,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          exam.type,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : const Color(0xFF9E9E9E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exam.status,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isUpcoming
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF757575),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  exam.date,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 14, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  exam.time,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
              ],
            ),
            if (exam.venue.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 14, color: Color(0xFF757575)),
                  const SizedBox(width: 4),
                  Text(
                    exam.venue,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: const Color(0xFF757575)),
                  ),
                ],
              ),
            ],
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
            Icons.calendar_today_outlined,
            size: 80,
            color: const Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 16),
          Text(
            'No exams scheduled',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your exam schedule will appear here',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamItem {
  final String subject;
  final String type;
  final String date;
  final String time;
  final String venue;
  final String status;
  final IconData icon;

  ExamItem({
    required this.subject,
    required this.type,
    required this.date,
    required this.time,
    required this.venue,
    required this.status,
    required this.icon,
  });
}

