import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen 4: Booklet Number Entry
/// Record exam booklet numbers for answer sheets
class BookletEntryScreen extends StatefulWidget {
  const BookletEntryScreen({super.key});

  @override
  State<BookletEntryScreen> createState() => _BookletEntryScreenState();
}

class _BookletEntryScreenState extends State<BookletEntryScreen> {
  bool _quickEntryMode = false;
  int _currentStudentIndex = 0;
  final TextEditingController _bookletController = TextEditingController();
  String _filter = 'All'; // All, Entered, Pending

  final List<BookletStudent> _students = [
    BookletStudent('21CS001', 'Arun Kumar', true, null),
    BookletStudent('21CS002', 'Bala Murugan', false, null),
    BookletStudent('21CS003', 'Charan Reddy', true, 'A-00237'),
    BookletStudent('21CS004', 'Deepak Singh', true, null),
    BookletStudent('21CS005', 'Ezhil Arasan', true, 'A-00238'),
  ];

  List<BookletStudent> get _filteredStudents {
    switch (_filter) {
      case 'Entered':
        return _students.where((s) => s.bookletNumber != null).toList();
      case 'Pending':
        return _students
            .where((s) => s.isPresent && s.bookletNumber == null)
            .toList();
      default:
        return _students;
    }
  }

  int get _enteredCount =>
      _students.where((s) => s.bookletNumber != null).length;
  int get _presentCount => _students.where((s) => s.isPresent).length;

  @override
  void dispose() {
    _bookletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_quickEntryMode) {
      return _buildQuickEntryMode();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildExamContext(),
          _buildInfoBanner(),
          _buildProgressCard(),
          _buildFilterBar(),
          Expanded(
            child: _buildStudentList(),
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
      title: Text(
        'Booklet Number Entry',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2937),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.flash_on, color: Color(0xFFF59E0B)),
          onPressed: () {
            setState(() {
              _quickEntryMode = true;
              _currentStudentIndex = 0;
            });
          },
          tooltip: 'Quick Entry Mode',
        ),
      ],
    );
  }

  Widget _buildExamContext() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📚 Exam Details',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildExamInfo('Subject', 'Database Systems (DBMS)'),
          _buildExamInfo('Exam Type', 'Semester End'),
          _buildExamInfo('Date', '16 Dec 2025'),
          _buildExamInfo('Hall', 'Examination Hall B'),
          _buildExamInfo('Students', '120'),
          _buildExamInfo('Present', '118 (entered attendance)'),
        ],
      ),
    );
  }

  Widget _buildExamInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDEEAFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Color(0xFF3B82F6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Enter the booklet number printed on each student\'s answer sheet.',
              style: GoogleFonts.inter(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = _presentCount > 0 ? _enteredCount / _presentCount : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '📊 Entry Progress',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem('Entered', '$_enteredCount'),
              _buildProgressItem('Remaining', '${_presentCount - _enteredCount}'),
              _buildProgressItem('Total', '$_presentCount'),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% Complete',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
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
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All', _students.length),
          const SizedBox(width: 8),
          _buildFilterChip('Entered', _enteredCount),
          const SizedBox(width: 8),
          _buildFilterChip('Pending', _presentCount - _enteredCount),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _filter == label;
    return FilterChip(
      label: Text(
        '$label ($count)',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: isSelected ? Colors.white : const Color(0xFF1F2937),
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filter = label);
      },
      selectedColor: const Color(0xFF3B82F6),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildStudentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return _buildStudentCard(student);
      },
    );
  }

  Widget _buildStudentCard(BookletStudent student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: student.bookletNumber != null
              ? const Color(0xFF10B981)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student.rollNo} - ${student.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.isPresent ? '✅ Present' : '❌ Absent',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: student.isPresent
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              if (student.bookletNumber != null)
                const Icon(Icons.check_circle, color: Color(0xFF10B981)),
            ],
          ),
          if (student.isPresent) ...[
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Booklet Number',
                hintText: 'Enter booklet number',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    // Scan barcode
                  },
                ),
              ),
              controller: TextEditingController(text: student.bookletNumber),
              onChanged: (value) {
                setState(() {
                  student.bookletNumber = value.isEmpty ? null : value;
                });
              },
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              '(Booklet entry disabled)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
              'Entered: $_enteredCount/$_presentCount',
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
                    onPressed: _submitBookletData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        Text('Submit Booklet Data', style: GoogleFonts.inter()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickEntryMode() {
    if (_currentStudentIndex >= _presentCount) {
      return _buildQuickEntryComplete();
    }

    final student = _students
        .where((s) => s.isPresent)
        .toList()[_currentStudentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _quickEntryMode = false;
            });
          },
        ),
        title: Text('Quick Entry Mode', style: GoogleFonts.inter()),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🚀 Quick Entry Mode',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Current: ${student.rollNo} - ${student.name}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _bookletController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Booklet Number',
                  hintText: 'Enter or scan',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  _saveAndNext(student, value);
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Press Enter or scan to continue',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: _currentStudentIndex / _presentCount,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              ),
              const SizedBox(height: 8),
              Text(
                'Progress: $_currentStudentIndex/$_presentCount',
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickEntryComplete() {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          child: Column(
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
                'Quick Entry Complete!',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _quickEntryMode = false;
                  });
                },
                child: Text('Back to List', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAndNext(BookletStudent student, String value) {
    setState(() {
      student.bookletNumber = value;
      _currentStudentIndex++;
      _bookletController.clear();
    });
  }

  void _submitBookletData() {
    final pending = _presentCount - _enteredCount;
    if (pending > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Submit Booklet Numbers?', style: GoogleFonts.inter()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Entered: $_enteredCount booklets', style: GoogleFonts.inter()),
              Text('Pending: $pending students', style: GoogleFonts.inter()),
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
                        'Incomplete entries detected. Submit anyway?',
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
              child: Text('Go Back', style: GoogleFonts.inter()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessDialog();
              },
              child: Text('Submit Anyway', style: GoogleFonts.inter()),
            ),
          ],
        ),
      );
    } else {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
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
              'Booklet Data Submitted',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text('Total Recorded: $_enteredCount booklets', style: GoogleFonts.inter()),
            Text('Reference ID: BKT20251216-001',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Download Report', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Back', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
}

class BookletStudent {
  final String rollNo;
  final String name;
  final bool isPresent;
  String? bookletNumber;

  BookletStudent(this.rollNo, this.name, this.isPresent, this.bookletNumber);
}

