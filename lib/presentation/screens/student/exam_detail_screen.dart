import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exam_schedule_screen.dart';
import 'hall_ticket_screen.dart';
import 'seating_information_screen.dart';

class ExamDetailScreen extends StatelessWidget {
  final ExamItem exam;

  const ExamDetailScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final isUpcoming = exam.status == 'Upcoming';
    final daysUntil = 3; // Mock countdown

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          exam.subject,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isUpcoming
                      ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                      : [const Color(0xFF9E9E9E), const Color(0xFF757575)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      exam.type,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  if (isUpcoming) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Exam in',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$daysUntil',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'days',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Date & Time Card
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    color: const Color(0xFF2196F3),
                    title: 'Date & Time',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Color(0xFF757575)),
                            const SizedBox(width: 8),
                            Text(
                              exam.date,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Color(0xFF757575)),
                            const SizedBox(width: 8),
                            Text(
                              exam.time,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Venue Card
                  if (exam.venue.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.location_on,
                      color: const Color(0xFFFF9800),
                      title: 'Venue Information',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Color(0xFF757575)),
                              const SizedBox(width: 8),
                              Text(
                                exam.venue,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.event_seat,
                                  size: 16, color: Color(0xFF757575)),
                              const SizedBox(width: 8),
                              Text(
                                'Seat: A-15',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Exam Details Card
                  _buildInfoCard(
                    icon: Icons.info_outline,
                    color: const Color(0xFF9C27B0),
                    title: 'Exam Details',
                    content: Column(
                      children: [
                        _buildDetailRow('Duration', '3 hours'),
                        _buildDetailRow('Total Marks', '50'),
                        _buildDetailRow('Pattern', 'Descriptive'),
                        _buildDetailRow('Faculty', 'Dr. Kumar'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Actions
                  Text(
                    'QUICK ACTIONS',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF757575),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildActionButton(
                    icon: Icons.confirmation_number,
                    label: 'View Hall Ticket',
                    color: const Color(0xFF2196F3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HallTicketScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.event_seat,
                    label: 'View Seating',
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SeatingInformationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.notifications_active,
                    label: 'Set Reminder',
                    color: const Color(0xFFFF9800),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reminder set for exam',
                              style: GoogleFonts.inter()),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.book,
                    label: 'View Syllabus',
                    color: const Color(0xFF9C27B0),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening syllabus...',
                              style: GoogleFonts.inter()),
                          backgroundColor: const Color(0xFF2196F3),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Instructions
                  _buildExpandableInstructions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required Widget content,
  }) {
    return Container(
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF757575),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableInstructions() {
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
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.assignment, color: Color(0xFF2196F3), size: 24),
          ),
          title: Text(
            'Instructions & Guidelines',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          children: [
            Text(
              '• Reach 15 minutes before exam time\n'
              '• Bring Hall Ticket and Student ID\n'
              '• Mobile phones strictly prohibited\n'
              '• Use blue/black pen only\n'
              '• Follow exam hall discipline',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF757575),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

