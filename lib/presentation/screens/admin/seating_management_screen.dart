import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  
  // Multi-select state
  List<String> selectedDepartments = [];
  List<String> selectedYears = [];
  final List<String> availableDepartments = ['CSE', 'ECE', 'MECH', 'CIVIL', 'IT', 'AI & DS'];
  final List<String> availableYears = ['I Year', 'II Year', 'III Year', 'IV Year'];
  
  // Animation controllers
  late AnimationController _fadeController;
  late List<AnimationController> _sectionControllers;
  
  // Controllers
  final TextEditingController _hallCountController = TextEditingController();
  final TextEditingController _seatCountController = TextEditingController();
  
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
    _hallCountController.dispose();
    _seatCountController.dispose();
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

  // Animated card container wrapper with gradient border
  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsets? padding,
    Color? glowColor,
  }) {
    return _AnimatedGradientCard(
      accentColor: glowColor ?? AppColors.generateSeatingAccent,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
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
          const SizedBox(height: 12),

          // Multi-Select Department & Year (Side-by-Side)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMultiSelectInput(
                  label: 'Departments',
                  items: availableDepartments,
                  selectedItems: selectedDepartments,
                  onChanged: (values) => setState(() => selectedDepartments = values),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMultiSelectInput(
                  label: 'Years',
                  items: availableYears,
                  selectedItems: selectedYears,
                  onChanged: (values) => setState(() => selectedYears = values),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Auto-load departments enrolled in the selected exam
  void _loadEnrolledDepartments() {
    if (selectedExamDate != null && selectedTimeSlot != null && selectedSubject != null) {
      // Simulate loading departments from exam enrollment data
      // Don't call setState here - the outer setState in onChanged will handle the rebuild
      enrolledDepartments = [
        {'name': 'CSE', 'year': 'II Year', 'students': 60},
        {'name': 'AI & DS', 'year': 'II Year', 'students': 52},
        {'name': 'IT', 'year': 'II Year', 'students': 48},
      ];
    } else {
      // Clear departments if exam session is incomplete
      enrolledDepartments = [];
    }
  }

  // Multi-select Input used for Dept & Year
  Widget _buildMultiSelectInput({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onChanged,
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
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected Chips
              if (selectedItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: selectedItems.map((item) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.generateSeatingAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.generateSeatingAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.generateSeatingAccent, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              List<String> newSelection = List.from(selectedItems);
                              newSelection.remove(item);
                              onChanged(newSelection);
                            },
                            child: Icon(Icons.close, size: 14, color: AppColors.generateSeatingAccent),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                
              // Add Dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Add $label...',
                      style: AppTextStyles.bodyText.copyWith(color: AppColors.labelText, fontSize: 13),
                    ),
                  ),
                  dropdownColor: AppColors.cardBackground,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.add_circle_outline, color: AppColors.iconGray, size: 18),
                  ),
                  items: items.where((i) => !selectedItems.contains(i)).map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item, style: AppTextStyles.bodyText),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      List<String> newSelection = List.from(selectedItems);
                      newSelection.add(value);
                      onChanged(newSelection);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
            '2 students per bench',
            'Left seat and Right seat arrangement',
            'Maximum seats per hall = admin-provided',
            'Maximum benches per hall = available_seats / 2',
            'Same bench → different exams',
            'Continue seating across halls if students remain',
            'No duplicate students',
            'Deterministic ordering',
          ]
        : [
            '1 student per bench',
            '25 benches per hall (or as provided)',
            'Students alternate between paired departments',
            'Same department students must not sit adjacent',
            'Department pairing uses 12:13 ratio per hall',
            'Continue seating across halls if students remain',
            'No duplicate students',
            'Deterministic ordering',
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

  // SECTION 6: Hall Allocation (Input Driven)
  Widget _buildHallAllocation() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('HALL & SEAT CONFIGURATION', icon: Icons.straighten),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildNumericInput(
                  label: 'How many halls are available?',
                  controller: _hallCountController,
                  hint: 'e.g. 5',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNumericInput(
                  label: 'How many seats are available per hall?',
                  controller: _seatCountController,
                  hint: 'e.g. 30',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumericInput({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.inputBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppTextStyles.bodyText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyText.copyWith(color: AppColors.disabledText),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
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
    // Validate inputs
    if (_hallCountController.text.isEmpty || _seatCountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter hall and seat counts')),
      );
      return;
    }

    setState(() => isGenerating = true);
    
    // Simulate generation
    await Future.delayed(const Duration(seconds: 1)); // Faster animation for demo
    
    final int halls = int.tryParse(_hallCountController.text) ?? 0;
    final int seats = int.tryParse(_seatCountController.text) ?? 0;
    
    // Generate deterministic seating data
    List<Map<String, dynamic>> generatedData = [];
    
    for (int h = 1; h <= halls; h++) {
      for (int s = 1; s <= seats; s++) {
        // Mock distribution logic with Multi-Select support
        String exam = (h + s) % 2 == 0 ? (selectedSubject ?? 'Exam 1') : 'Alt Subject';
        
        // Cycle through selected departments/years if available
        String studentInfo = 'Student';
        if (selectedDepartments.isNotEmpty) {
           final dept = selectedDepartments[(h + s) % selectedDepartments.length];
           studentInfo = '$dept Student';
        }
        if (selectedYears.isNotEmpty) {
           final year = selectedYears[(h * s) % selectedYears.length];
           studentInfo += ' ($year)';
        }

        generatedData.add({
          'hall': 'Hall $h',
          'seat': 'S-$s',
          'student': studentInfo,
          'rollNo': '21CS${100 + (h * 100) + s}',
          'exam': exam,
        });
      }
    }

    setState(() {
      isGenerating = false;
      hasGenerated = true;
      seatingPreview = generatedData;
      versionHistory.add({
        'version': 'V${versionHistory.length + 1}',
        'date': DateTime.now(),
        'status': 'Generated',
      });
    });
  }

  // SECTION 9: Seating Preview
  Widget _buildSeatingPreview() {
    // Get unique halls
    final halls = seatingPreview.map((e) => e['hall'] as String).toSet().toList();
    halls.sort(); // Ensure order Hall 1, Hall 2...

    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('GENERATED ARRANGEMENT', icon: Icons.grid_on),
          const SizedBox(height: 16),
          
          if (halls.isEmpty)
             const Text('No seating generated'),

          ...halls.map((hallName) {
            final hallSeats = seatingPreview.where((e) => e['hall'] == hallName).toList();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: ExpansionTile(
                title: Text(
                   '$hallName (${hallSeats.length} seats)', 
                   style: AppTextStyles.bodyTextBold
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 8),
                shape: const Border(), // Remove borders
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hallSeats.take(10).map((seat) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(4),
                         border: Border.all(color: AppColors.dividerLight),
                      ),
                      child: Tooltip(
                        message: '${seat['student']} - ${seat['rollNo']}',
                        child: Text(
                          '${seat['seat']}',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    )).toList(),
                  ),
                  if (hallSeats.length > 10)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '+ ${hallSeats.length - 10} more seats',
                        style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
                      ),
                    ),
                ],
              ),
            );
          }),
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
  // SECTION 11: Seating Documents (with PDF Preview)
  Widget _buildSeatingDocuments() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('SEATING DOCUMENTS', icon: Icons.description),
          const SizedBox(height: 16),
          
          // PDF Preview Card
          Center(
            child: Container(
              width: 200, // Reduced width to look like a document scaling down
              height: 280, // A4ish aspect ratio
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document Header
                  Row(
                    children: [
                      Icon(Icons.school, size: 16, color: AppColors.primaryText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Zenith Institute',
                          style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16, thickness: 0.5),
                  
                  // Title
                  Center(
                    child: Text(
                      'Seating Arrangement',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Mock Content (Hall & Seats)
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (int.tryParse(_hallCountController.text) ?? 1).clamp(1, 4),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hall ${index + 1}',
                                style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Seats: S-1 to S-${_seatCountController.text}',
                                style: GoogleFonts.inter(fontSize: 7, color: AppColors.secondaryText),
                              ),
                              if (selectedDepartments.isNotEmpty || selectedYears.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    'Candidates: ${selectedDepartments.join(", ")} ${selectedYears.join(", ")}',
                                    style: GoogleFonts.inter(fontSize: 6, color: AppColors.primaryText, fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                height: 4,
                                width: 100,
                                color: Colors.grey[200],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 4,
                                width: 60,
                                color: Colors.grey[200],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Footer
                  Text(
                    'Page 1 of 1',
                    style: GoogleFonts.inter(fontSize: 6, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (c) => Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(20), 
                          child: const Text('Full PDF View Mockup'),
                        ),
                      ),
                    );
                  },
                  child: _buildDocButton('View PDF', Icons.visibility, AppColors.generateSeatingAccent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Seating Arrangement PDF Downloaded'),
                        backgroundColor: AppColors.successColor,
                      ),
                    );
                  },
                  child: _buildDocButton('Download PDF', Icons.download, AppColors.generateSeatingAccent),
                ),
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
          GradientButton(
            text: 'Publish',
            onPressed: () {
              Navigator.pop(context);
              // Publish logic here
            },
            decoration: AppDecorations.successGradientButton,
            height: 48,
          ),
        ],
      ),
    );
  }
}

// Animated Gradient Card Widget
class _AnimatedGradientCard extends StatefulWidget {
  final Widget child;
  final Color accentColor;

  const _AnimatedGradientCard({
    required this.child,
    required this.accentColor,
  });

  @override
  State<_AnimatedGradientCard> createState() => _AnimatedGradientCardState();
}

class _AnimatedGradientCardState extends State<_AnimatedGradientCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: SweepGradient(
                  colors: [
                    widget.accentColor.withOpacity(0.3),
                    widget.accentColor,
                    widget.accentColor.withOpacity(0.5),
                    widget.accentColor.withOpacity(0.8),
                    widget.accentColor,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  transform: GradientRotation(_controller.value * 2 * 3.14159),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: AppDecorations.cardDecoration,
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
