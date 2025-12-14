import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamGuidelinesScreen extends StatelessWidget {
  const ExamGuidelinesScreen({super.key});

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
          'Exam Guidelines',
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
          // Important Notice Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF9800), width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFFF9800), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please read all guidelines carefully before the exam',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildExpandableSection(
            'Before Exam',
            Icons.info_outline,
            const Color(0xFF2196F3),
            [
              'Reach the exam hall at least 15 minutes before the scheduled time',
              'Carry your Hall Ticket and Student ID Card',
              'Check your seating arrangement in advance',
              'Keep all necessary stationery items ready',
              'Ensure you have sufficient writing materials',
            ],
          ),
          const SizedBox(height: 12),

          _buildExpandableSection(
            'During Exam',
            Icons.rule,
            const Color(0xFF4CAF50),
            [
              'Mobile phones must be switched off and kept aside',
              'Do not talk or communicate with other students',
              'Write your Register Number clearly on the answer sheet',
              'Raise your hand if you need any clarification',
              'Do not leave the exam hall without permission',
              'Use only blue/black pen for writing',
            ],
          ),
          const SizedBox(height: 12),

          _buildExpandableSection(
            'Hall Discipline',
            Icons.gavel,
            const Color(0xFF9C27B0),
            [
              'Maintain absolute silence in the examination hall',
              'Do not disturb other candidates',
              'Follow instructions of invigilators promptly',
              'Do not indulge in any malpractice',
              'Discipline violations may lead to exam cancellation',
            ],
          ),
          const SizedBox(height: 12),

          _buildExpandableSection(
            'Prohibited Items',
            Icons.block,
            const Color(0xFFF44336),
            [
              '❌ Mobile phones and electronic devices',
              '❌ Smart watches and fitness bands',
              '❌ Calculators (unless permitted)',
              '❌ Books, notes, and study materials',
              '❌ Programmable devices',
              '❌ Bluetooth devices and earphones',
            ],
          ),
          const SizedBox(height: 12),

          _buildExpandableSection(
            'Reporting Time',
            Icons.access_time,
            const Color(0xFFFF9800),
            [
              'CIA Exams: 15 minutes before start time',
              'Semester Exams: 30 minutes before start time',
              'Late entry after 15 minutes is strictly prohibited',
              'Gates will be closed 5 minutes before exam starts',
            ],
          ),
          const SizedBox(height: 12),

          // Contact Information Card
          Container(
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
                      child: const Icon(Icons.phone,
                          color: Color(0xFF2196F3), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Contact Information',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildContactRow(Icons.phone, 'Exam Cell', '+91 1234567890'),
                const SizedBox(height: 8),
                _buildContactRow(
                    Icons.email, 'Email', 'exams@zenithcollege.edu'),
                const SizedBox(height: 8),
                _buildContactRow(Icons.location_on, 'Office',
                    'Admin Block, Room 201'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
      String title, IconData icon, Color color, List<String> items) {
    return Container(
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
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          children: [
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF757575),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF757575)),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF757575),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
        ),
      ],
    );
  }
}

