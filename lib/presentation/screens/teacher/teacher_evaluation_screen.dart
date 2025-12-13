import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import '../../../core/widgets/glassmorphic_widgets.dart';

class TeacherEvaluationScreen extends StatefulWidget {
  const TeacherEvaluationScreen({super.key});

  @override
  State<TeacherEvaluationScreen> createState() =>
      _TeacherEvaluationScreenState();
}

class _TeacherEvaluationScreenState extends State<TeacherEvaluationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 2; // Evaluation tab
  bool _ciaSubmitted = false;
  bool _semesterSubmitted = false;
  String _evaluationType = 'Theory';

  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  final List<Map<String, dynamic>> _ciaStudents = [
    {'name': 'John Doe', 'rollNo': 'CSE001', 'marks': 18, 'maxMarks': 20},
    {'name': 'Jane Smith', 'rollNo': 'CSE002', 'marks': 16, 'maxMarks': 20},
    {'name': 'Mike Johnson', 'rollNo': 'CSE003', 'marks': 14, 'maxMarks': 20},
  ];

  final List<Map<String, dynamic>> _submissions = [
    {
      'exam': 'CIA-1',
      'subject': 'Data Structures',
      'status': 'Approved',
      'date': '2024-01-15'
    },
    {
      'exam': 'CIA-2',
      'subject': 'Operating Systems',
      'status': 'Pending',
      'date': '2024-02-20'
    },
    {
      'exam': 'Semester',
      'subject': 'DBMS',
      'status': 'Rejected',
      'date': '2024-03-10'
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.orange.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildInternalTabBar(),
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeTransition(
      opacity: _headerAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFF97316),
                        Color(0xFFCA8A04),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Evaluation',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 72, top: 4),
              child: Text(
                'Manage student assessments',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInternalTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedTabSelector(
        tabs: const ['CIA Evaluation', 'Semester Evaluation', 'Submission Status'],
        selectedIndex: _selectedTabIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        activeGradient: const [
          Color(0xFFF97316),
          Color(0xFFCA8A04),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildCIAEvaluationTab();
      case 1:
        return _buildSemesterEvaluationTab();
      case 2:
        return _buildSubmissionStatusTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCIAEvaluationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CIA Marks Entry',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GlassmorphicContainer(
            blur: 15,
            opacity: 0.1,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMarksTableHeader(),
                const SizedBox(height: 12),
                ..._ciaStudents.map((student) => _buildMarksRow(
                      student['name'],
                      student['rollNo'],
                      student['marks'],
                      student['maxMarks'],
                      _ciaSubmitted,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          NeonGlowButton(
            label: 'Submit to Admin',
            onTap: () {
              setState(() {
                _ciaSubmitted = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('CIA marks submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            gradientColors: const [Color(0xFFF97316), Color(0xFFCA8A04)],
            icon: Icons.send,
            enabled: !_ciaSubmitted,
            isLocked: _ciaSubmitted,
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterEvaluationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semester Marks Entry',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildRadioButton('Theory'),
              const SizedBox(width: 16),
              _buildRadioButton('Practical'),
            ],
          ),
          const SizedBox(height: 16),
          GlassmorphicContainer(
            blur: 15,
            opacity: 0.1,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMarksTableHeader(),
                const SizedBox(height: 12),
                ..._ciaStudents.map((student) => _buildMarksRow(
                      student['name'],
                      student['rollNo'],
                      student['marks'] * 4,
                      100,
                      _semesterSubmitted,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          NeonGlowButton(
            label: 'Submit to Admin',
            onTap: () {
              setState(() {
                _semesterSubmitted = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semester marks submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            gradientColors: const [Color(0xFFF97316), Color(0xFFCA8A04)],
            icon: Icons.send,
            enabled: !_semesterSubmitted,
            isLocked: _semesterSubmitted,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String label) {
    final isSelected = _evaluationType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _evaluationType = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFCA8A04)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFF97316).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submission Status',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._submissions.map((submission) => _buildSubmissionCard(
                submission['exam'],
                submission['subject'],
                submission['status'],
                submission['date'],
              )),
        ],
      ),
    );
  }

  Widget _buildSubmissionCard(
    String exam,
    String subject,
    String status,
    String date,
  ) {
    Color statusColor;
    if (status == 'Approved') {
      statusColor = Colors.green;
    } else if (status == 'Pending') {
      statusColor = Colors.amber;
    } else {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassmorphicContainer(
        blur: 15,
        opacity: 0.1,
        padding: const EdgeInsets.all(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exam,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: status == 'Approved' 
                          ? const Color(0xFF2E7D32)
                          : status == 'Pending'
                              ? const Color(0xFFF57F17)
                              : const Color(0xFFC62828),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subject,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Submitted on $date',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (status == 'Rejected') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: NeonGlowButton(
                  label: 'Edit',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit functionality')),
                    );
                  },
                  gradientColors: const [Color(0xFFF97316), Color(0xFFCA8A04)],
                  icon: Icons.edit,
                  height: 40,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMarksTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Student',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Marks',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Max',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksRow(
    String name,
    String rollNo,
    int marks,
    int maxMarks,
    bool isLocked,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  rollNo,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isLocked
                      ? Colors.grey.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  marks.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isLocked
                        ? AppColors.textSecondary
                        : const Color(0xFF1976D2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Center(
              child: Text(
                maxMarks.toString(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.class_, 'Classes', 1),
          _buildNavItem(Icons.edit_note, 'Evaluation', 2),
          _buildNavItem(Icons.insights, 'Insights', 3),
          _buildNavItem(Icons.notifications, 'Alerts', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFFF97316)
                  : AppColors.textSecondary,
              size: 24,
              shadows: isActive
                  ? [
                      Shadow(
                        color: const Color(0xFFF97316).withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? const Color(0xFFF97316)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
