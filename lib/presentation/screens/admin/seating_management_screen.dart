import 'package:flutter/material.dart';
import 'admin_design_system.dart';

class SeatingManagementScreen extends StatefulWidget {
  const SeatingManagementScreen({super.key});

  @override
  State<SeatingManagementScreen> createState() => _SeatingManagementScreenState();
}

class _SeatingManagementScreenState extends State<SeatingManagementScreen>
    with TickerProviderStateMixin {
  // State variables
  String? selectedExamDate;
  String? selectedTimeSlot;
  String? selectedSubject;
  String seatingStrategy = 'CIA'; // CIA or Semester
  bool isGenerating = false;
  bool hasGenerated = false;
  List<Map<String, dynamic>> seatingPreview = [];
  List<Map<String, dynamic>> versionHistory = [];
  bool hasConflicts = false;
  
  // Auto-loaded departments based on selected exam
  List<Map<String, dynamic>> enrolledDepartments = [];
  
  // Animation controllers
  late AnimationController _fadeController;
  late List<AnimationController> _sectionControllers;
  
  @override
  void initState() {
    super.initState();
    
    // Main fade controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    // Section stagger controllers (12 sections)
    _sectionControllers = List.generate(
      12,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    
    // Start staggered animations
    _startStaggeredAnimations();
  }
  
  void _startStaggeredAnimations() async {
    for (int i = 0; i < _sectionControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 60 + (i * 15)));
      if (mounted) {
        _sectionControllers[i].forward();
      }
    }
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Column(
            children: [
              // SECTION 1: HEADER
              _buildHeader(context),
              
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 2: Exam Session Selection
                      _buildAnimatedSection(0, _buildExamSessionSelection()),
                      const SizedBox(height: 20),
                      
                      // SECTION 3: Exam Session Summary Card
                      if (selectedExamDate != null && selectedTimeSlot != null && selectedSubject != null)
                        _buildAnimatedSection(1, _buildExamSummaryCard()),
                      if (selectedExamDate != null && selectedTimeSlot != null && selectedSubject != null)
                        const SizedBox(height: 20),
                      
                      // SECTION 4: Seating Strategy Selection
                      _buildAnimatedSection(2, _buildSeatingStrategySelection()),
                      const SizedBox(height: 20),
                      
                      // SECTION 5: Seating Rules
                      _buildAnimatedSection(3, _buildSeatingRules()),
                      const SizedBox(height: 20),
                      
                      // SECTION 6: Hall Allocation
                      _buildAnimatedSection(4, _buildHallAllocation()),
                      const SizedBox(height: 20),
                      
                      // SECTION 7: Conflict Warnings (only if conflicts exist)
                      if (hasConflicts)
                        _buildAnimatedSection(5, _buildConflictWarnings()),
                      if (hasConflicts)
                        const SizedBox(height: 20),
                      
                      // SECTION 8: Generate Seating Button
                      _buildAnimatedSection(6, _buildGenerateButton()),
                      const SizedBox(height: 20),
                      
                      // SECTION 9: Seating Preview
                      if (hasGenerated)
                        _buildAnimatedSection(7, _buildSeatingPreview()),
                      if (hasGenerated)
                        const SizedBox(height: 20),
                      
                      // SECTION 10: Seating Versions
                      if (versionHistory.isNotEmpty)
                        _buildAnimatedSection(8, _buildSeatingVersions()),
                      if (versionHistory.isNotEmpty)
                        const SizedBox(height: 20),
                      
                      // SECTION 11: Seating Documents
                      if (hasGenerated)
                        _buildAnimatedSection(9, _buildSeatingDocuments()),
                      if (hasGenerated)
                        const SizedBox(height: 20),
                      
                      // SECTION 12: Publish Seating
                      if (hasGenerated)
                        _buildAnimatedSection(10, _buildPublishButton()),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  // SECTION 1: Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.generateSeatingAccent,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              'Seating Management',
              style: AppTextStyles.header,
            ),
          ),
          
          // Menu icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.more_vert,
              color: AppColors.iconGray,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Animated section wrapper
  Widget _buildAnimatedSection(int index, Widget child) {
    if (index >= _sectionControllers.length) return child;
    
    return AnimatedBuilder(
      animation: _sectionControllers[index],
      builder: (context, _) {
        return Opacity(
          opacity: _sectionControllers[index].value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _sectionControllers[index].value)),
            child: child,
          ),
        );
      },
    );
  }

  // White card container wrapper
  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsets? padding,
    Color? glowColor,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: child,
    );
  }

  // Section title
  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.generateSeatingAccent, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: AppTextStyles.sectionTitle,
        ),
      ],
    );
  }

  // SECTION 2: Exam Session Selection
  Widget _buildExamSessionSelection() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('EXAM SESSION SELECTION', icon: Icons.calendar_today),
          const SizedBox(height: 16),
          
          // Exam Date Dropdown
          _buildGlassDropdown(
            label: 'Exam Date',
            value: selectedExamDate,
            items: ['12 Sep 2025', '15 Sep 2025', '18 Sep 2025', '22 Sep 2025'],
            onChanged: (value) {
              setState(() {
                selectedExamDate = value;
                _loadEnrolledDepartments();
              });
            },
          ),
          const SizedBox(height: 12),
          
          // Time Slot Dropdown
          _buildGlassDropdown(
            label: 'Time Slot',
            value: selectedTimeSlot,
            items: ['10:00 AM - 12:00 PM', '02:00 PM - 04:00 PM', '09:00 AM - 11:00 AM'],
            onChanged: (value) {
              setState(() {
                selectedTimeSlot = value;
                _loadEnrolledDepartments();
              });
            },
          ),
          const SizedBox(height: 12),
          
          // Subject / Exam Dropdown
          _buildGlassDropdown(
            label: 'Subject / Exam',
            value: selectedSubject,
            items: ['Data Structures', 'Database Management Systems', 'Operating Systems', 'Computer Networks'],
            onChanged: (value) {
              setState(() {
                selectedSubject = value;
                _loadEnrolledDepartments();
              });
            },
          ),
        ],
      ),
    );
  }
  
  // Auto-load departments enrolled in the selected exam
  void _loadEnrolledDepartments() {
    if (selectedExamDate != null && selectedTimeSlot != null && selectedSubject != null) {
      // Simulate loading departments from exam enrollment data
      setState(() {
        enrolledDepartments = [
          {'name': 'CSE', 'year': 'II Year', 'students': 60},
          {'name': 'AI & DS', 'year': 'II Year', 'students': 52},
          {'name': 'IT', 'year': 'II Year', 'students': 48},
        ];
      });
    }
  }

  // White dropdown
  Widget _buildGlassDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.inputBorder,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select $label',
                style: AppTextStyles.bodyText.copyWith(color: AppColors.labelText),
              ),
              dropdownColor: AppColors.cardBackground,
              style: AppTextStyles.bodyText,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.generateSeatingAccent),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // SECTION 3: Exam Session Summary Card
  Widget _buildExamSummaryCard() {
    final totalStudents = enrolledDepartments.fold<int>(
      0, 
      (sum, dept) => sum + (dept['students'] as int),
    );
    
    return _buildGlassContainer(
      glowColor: const Color(0xFF7B2FFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('EXAM SESSION SUMMARY', icon: Icons.assignment),
          const SizedBox(height: 16),
          
          _buildSummaryRow('Subject', selectedSubject ?? '-'),
          const SizedBox(height: 8),
          _buildSummaryRow('Date & Time', '${selectedExamDate ?? '-'} | ${selectedTimeSlot?.split(' - ')[0] ?? '-'}'),
          
          const SizedBox(height: 16),
          
          // Departments Section
          Text(
            'Departments',
            style: AppTextStyles.bodyTextBold.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 8),
          
          ...enrolledDepartments.map((dept) => Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.generateSeatingAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${dept['name']} – ${dept['year']} (${dept['students']} students)',
                    style: AppTextStyles.bodyText,
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: AppColors.dividerLight,
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow('Total Students', totalStudents.toString()),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(color: AppColors.secondaryText),
        ),
        Text(
          value,
          style: AppTextStyles.bodyTextBold,
        ),
      ],
    );
  }

  // SECTION 4: Seating Strategy Selection
  Widget _buildSeatingStrategySelection() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('SEATING STRATEGY', icon: Icons.grid_view),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStrategyButton('CIA', seatingStrategy == 'CIA'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStrategyButton('Semester', seatingStrategy == 'Semester'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyButton(String strategy, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => seatingStrategy = strategy),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.generateSeatingAccent : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.generateSeatingAccent
                : AppColors.inputBorder,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            strategy,
            style: AppTextStyles.bodyTextBold.copyWith(
              color: isSelected ? Colors.white : AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  // SECTION 5: Seating Rules
  Widget _buildSeatingRules() {
    final ruleTitle = seatingStrategy == 'CIA' ? 'CIA EXAM RULES' : 'SEMESTER EXAM RULES';
    final rules = seatingStrategy == 'CIA'
        ? [
            '50 students per hall',
            '2 students per bench',
            'Same bench → different exams',
          ]
        : [
            '25 students per hall',
            '1 student per bench',
            'Alternate departments across rows',
          ];
    
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(ruleTitle, icon: Icons.rule),
          const SizedBox(height: 12),
          ...rules.map((rule) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.generateSeatingAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    rule,
                    style: AppTextStyles.bodyText,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // SECTION 6: Hall Allocation
  Widget _buildHallAllocation() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('HALL ALLOCATION', icon: Icons.meeting_room),
          const SizedBox(height: 16),
          
          _buildHallRow('Main Hall', '60 seats', true),
          const SizedBox(height: 10),
          _buildHallRow('Hall A', '30 seats', true),
          const SizedBox(height: 10),
          _buildHallRow('Hall B', '30 seats', false),
        ],
      ),
    );
  }

  Widget _buildHallRow(String hall, String capacity, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.pendingSeatingBg
            : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppColors.pendingSeatingAccent
              : AppColors.inputBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? AppColors.pendingSeatingAccent : AppColors.labelText,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hall,
              style: AppTextStyles.bodyTextBold,
            ),
          ),
          Text(
            capacity,
            style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  // SECTION 7: Conflict Warnings
  Widget _buildConflictWarnings() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: AppColors.errorColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'CONFLICT WARNINGS',
                style: AppTextStyles.sectionTitle.copyWith(color: AppColors.errorColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWarningItem('Hall A capacity exceeded by 5 students'),
          const SizedBox(height: 8),
          _buildWarningItem('3 students have scheduling conflicts'),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String warning) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 10),
          decoration: BoxDecoration(
            color: AppColors.errorColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            warning,
            style: AppTextStyles.bodyText,
          ),
        ),
      ],
    );
  }

  // SECTION 8: Generate Seating Button
  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: isGenerating ? null : _generateSeating,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.generateSeatingAccent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: isGenerating
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      seatingStrategy == 'CIA'
                          ? 'Pairing students with different exams…'
                          : 'Alternating students by department…',
                      style: AppTextStyles.buttonTextWhite,
                    ),
                  ],
                )
              : Text(
                  'Generate Seating',
                  style: AppTextStyles.buttonTextWhite.copyWith(fontSize: 16),
                ),
        ),
      ),
    );
  }

  void _generateSeating() async {
    setState(() => isGenerating = true);
    
    // Simulate generation
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isGenerating = false;
      hasGenerated = true;
      seatingPreview = List.generate(
        10,
        (index) => {
          'seat': 'A${index + 1}',
          'student': 'Student ${index + 1}',
          'rollNo': '21CS${100 + index}',
          'exam': index % 2 == 0 ? 'DS' : 'DBMS',
        },
      );
      versionHistory.add({
        'version': 'V${versionHistory.length + 1}',
        'date': DateTime.now(),
        'status': 'Draft',
      });
    });
  }

  // SECTION 9: Seating Preview
  Widget _buildSeatingPreview() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('SEATING PREVIEW', icon: Icons.preview),
          const SizedBox(height: 16),
          
          // Filter buttons
          Row(
            children: [
              _buildFilterChip('All', true),
              const SizedBox(width: 8),
              _buildFilterChip('Hall A', false),
              const SizedBox(width: 8),
              _buildFilterChip('Hall B', false),
            ],
          ),
          const SizedBox(height: 16),
          
          // Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.pendingSeatingBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Seat',
                          style: AppTextStyles.tableHeader,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Student',
                          style: AppTextStyles.tableHeader,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Roll No',
                          style: AppTextStyles.tableHeader,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Exam',
                          style: AppTextStyles.tableHeader,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rows
                ...seatingPreview.take(5).map((row) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.dividerLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          row['seat'],
                          style: AppTextStyles.caption,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          row['student'],
                          style: AppTextStyles.caption,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          row['rollNo'],
                          style: AppTextStyles.caption,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          row['exam'],
                          style: AppTextStyles.captionBold.copyWith(color: AppColors.generateSeatingAccent),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.pendingSeatingBg
            : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.pendingSeatingAccent
              : AppColors.inputBorder,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.pendingSeatingAccent : AppColors.secondaryText,
        ),
      ),
    );
  }

  // SECTION 10: Seating Versions
  Widget _buildSeatingVersions() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('SEATING VERSIONS', icon: Icons.history),
          const SizedBox(height: 16),
          
          ...versionHistory.map((version) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.generateSeatingAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      version['version'],
                      style: AppTextStyles.buttonTextWhite.copyWith(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generated on ${version['date'].toString().substring(0, 16)}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        version['status'],
                        style: AppTextStyles.caption.copyWith(color: AppColors.generateAuditAccent),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.generateSeatingAccent,
                  size: 20,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // SECTION 11: Seating Documents
  Widget _buildSeatingDocuments() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('SEATING DOCUMENTS', icon: Icons.description),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildDocButton('View PDF', Icons.visibility, AppColors.generateSeatingAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDocButton('Download PDFs', Icons.download, AppColors.generateSeatingAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color == AppColors.generateSeatingAccent ? AppColors.pendingSeatingBg : AppColors.generateSeatingBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodyTextBold.copyWith(
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 12: Publish Seating Button
  Widget _buildPublishButton() {
    return GestureDetector(
      onTap: _showPublishConfirmation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.successButton,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.publish, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Publish Seating',
                style: AppTextStyles.buttonTextWhite.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPublishConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Publish Seating?',
          style: AppTextStyles.dialogTitle,
        ),
        content: Text(
          'This will make the seating arrangement visible to all students. This action cannot be undone.',
          style: AppTextStyles.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.textButton.copyWith(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Publish logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Publish',
              style: AppTextStyles.buttonTextWhite,
            ),
          ),
        ],
      ),
    );
  }
}
