import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  final List<Map<String, dynamic>> subjects = const [
    {'name': 'Data Structures', 'present': 42, 'total': 50, 'percentage': 84},
    {
      'name': 'Database Management Systems',
      'present': 45,
      'total': 50,
      'percentage': 90
    },
    {
      'name': 'Operating Systems',
      'present': 38,
      'total': 50,
      'percentage': 76
    },
    {
      'name': 'Computer Networks',
      'present': 40,
      'total': 50,
      'percentage': 80
    },
    {'name': 'AI & Machine Learning', 'present': 35, 'total': 45, 'percentage': 78},
  ];

  @override
  Widget build(BuildContext context) {
    final totalPresent = subjects.fold<int>(0, (sum, s) => sum + (s['present'] as int));
    final totalClasses = subjects.fold<int>(0, (sum, s) => sum + (s['total'] as int));
    final overallPercentage = ((totalPresent / totalClasses) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Attendance',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall attendance card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Overall Attendance',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$overallPercentage%',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalPresent / $totalClasses classes attended',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'SUBJECT-WISE ATTENDANCE',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          ...subjects.map((subject) => _buildSubjectCard(context, subject)),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Map<String, dynamic> subject) {
    bool isEligible = subject['percentage'] >= 75;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _buildAttendanceDetails(subject),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isEligible ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
            width: 2,
          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subject['name'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isEligible
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : const Color(0xFFFF5252).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${subject['percentage']}%',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEligible
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF5252),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Present: ${subject['present']}',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF757575)),
                ),
                const SizedBox(width: 16),
                Text(
                  'Total: ${subject['total']}',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF757575)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: subject['percentage'] / 100,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isEligible ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEligible
                  ? '✓ Eligible for exam'
                  : '⚠️ Below minimum (75%)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isEligible
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFF5252),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails(Map<String, dynamic> subject) {
    final absent = subject['total'] - subject['present'];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject['name'],
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Classes Attended', '${subject['present']}'),
          _buildDetailRow('Total Classes', '${subject['total']}'),
          _buildDetailRow('Absent', '$absent'),
          _buildDetailRow('Percentage', '${subject['percentage']}%'),
          const SizedBox(height: 16),
          Text(
            'Note: Minimum 75% attendance required for exam eligibility',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF757575),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
                fontSize: 14, color: const Color(0xFF757575)),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }
}

