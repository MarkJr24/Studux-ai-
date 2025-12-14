import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HallTicketScreen extends StatelessWidget {
  const HallTicketScreen({super.key});

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
          'Hall Ticket',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hall Ticket Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // College Logo/Name
                  Text(
                    'ZENITH COLLEGE',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2196F3),
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'EXAMINATION HALL TICKET',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF757575),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Student Photo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE3F2FD),
                      border: Border.all(
                        color: const Color(0xFF2196F3),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Student Details Section
                  _buildSectionHeader('STUDENT DETAILS'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Name', 'Harsh Kumar'),
                  _buildDetailRow('Register Number', '21CS001'),
                  _buildDetailRow('Department', 'Computer Science'),
                  _buildDetailRow('Year / Semester', 'II Year / IV Semester'),
                  const SizedBox(height: 20),

                  // Divider
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                  ),
                  const SizedBox(height: 20),

                  // Exam Details Section
                  _buildSectionHeader('EXAM DETAILS'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Subject', 'Data Structures'),
                  _buildDetailRow('Exam Type', 'CIA 2'),
                  _buildDetailRow('Date', '15 December 2025'),
                  _buildDetailRow('Time', '10:00 AM - 01:00 PM'),
                  const SizedBox(height: 12),

                  // Hall and Seat - Prominent Display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'HALL',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF757575),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hall A',
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2196F3),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: 40,
                              color: const Color(0xFF2196F3),
                            ),
                            Column(
                              children: [
                                Text(
                                  'SEAT NUMBER',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF757575),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'A-15',
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2196F3),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // QR Code
                  QrImageView(
                    data: 'HALL_TICKET_21CS001_DS_CIA2_20251215',
                    version: QrVersions.auto,
                    size: 120,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scan for verification',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Signature Placeholder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            height: 1,
                            width: 100,
                            color: const Color(0xFF757575),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Student Signature',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            height: 1,
                            width: 100,
                            color: const Color(0xFF757575),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Controller of Exams',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading hall ticket PDF...',
                              style: GoogleFonts.inter()),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, size: 20),
                    label: Text('Download PDF', style: GoogleFonts.inter()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                          content: Text('Sharing hall ticket...',
                              style: GoogleFonts.inter()),
                          backgroundColor: const Color(0xFF2196F3),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, size: 20),
                    label: Text('Share', style: GoogleFonts.inter()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                      side: const BorderSide(color: Color(0xFF2196F3)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2196F3),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF757575),
              ),
            ),
          ),
          Text(
            ': ',
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
      ),
    );
  }
}

