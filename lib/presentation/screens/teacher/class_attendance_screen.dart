import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassAttendanceScreen extends StatefulWidget {
  const ClassAttendanceScreen({super.key});

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentNavIndex = 1; // Classes is active

  // Student attendance data
  final List<StudentAttendance> _students = [
    StudentAttendance(name: 'John Doe', rollNo: 'CSE001', status: AttendanceStatus.present),
    StudentAttendance(name: 'Jane Smith', rollNo: 'CSE002', status: AttendanceStatus.present),
    StudentAttendance(name: 'Mike Johnson', rollNo: 'CSE003', status: AttendanceStatus.absent),
    StudentAttendance(name: 'Sarah Williams', rollNo: 'CSE004', status: AttendanceStatus.present),
    StudentAttendance(name: 'David Brown', rollNo: 'CSE005', status: AttendanceStatus.present),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF9C27B0).withOpacity(0.1),
              const Color(0xFF673AB7).withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildTabBar(),
              Expanded(
                child: _buildAttendanceTab(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Data Structures – CSE 3A',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF2196F3),
        unselectedLabelColor: const Color(0xFF757575),
        indicatorColor: const Color(0xFF2196F3),
        indicatorWeight: 3,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: 'Attendance'),
          Tab(text: 'Students'),
          Tab(text: 'Materials'),
          Tab(text: 'Class Info'),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Mark Attendance',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Monday, December 15, 2025',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 20),
        ..._students.map((student) => _buildStudentCard(student)),
        const SizedBox(height: 20),
        _buildSubmitButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStudentCard(StudentAttendance student) {
    return Container(
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
            child: Text(
              student.name.split(' ').map((e) => e[0]).join(),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2196F3),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.rollNo,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildAttendanceButton(
                'Present',
                student.status == AttendanceStatus.present,
                Colors.green,
                () {
                  setState(() {
                    student.status = AttendanceStatus.present;
                  });
                },
              ),
              const SizedBox(width: 8),
              _buildAttendanceButton(
                'Absent',
                student.status == AttendanceStatus.absent,
                Colors.red,
                () {
                  setState(() {
                    student.status = AttendanceStatus.absent;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton(
    String label,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance submitted successfully!',
                style: GoogleFonts.inter()),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Text(
        'Submit Attendance',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.school, 'Classes', 1),
          _buildNavItem(Icons.edit_note, 'Evaluation', 2),
          _buildNavItem(Icons.analytics, 'Insights', 3),
          _buildNavItem(Icons.notifications, 'Alerts', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isActive ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

enum AttendanceStatus { present, absent }

class StudentAttendance {
  String name;
  String rollNo;
  AttendanceStatus status;

  StudentAttendance({
    required this.name,
    required this.rollNo,
    required this.status,
  });
}

