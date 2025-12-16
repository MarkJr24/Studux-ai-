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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
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
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildExamCard(ExamData exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: AppDecorations.whiteCard,
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          _buildInfoRow(Icons.calendar_today, '${exam.date.day}/${exam.date.month}/${exam.date.year}'),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.access_time, exam.timeSlot),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.school, '${exam.department} - ${exam.year}'),
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
                        builder: (context) => const SeatingManagementScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          color: isPrimary ? AppColors.primaryButton : AppColors.secondaryButtonBg,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          
          const SizedBox(height: 80),
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
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.whiteCard,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: available ? AppColors.successBg : AppColors.warningBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s['score'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: available ? AppColors.successDark : AppColors.warningDark,
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
                  child: _buildSmallButton('Approve', Icons.check, AppColors.successColor, () {}),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSmallButton('Override', Icons.edit, AppColors.warningColor, () {}),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSmallButton(String label, IconData icon, Color color, VoidCallback onTap) {
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          ...exams.map((exam) => _buildHallTicketCard(exam)),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHallTicketCard(ExamData exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: AppDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exam.subject,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '${exam.department} - ${exam.year}',
            style: AppTextStyles.bodyText,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: exam.hasHallTicket ? 'Regenerate' : 'Generate',
                  isPrimary: !exam.hasHallTicket,
                  onTap: () {},
                ),
              ),
              if (exam.hasHallTicket) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: 'Download',
                    isPrimary: false,
                    onTap: () {},
                  ),
                ),
              ],
            ],
          ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add exam logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save Exam',
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
