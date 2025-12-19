import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamHistoryScreen extends StatefulWidget {
  const ExamHistoryScreen({super.key});

  @override
  State<ExamHistoryScreen> createState() => _ExamHistoryScreenState();
}

class _ExamHistoryScreenState extends State<ExamHistoryScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'This Semester', 'Last Year'];

  final List<ExamHistory> _history = [
    ExamHistory(
      subject: 'AI & Machine Learning',
      type: 'CIA',
      date: '10 Dec 2025',
      attendance: 'Present',
      resultStatus: 'Published',
      marks: '38/50',
      grade: 'A',
    ),
    ExamHistory(
      subject: 'Data Structures',
      type: 'CIA',
      date: '5 Dec 2025',
      attendance: 'Present',
      resultStatus: 'Published',
      marks: '45/50',
      grade: 'A+',
    ),
    ExamHistory(
      subject: 'DBMS',
      type: 'Semester',
      date: '28 Nov 2025',
      attendance: 'Present',
      resultStatus: 'Published',
      marks: '85/100',
      grade: 'O',
    ),
    ExamHistory(
      subject: 'Computer Networks',
      type: 'CIA',
      date: '25 Nov 2025',
      attendance: 'Present',
      resultStatus: 'Pending',
      marks: '-',
      grade: '-',
    ),
    ExamHistory(
      subject: 'Operating Systems',
      type: 'CIA',
      date: '20 Nov 2025',
      attendance: 'Present',
      resultStatus: 'Published',
      marks: '42/50',
      grade: 'A',
    ),
  ];

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
          'Exam History',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF9E9E9E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Optional',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF757575),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
          ),

          // History list with timeline
          Expanded(
            child: _history.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(_history[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(ExamHistory history, int index) {
    final isPresent = history.attendance == 'Present';
    final isPublished = history.resultStatus == 'Published';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isPresent
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : const Color(0xFFF44336).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPresent
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
                  width: 2,
                ),
              ),
              child: Icon(
                isPresent ? Icons.check : Icons.close,
                color: isPresent
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFF44336),
                size: 20,
              ),
            ),
            if (index < _history.length - 1)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF9E9E9E),
                      const Color(0xFF9E9E9E).withOpacity(0.3),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Card
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                      Expanded(
                        child: Text(
                          history.subject,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          history.type,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Color(0xFF757575)),
                      const SizedBox(width: 4),
                      Text(
                        history.date,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: const Color(0xFF757575)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Attendance status
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPresent
                                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                                    : const Color(0xFFF44336).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPresent
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 14,
                                    color: isPresent
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFF44336),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    history.attendance,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: isPresent
                                          ? const Color(0xFF4CAF50)
                                          : const Color(0xFFF44336),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Result status
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPublished
                              ? const Color(0xFF2196F3).withOpacity(0.1)
                              : const Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          history.resultStatus,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isPublished
                                ? const Color(0xFF2196F3)
                                : const Color(0xFFFF9800),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isPublished) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Marks',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                history.marks,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: const Color(0xFFE0E0E0),
                          ),
                          Column(
                            children: [
                              Text(
                                'Grade',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                history.grade,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 80,
            color: const Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 16),
          Text(
            'No exam history available',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your exam history will appear here',
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

class ExamHistory {
  final String subject;
  final String type;
  final String date;
  final String attendance;
  final String resultStatus;
  final String marks;
  final String grade;

  ExamHistory({
    required this.subject,
    required this.type,
    required this.date,
    required this.attendance,
    required this.resultStatus,
    required this.marks,
    required this.grade,
  });
}

