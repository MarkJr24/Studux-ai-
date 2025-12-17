import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Screen 2: Submit QR Scanned Attendance
/// Review and submit attendance collected via QR scanning
class SubmitQRAttendanceScreen extends StatefulWidget {
  final String className;
  final String classCode;

  const SubmitQRAttendanceScreen({
    super.key,
    required this.className,
    required this.classCode,
  });

  @override
  State<SubmitQRAttendanceScreen> createState() =>
      _SubmitQRAttendanceScreenState();
}

class _SubmitQRAttendanceScreenState extends State<SubmitQRAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final List<ScannedStudent> _scannedStudents = [
    ScannedStudent('21CS001', 'Arun Kumar', '10:02:15 AM', true),
    ScannedStudent('21CS003', 'Charan Reddy', '10:02:47 AM', true),
    ScannedStudent('21CS004', 'Deepak Singh', '10:03:12 AM', true),
  ];

  final List<DuplicateScannedStudent> _duplicates = [
    DuplicateScannedStudent(
      '21CS015',
      'Kiran Kumar',
      '10:03:22 AM',
      '10:04:18 AM',
    ),
  ];

  final List<NotScannedStudent> _notScanned = [
    NotScannedStudent('21CS002', 'Bala Murugan', null),
    NotScannedStudent('21CS025', 'Priya Sharma', null),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _totalRegistered => _scannedStudents.length + _notScanned.length;
  double get _attendanceRate =>
      (_scannedStudents.length / _totalRegistered) * 100;
  bool get _allMarked => _notScanned.every((s) => s.status != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSessionInfo(),
          _buildScanSummary(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScannedTab(),
                _buildDuplicatesTab(),
                _buildNotScannedTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Submit QR Attendance',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          Text(
            'Review scanned attendance',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.calendar_today, 'Date',
              DateFormat('d MMM yyyy').format(DateTime.now())),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.access_time, 'Period', '2nd Hour (10:00-11:00)'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, 'Venue', 'Room 301'),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Scan Start', '10:02 AM'),
              ),
              Expanded(
                child: _buildStatItem('Scan End', '10:08 AM'),
              ),
              Expanded(
                child: _buildStatItem('Duration', '6 minutes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildScanSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '📊 Scan Summary',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  '${_scannedStudents.length}',
                  'Scanned',
                  '✅',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  '${_duplicates.length}',
                  'Duplicate',
                  '🔄',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  '${_notScanned.length}',
                  'Absent',
                  '❌',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Total Registered: $_totalRegistered',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Attendance Rate: ${_attendanceRate.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String number, String label, String emoji) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(number,
              style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937))),
          Text(emoji, style: const TextStyle(fontSize: 20)),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11, color: const Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF3B82F6),
        unselectedLabelColor: const Color(0xFF6B7280),
        indicator: BoxDecoration(
          color: const Color(0xFFDEEAFF),
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: 'Scanned (${_scannedStudents.length})'),
          Tab(text: 'Duplicates (${_duplicates.length})'),
          Tab(text: 'Not Scanned (${_notScanned.length})'),
        ],
      ),
    );
  }

  Widget _buildScannedTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _scannedStudents.length,
      itemBuilder: (context, index) {
        final student = _scannedStudents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Row(
            children: [
              const Text('✅', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student.rollNo} - ${student.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scanned at: ${student.scanTime}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      'Status: Valid',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDuplicatesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _duplicates.length,
      itemBuilder: (context, index) {
        final student = _duplicates[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF59E0B), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🔄', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${student.rollNo} - ${student.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('First Scan:', style: GoogleFonts.inter(fontSize: 12)),
                  const SizedBox(width: 8),
                  Text(student.firstScan,
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  const Text('✅', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('Second Scan:', style: GoogleFonts.inter(fontSize: 12)),
                  const SizedBox(width: 8),
                  Text(student.secondScan,
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Text('(Ignored)',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: const Color(0xFF6B7280))),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Action: First scan counted',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotScannedTab() {
    if (_notScanned.isEmpty) {
      return Center(
        child: Text(
          'All students scanned! 🎉',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF10B981),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _notScanned.length + (_notScanned.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0 && _notScanned.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    Text(
                      'Attention Required',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_notScanned.length} students haven\'t scanned QR. Please mark their attendance manually.',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ],
            ),
          );
        }

        final actualIndex = _notScanned.isNotEmpty ? index - 1 : index;
        final student = _notScanned[actualIndex];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEF4444), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('❌', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${student.rollNo} - ${student.name}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          'QR not scanned',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Mark as:', style: GoogleFonts.inter(fontSize: 12)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                student.status = true;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: student.status == true
                                  ? Colors.white
                                  : const Color(0xFF10B981),
                              backgroundColor: student.status == true
                                  ? const Color(0xFF10B981)
                                  : Colors.white,
                              side: const BorderSide(
                                  color: Color(0xFF10B981)),
                            ),
                            child:
                                Text('Present', style: GoogleFonts.inter()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                student.status = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: student.status == false
                                  ? Colors.white
                                  : const Color(0xFFEF4444),
                              backgroundColor: student.status == false
                                  ? const Color(0xFFEF4444)
                                  : Colors.white,
                              side: const BorderSide(
                                  color: Color(0xFFEF4444)),
                            ),
                            child: Text('Absent', style: GoogleFonts.inter()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  _allMarked
                      ? 'All students marked: ✅ $_totalRegistered/$_totalRegistered'
                      : 'Marked: ${_scannedStudents.length + _notScanned.where((s) => s.status != null).length}/$_totalRegistered',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _allMarked
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
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
                      // Export report
                    },
                    child: Text('Export Report', style: GoogleFonts.inter()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _allMarked ? _submitAttendance : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Submit Attendance',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitAttendance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Final Review', style: GoogleFonts.inter()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChecklistItem('QR scans validated', _scannedStudents.length),
            _buildChecklistItem('Duplicates handled', _duplicates.length),
            _buildChecklistItem('All students marked', _totalRegistered),
            _buildChecklistItem('No validation errors', 0),
            const SizedBox(height: 16),
            Text(
              'Ready to submit?',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: Text('Submit & Lock', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
          const SizedBox(width: 8),
          Text('$label ($count)', style: GoogleFonts.inter(fontSize: 13)),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'QR Attendance Submitted & Locked Successfully!',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text('Present: ${_scannedStudents.length} (via QR)',
                style: GoogleFonts.inter()),
            Text(
                'Present: ${_notScanned.where((s) => s.status == true).length} (manual)',
                style: GoogleFonts.inter()),
            Text(
                'Absent: ${_notScanned.where((s) => s.status == false).length}',
                style: GoogleFonts.inter()),
            const SizedBox(height: 8),
            Text('Submission ID: ATT20251216-001',
                style:
                    GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Download Receipt', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Back to Home', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
}

class ScannedStudent {
  final String rollNo;
  final String name;
  final String scanTime;
  final bool isValid;

  ScannedStudent(this.rollNo, this.name, this.scanTime, this.isValid);
}

class DuplicateScannedStudent {
  final String rollNo;
  final String name;
  final String firstScan;
  final String secondScan;

  DuplicateScannedStudent(
      this.rollNo, this.name, this.firstScan, this.secondScan);
}

class NotScannedStudent {
  final String rollNo;
  final String name;
  bool? status; // true = present, false = absent, null = not marked

  NotScannedStudent(this.rollNo, this.name, this.status);
}

