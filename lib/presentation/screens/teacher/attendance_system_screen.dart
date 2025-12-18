import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import 'package:intl/intl.dart';

class AttendanceSystemScreen extends StatefulWidget {
  const AttendanceSystemScreen({super.key});

  @override
  State<AttendanceSystemScreen> createState() => _AttendanceSystemScreenState();
}

class _AttendanceSystemScreenState extends State<AttendanceSystemScreen> {
  String _attendanceMode = 'manual';
  bool _isSubmitted = false;
  
  final List<Map<String, dynamic>> _students = [
    {'regNo': '21CS01', 'name': 'Arun', 'isPresent': true},
    {'regNo': '21CS02', 'name': 'Bala', 'isPresent': true},
    {'regNo': '21CS03', 'name': 'Charan', 'isPresent': false},
    {'regNo': '21CS04', 'name': 'Deepak', 'isPresent': true},
    {'regNo': '21CS05', 'name': 'Esha', 'isPresent': true},
    {'regNo': '21CS06', 'name': 'Farhan', 'isPresent': true},
    {'regNo': '21CS07', 'name': 'Geetha', 'isPresent': false},
    {'regNo': '21CS08', 'name': 'Hari', 'isPresent': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClassContextCard(),
                    const SizedBox(height: 20),
                    _buildAttendanceModeSelector(),
                    const SizedBox(height: 20),
                    _buildStudentList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isSubmitted ? null : _buildSubmitButton(),
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
                  'Mark Attendance',
                  style: TeacherTextStyles.pageTitleColored(TeacherColors.infoDark),
                ),
                const SizedBox(height: 2),
                Text(
                  'Scan QR or enter manually',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),
          if (_isSubmitted)
            Icon(
              Icons.lock,
              color: TeacherColors.successIcon,
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildClassContextCard() {
    final today = DateFormat('dd MMM yyyy').format(DateTime.now());
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Class Attendance',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TeacherColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Academic Day : $today',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TeacherColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Mode',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TeacherColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'manual',
                  groupValue: _attendanceMode,
                  onChanged: _isSubmitted ? null : (value) {
                    setState(() {
                      _attendanceMode = value!;
                    });
                  },
                  title: Text(
                    'Manual Attendance',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  activeColor: Colors.blue,
                ),
                RadioListTile<String>(
                  value: 'qr',
                  groupValue: _attendanceMode,
                  onChanged: _isSubmitted ? null : (value) {
                    setState(() {
                      _attendanceMode = value!;
                    });
                  },
                  title: Text(
                    'QR Attendance',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reg No',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _students.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final student = _students[index];
              return InkWell(
                onTap: _isSubmitted ? null : () {
                  setState(() {
                    student['isPresent'] = !student['isPresent'];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          student['regNo'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: TeacherColors.primaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          student['name'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: TeacherColors.primaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              student['isPresent'] ? Icons.check_circle : Icons.cancel,
                              color: student['isPresent'] ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              student['isPresent'] ? 'Present' : 'Absent',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: student['isPresent'] ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showSubmitConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              'SUBMIT ATTENDANCE',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirm Submission',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Once submitted, attendance cannot be edited. Continue?',
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSubmitted = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Attendance submitted successfully',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
