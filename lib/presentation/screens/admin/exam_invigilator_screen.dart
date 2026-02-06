import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seating_management_screen.dart';
import 'admin_design_system.dart';

class ExamInvigilatorScreen extends StatefulWidget {
  const ExamInvigilatorScreen({super.key});

  @override
  State<ExamInvigilatorScreen> createState() => _ExamInvigilatorScreenState();
}

class _ExamInvigilatorScreenState extends State<ExamInvigilatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ExamData> exams = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDemoData();
  }

  void _loadDemoData() {
    exams = [
      ExamData(
        id: '1',
        subject: 'Data Structures',
        date: DateTime.now().add(const Duration(days: 7)),
        timeSlot: '10:00 AM - 12:00 PM',
        department: 'CSE',
        year: '2nd Year',
        examType: 'CIA-1',
        hasInvigilator: true,
        hasSeating: false,
        hasHallTicket: false,
      ),
      ExamData(
        id: '2',
        subject: 'DBMS',
        date: DateTime.now().add(const Duration(days: 10)),
        timeSlot: '2:00 PM - 4:00 PM',
        department: 'CSE',
        year: '3rd Year',
        examType: 'Semester',
        hasInvigilator: false,
        hasSeating: false,
        hasHallTicket: false,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExamsTab(),
                  _buildInvigilatorsTab(),
                  _buildHallTicketTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.backButtonBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              color: AppColors.iconGray,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 16),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Exam & Invigilation',
                  style: AppTextStyles.pageTitleColored(AppColors.examAccent),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage exams and invigilators',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: AppDecorations.tabContainer,
      child: TabBar(
        controller: _tabController,
        indicator: AppDecorations.activeTab,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.primaryButton,
        unselectedLabelColor: AppColors.secondaryText,
        labelStyle: AppTextStyles.tabTextActive,
        unselectedLabelStyle: AppTextStyles.tabTextInactive,
        tabs: const [
          Tab(text: 'Exams'),
          Tab(text: 'Invigilators'),
          Tab(text: 'Hall Ticket'),
        ],
      ),
    );
  }

  // TAB 1: EXAMS
  Widget _buildExamsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.pageHorizontal,
        right: AppSpacing.pageHorizontal,
        bottom: AppSpacing.bottomNavClearance,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Create Exam Button
          GestureDetector(
            onTap: _showCreateExamDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryButton,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Create Exam',
                    style: AppTextStyles.buttonText,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Exam Cards
          ...exams.map((exam) => _buildExamCard(exam)),
        ],
      ),
    );
  }

  Widget _buildExamCard(ExamData exam) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: AnimatedGradientCard(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exam.subject,
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: AppDecorations.badge(AppColors.infoBg),
                      child: Text(
                        exam.examType,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.infoDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Info Rows
                _buildInfoRow(Icons.calendar_today,
                    '${exam.date.day}/${exam.date.month}/${exam.date.year}'),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.access_time, exam.timeSlot),
                const SizedBox(height: 6),
                _buildInfoRow(
                    Icons.school, '${exam.department} - ${exam.year}'),
                const SizedBox(height: 14),

                // Status Indicators
                Row(
                  children: [
                    _buildStatusIndicator(
                      icon: Icons.person,
                      label: 'Invigilator',
                      isComplete: exam.hasInvigilator,
                    ),
                    const SizedBox(width: 16),
                    _buildStatusIndicator(
                      icon: Icons.event_seat,
                      label: 'Seating',
                      isComplete: exam.hasSeating,
                    ),
                    const SizedBox(width: 16),
                    _buildStatusIndicator(
                      icon: Icons.badge,
                      label: 'Hall Ticket',
                      isComplete: exam.hasHallTicket,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'View Details',
                        isPrimary: false,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        label: 'Allocate Seating',
                        isPrimary: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SeatingManagementScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryText),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.bodyText,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required bool isComplete,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isComplete ? Icons.check_circle : Icons.warning,
          size: 18,
          color: isComplete ? AppColors.successColor : AppColors.warningColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isPrimary ? AppColors.primaryButton : AppColors.secondaryButtonBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : AppColors.primaryButton,
            ),
          ),
        ),
      ),
    );
  }

  // TAB 2: INVIGILATORS
  Widget _buildInvigilatorsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.pageHorizontal,
        right: AppSpacing.pageHorizontal,
        bottom: AppSpacing.bottomNavClearance,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'SUGGESTED INVIGILATORS',
            style: AppTextStyles.sectionTitleColored(AppColors.examAccent),
          ),
          const SizedBox(height: 16),

          // Invigilator suggestions
          ..._buildInvigilatorSuggestions(),
        ],
      ),
    );
  }

  List<Widget> _buildInvigilatorSuggestions() {
    final suggestions = [
      {'name': 'Dr. Smith', 'dept': 'CSE', 'score': '95%', 'available': true},
      {'name': 'Prof. John', 'dept': 'ECE', 'score': '88%', 'available': true},
      {'name': 'Dr. Jane', 'dept': 'CSE', 'score': '92%', 'available': false},
    ];

    return suggestions.map((s) {
      final available = s['available'] as bool;
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: AnimatedGradientCard(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: available
                            ? AppColors.successBg
                            : AppColors.warningBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s['score'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: available
                              ? AppColors.successDark
                              : AppColors.warningDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${s['dept']} • ${available ? "Available" : "Clash Detected"}',
                  style: AppTextStyles.bodyText,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallButton('Approve', Icons.check,
                          AppColors.successColor, () {}),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSmallButton('Override', Icons.edit,
                          AppColors.warningColor, () {}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSmallButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: HALL TICKET
  Widget _buildHallTicketTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.pageHorizontal,
        right: AppSpacing.pageHorizontal,
        bottom: AppSpacing.bottomNavClearance,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'HALL TICKET GENERATION',
            style: AppTextStyles.sectionTitleColored(AppColors.examAccent),
          ),
          const SizedBox(height: 16),

          // Hall ticket options
          // Hall ticket options
          ...exams.map((exam) => HallTicketGeneratorCard(exam: exam)),
        ],
      ),
    );
  }

  void _showCreateExamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Create Exam',
          style: AppTextStyles.pageTitle,
        ),
        content: Text(
          'Exam creation form would appear here.',
          style: AppTextStyles.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GradientButton(
            text: 'Save Exam',
            onPressed: () {
              Navigator.pop(context);
              // Add exam logic here
            },
            decoration: AppDecorations.primaryGradientButton,
            height: 48,
          ),
        ],
      ),
    );
  }
}

// Data Model
class ExamData {
  final String id;
  final String subject;
  final DateTime date;
  final String timeSlot;
  final String department;
  final String year;
  final String examType;
  final bool hasInvigilator;
  final bool hasSeating;
  final bool hasHallTicket;

  ExamData({
    required this.id,
    required this.subject,
    required this.date,
    required this.timeSlot,
    required this.department,
    required this.year,
    required this.examType,
    required this.hasInvigilator,
    required this.hasSeating,
    required this.hasHallTicket,
  });
}

class HallTicketGeneratorCard extends StatefulWidget {
  final ExamData exam;

  const HallTicketGeneratorCard({super.key, required this.exam});

  @override
  State<HallTicketGeneratorCard> createState() =>
      _HallTicketGeneratorCardState();
}

class _HallTicketGeneratorCardState extends State<HallTicketGeneratorCard> {
  String? selectedYear;
  String? selectedDepartment;
  bool isGenerated = false;
  bool isGenerating = false;
  List<Map<String, dynamic>> generatedStudents = [];

  final List<String> departments = ['CSE', 'ECE', 'MECH', 'CIVIL', 'BME', 'IT'];
  final List<String> years = ['I Year', 'II Year', 'III Year', 'IV Year'];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: AnimatedGradientCard(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.exam.subject,
                              style: AppTextStyles.cardTitle),
                          const SizedBox(height: 4),
                          Text(widget.exam.examType,
                              style: AppTextStyles.captionBold
                                  .copyWith(color: AppColors.primaryButton)),
                        ],
                      ),
                    ),
                    Icon(Icons.assignment_ind_outlined,
                        color: AppColors.examAccent, size: 28),
                  ],
                ),
                const SizedBox(height: 20),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: !isGenerated
                      ? _buildInputSection()
                      : _buildGeneratedPreview(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdown('Year', years, selectedYear,
                  (val) => setState(() => selectedYear = val)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdown(
                  'Department',
                  departments,
                  selectedDepartment,
                  (val) => setState(() => selectedDepartment = val)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _generateHallTicket,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: AppDecorations.primaryGradientButton,
            child: isGenerating
                ? const Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)))
                : Text(
                    'Generate Hall Tickets',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonTextWhite,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedPreview() {
    return Column(
      children: [
        // Success Message
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.successColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.successDark, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Generated ${generatedStudents.length} Hall Tickets for $selectedDepartment - $selectedYear',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.successDark,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isGenerated = false;
                    generatedStudents.clear();
                  });
                },
                child:
                    Icon(Icons.refresh, size: 18, color: AppColors.successDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Scrollable List of Certificates
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: generatedStudents.length,
          separatorBuilder: (context, index) => const SizedBox(height: 32),
          itemBuilder: (context, index) {
            final student = generatedStudents[index];
            return _buildHallTicketItem(student);
          },
        ),

        // Publish All Button
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Publish all hall tickets
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Successfully published ${generatedStudents.length} hall tickets!'),
                    backgroundColor: AppColors.successColor,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.publish_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Publish All Hall Tickets (${generatedStudents.length})',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHallTicketItem(Map<String, dynamic> student) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // Header - Zenith College
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text(
                  'ZENITH COLLEGE',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2196F3),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'EXAMINATION HALL TICKET',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Student Photo (Circular)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF2196F3), width: 3),
                    color: Colors.grey[100],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: const Color(0xFF2196F3),
                  ),
                ),

                const SizedBox(height: 24),

                // STUDENT DETAILS Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'STUDENT DETAILS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Student Info
                _buildDetailRow('Name', student['name']),
                _buildDetailRow('Register Number', student['rollNo']),
                _buildDetailRow(
                    'Department', selectedDepartment ?? 'Computer Science'),
                _buildDetailRow(
                    'Year / Semester', '$selectedYear / IV Semester'),

                const SizedBox(height: 24),

                // EXAM DETAILS Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'EXAM DETAILS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Exam Info
                _buildDetailRow('Subject', widget.exam.subject),
                _buildDetailRow('Exam Type', 'CIA 2'),
                _buildDetailRow(
                    'Date', '${widget.exam.date.day} December 2025'),
                _buildDetailRow('Time', widget.exam.timeSlot),

                const SizedBox(height: 24),

                // Hall and Seat Number Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF2196F3), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'HALL',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
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
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: const Color(0xFF2196F3),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'SEAT NUMBER',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'A-${15 + generatedStudents.indexOf(student)}',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2196F3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // QR Code
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Center(
                    child: Icon(Icons.qr_code_2, size: 80),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Scan for verification',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            ': ',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateHallTicket() async {
    if (selectedYear == null || selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both Year and Department'),
            backgroundColor: AppColors.errorColor),
      );
      return;
    }

    setState(() => isGenerating = true);

    // Simulate Batch Processing
    await Future.delayed(const Duration(milliseconds: 1500));

    final students = List.generate(5, (index) {
      final id = (index + 1).toString().padLeft(2, '0');
      return {
        'name': 'Student $id',
        'rollNo': '21${selectedDepartment}10$id',
        'id': id,
      };
    });

    setState(() {
      isGenerating = false;
      isGenerated = true;
      generatedStudents = students;
    });
  }

  Widget _buildDropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.cardBackground,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select', style: AppTextStyles.caption),
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.secondaryText),
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e, child: Text(e, style: AppTextStyles.bodyText)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
