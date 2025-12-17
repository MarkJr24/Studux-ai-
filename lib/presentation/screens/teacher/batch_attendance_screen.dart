import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Screen 3: Submit as Batch
/// Submit attendance for multiple classes at once
class BatchAttendanceScreen extends StatefulWidget {
  const BatchAttendanceScreen({super.key});

  @override
  State<BatchAttendanceScreen> createState() => _BatchAttendanceScreenState();
}

class _BatchAttendanceScreenState extends State<BatchAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;
  int _submissionProgress = 0;

  final List<ClassBatch> _batches = [
    ClassBatch(
      'Data Structures - II A',
      '2nd Hour (10:00-11:00)',
      60,
      58,
      2,
      true,
      'Manual Entry',
      '10:15 AM',
    ),
    ClassBatch(
      'Operating Systems - II B',
      '3rd Hour (11:00-12:00)',
      60,
      59,
      1,
      true,
      'QR Scan',
      '11:12 AM',
    ),
    ClassBatch(
      'Database Systems - III A',
      '4th Hour (12:00-1:00)',
      60,
      0,
      0,
      false,
      '',
      '',
    ),
  ];

  int get _totalClasses => _batches.length;
  int get _readyClasses => _batches.where((b) => b.isReady).length;
  int get _totalStudents =>
      _batches.fold(0, (sum, batch) => sum + batch.totalStudents);
  bool get _allReady => _batches.every((b) => b.isReady);

  @override
  Widget build(BuildContext context) {
    if (_isSubmitting) {
      return _buildProgressScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInfoBanner(),
            _buildDateSelector(),
            _buildBatchSummary(),
            _buildClassCards(),
            _buildValidationStatus(),
            const SizedBox(height: 80),
          ],
        ),
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
            'Batch Attendance Submission',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          Text(
            'Submit multiple class attendance',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDEEAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Color(0xFF3B82F6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Batch submission allows you to submit attendance for multiple classes at once. Review each carefully before submission.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() => _selectedDate = date);
          }
        },
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF3B82F6)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Date', style: GoogleFonts.inter(fontSize: 12)),
                  Text(
                    DateFormat('d MMM yyyy').format(_selectedDate),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            '📊 Batch Overview',
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
                child: _buildSummaryItem(
                    'Classes Ready', '$_readyClasses/$_totalClasses'),
              ),
              Expanded(
                child: _buildSummaryItem('Total Students', '$_totalStudents'),
              ),
              Expanded(
                child: _buildSummaryItem(
                    'All Marked', _allReady ? 'Yes ✅' : 'No'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildClassCards() {
    return Column(
      children: _batches.map((batch) => _buildClassCard(batch)).toList(),
    );
  }

  Widget _buildClassCard(ClassBatch batch) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: batch.isReady
              ? const Color(0xFF10B981)
              : const Color(0xFFF59E0B),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                batch.isReady ? '✅' : '⚠️',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  batch.className,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildClassInfo('Period', batch.period),
          _buildClassInfo('Students', '${batch.totalStudents}'),
          _buildClassInfo(
              'Present', '${batch.present} | Absent: ${batch.absent}'),
          _buildClassInfo(
              'Status',
              batch.isReady
                  ? 'Ready to Submit'
                  : '❌ Not Marked Yet'),
          if (batch.isReady) ...[
            _buildClassInfo('Method', batch.method),
            _buildClassInfo('Marked at', batch.markedAt),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View details
                  },
                  child: Text(
                    batch.isExpanded ? 'Collapse ▲' : 'View Details ▼',
                    style: GoogleFonts.inter(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _batches.remove(batch);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                  ),
                  child: Text('Remove', style: GoogleFonts.inter()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
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
      ),
    );
  }

  Widget _buildValidationStatus() {
    if (_allReady) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildValidationItem('All classes validated'),
            _buildValidationItem('No pending marks'),
            _buildValidationItem('No conflicts detected'),
            _buildValidationItem('Ready for submission'),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(16),
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
                  'Issues Detected',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...(_batches
                .where((b) => !b.isReady)
                .map((b) => Text('• ${b.className}: Not marked',
                    style: GoogleFonts.inter(fontSize: 13)))),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: Text('Review Issues', style: GoogleFonts.inter()),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildValidationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.inter(fontSize: 13)),
        ],
      ),
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
            Text(
              'Total: $_readyClasses classes | $_totalStudents students',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('Save Draft', style: GoogleFonts.inter()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _allReady ? _submitBatch : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Submit All', style: GoogleFonts.inter()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitBatch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Batch Submission', style: GoogleFonts.inter()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to submit:', style: GoogleFonts.inter()),
            const SizedBox(height: 12),
            ..._batches.where((b) => b.isReady).map(
                  (b) => Text('• ${b.className} (${b.totalStudents})',
                      style: GoogleFonts.inter(fontSize: 13)),
                ),
            const SizedBox(height: 12),
            Text(
                'Total: $_totalStudents students across $_readyClasses classes',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                ],
              ),
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
              setState(() {
                _isSubmitting = true;
              });
              _simulateSubmission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: Text('Confirm & Submit All', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  void _simulateSubmission() async {
    for (int i = 0; i < _readyClasses; i++) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _submissionProgress = i + 1;
      });
    }
    _showSuccessDialog();
  }

  Widget _buildProgressScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Submitting Batch Attendance',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ..._batches.take(_submissionProgress).map(
                    (b) => _buildProgressItem(b.className, true),
                  ),
              if (_submissionProgress < _readyClasses)
                _buildProgressItem(
                    _batches[_submissionProgress].className, false),
              const SizedBox(height: 24),
              Text(
                'Progress: $_submissionProgress/$_readyClasses completed',
                style: GoogleFonts.inter(fontSize: 14),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _submissionProgress / _readyClasses,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
              const SizedBox(height: 16),
              Text(
                'Please wait...',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem(String className, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.hourglass_empty,
            color: done ? const Color(0xFF10B981) : const Color(0xFF6B7280),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(className, style: GoogleFonts.inter(fontSize: 13)),
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
              'Batch Submission Complete!',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text('Successfully submitted:', style: GoogleFonts.inter()),
            const SizedBox(height: 8),
            ..._batches.where((b) => b.isReady).map(
                  (b) => Text('✅ ${b.className}', style: GoogleFonts.inter()),
                ),
            const SizedBox(height: 12),
            Text('Total: $_totalStudents students', style: GoogleFonts.inter()),
            Text('Batch ID: BATCH20251216-001',
                style:
                    GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Download Summary', style: GoogleFonts.inter()),
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

class ClassBatch {
  final String className;
  final String period;
  final int totalStudents;
  final int present;
  final int absent;
  final bool isReady;
  final String method;
  final String markedAt;
  bool isExpanded;

  ClassBatch(
    this.className,
    this.period,
    this.totalStudents,
    this.present,
    this.absent,
    this.isReady,
    this.method,
    this.markedAt, {
    this.isExpanded = false,
  });
}

