import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_design_system.dart';

class AttendanceAuditScreen extends StatefulWidget {
  const AttendanceAuditScreen({super.key});

  @override
  State<AttendanceAuditScreen> createState() => _AttendanceAuditScreenState();
}

class _AttendanceAuditScreenState extends State<AttendanceAuditScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  String? selectedExam;
  bool attendanceAvailable = true;
  bool auditGenerated = false;
  
  final List<String> exams = [
    'Data Structures - CIA 1',
    'DBMS - Semester',
    'Operating Systems - CIA 2',
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
                  _buildSelectExamTab(),
                  _buildConfigureTab(),
                  _buildGenerateTab(),
                  _buildReportTab(),
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
                  'Attendance & Audit',
                  style: AppTextStyles.pageTitleColored(AppColors.auditAccent),
                ),
                const SizedBox(height: 2),
                Text(
                  'Generate and review attendance audit reports',
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
        labelColor: AppColors.auditAccent,
        unselectedLabelColor: AppColors.secondaryText,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Select Exam'),
          Tab(text: 'Configure'),
          Tab(text: 'Generate'),
          Tab(text: 'Report'),
        ],
      ),
    );
  }

  // TAB 1: SELECT EXAM
  Widget _buildSelectExamTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          // Select Exam Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.whiteCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELECT EXAM',
                  style: AppTextStyles.sectionTitleColored(AppColors.auditAccent),
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Exam',
                  style: AppTextStyles.labelText,
                ),
                const SizedBox(height: 8),
                
                // Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: AppDecorations.inputField,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedExam,
                      hint: Text(
                        'Choose an exam',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.labelText,
                        ),
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.auditAccent,
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.captionText,
                      ),
                      items: exams.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedExam = newValue;
                        });
                      },
                    ),
                  ),
                ),
                
                if (selectedExam != null) ...[
                  const SizedBox(height: 20),
                  
                  // Info message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: attendanceAvailable ? AppColors.successBg : AppColors.errorBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          attendanceAvailable ? Icons.check_circle : Icons.error,
                          color: attendanceAvailable ? AppColors.successDark : AppColors.errorDark,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            attendanceAvailable
                                ? 'Attendance data available for this exam'
                                : 'Attendance data not yet recorded',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: attendanceAvailable ? AppColors.successDark : AppColors.errorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Next button
                  if (attendanceAvailable)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _tabController.animateTo(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.auditAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Next: Configure Audit',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // TAB 2: CONFIGURE
  Widget _buildConfigureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          Text(
            'AUDIT CONFIGURATION',
            style: AppTextStyles.sectionTitleColored(AppColors.auditAccent),
          ),
          const SizedBox(height: 16),
          
          // Configuration options
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.whiteCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConfigOption('Include absent students', true),
                const Divider(height: 24),
                _buildConfigOption('Check seating allocation', true),
                const Divider(height: 24),
                _buildConfigOption('Verify invigilator signatures', false),
                const Divider(height: 24),
                _buildConfigOption('Generate detailed report', true),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _tabController.animateTo(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.auditAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Next: Generate Audit',
                style: AppTextStyles.buttonText,
              ),
            ),
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildConfigOption(String label, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.labelText,
        ),
        Switch(
          value: value,
          onChanged: (val) {},
          activeColor: AppColors.toggleActive,
          inactiveTrackColor: AppColors.toggleTrack,
        ),
      ],
    );
  }

  // TAB 3: GENERATE
  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          Text(
            'GENERATE AUDIT',
            style: AppTextStyles.sectionTitleColored(AppColors.auditAccent),
          ),
          const SizedBox(height: 16),
          
          // Generation card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: AppDecorations.whiteCard,
            child: Column(
              children: [
                Icon(
                  auditGenerated ? Icons.check_circle : Icons.assessment,
                  size: 64,
                  color: auditGenerated ? AppColors.successColor : AppColors.auditAccent,
                ),
                const SizedBox(height: 16),
                
                Text(
                  auditGenerated ? 'Audit Generated Successfully' : 'Ready to Generate Audit',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                Text(
                  auditGenerated
                      ? 'Your audit report is ready to view'
                      : 'Click the button below to generate the audit report',
                  style: AppTextStyles.bodyText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        auditGenerated = true;
                      });
                      if (auditGenerated) {
                        _tabController.animateTo(3);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: auditGenerated ? AppColors.successColor : AppColors.auditAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      auditGenerated ? 'View Report' : 'Generate Audit',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // TAB 4: REPORT
  Widget _buildReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          Text(
            'AUDIT REPORT',
            style: AppTextStyles.sectionTitleColored(AppColors.auditAccent),
          ),
          const SizedBox(height: 16),
          
          if (auditGenerated) ...[
            // Summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.whiteCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSummaryRow('Total Students', '150'),
                  const Divider(height: 20),
                  _buildSummaryRow('Present', '145', color: AppColors.successColor),
                  const Divider(height: 20),
                  _buildSummaryRow('Absent', '5', color: AppColors.errorColor),
                  const Divider(height: 20),
                  _buildSummaryRow('Attendance Rate', '96.7%', color: AppColors.successColor),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryButtonBg,
                      foregroundColor: AppColors.iconGray,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Download PDF',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.iconGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.auditAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Share Report',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // No report message
            Container(
              padding: const EdgeInsets.all(32),
              decoration: AppDecorations.whiteCard,
              child: Column(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: AppColors.labelText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Report Generated',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate an audit report to view it here',
                    style: AppTextStyles.bodyText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyTextMedium,
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
