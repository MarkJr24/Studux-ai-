import 'package:flutter/material.dart';
import '../../../models/student_model.dart';
import '../../widgets/admin/student_detail_view.dart';
import 'admin_design_system.dart';

/// Student Management Screen
/// Displays a list of students with search and filter functionality
/// Tapping on a student shows the detailed view

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadStudents() {
    _students = Student.getSampleStudents();
    _filteredStudents = _students;
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students.where((student) {
          return student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.rollNumber.toLowerCase().contains(query.toLowerCase()) ||
              student.department.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _applyStatusFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'All') {
        _filteredStudents = _students;
      } else if (filter == 'Active') {
        _filteredStudents = _students
            .where((s) => s.academicStatus == AcademicStatus.active)
            .toList();
      } else if (filter == 'Credit Shortage') {
        _filteredStudents = _students
            .where((s) => s.academicStatus == AcademicStatus.creditShortage)
            .toList();
      } else if (filter == 'Detained') {
        _filteredStudents = _students
            .where((s) => s.academicStatus == AcademicStatus.detained)
            .toList();
      } else if (filter == 'Blocked') {
        _filteredStudents = _students
            .where((s) => s.eligibilityStatus == EligibilityStatus.blocked)
            .toList();
      }
    });
  }

  void _showStudentDetail(Student student) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => StudentDetailView(
        student: student,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(
              child: _buildStudentList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.headerHorizontal,
        vertical: AppSpacing.headerVertical,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backButtonBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.iconGray,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Management',
                  style: AppTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_filteredStudents.length} students',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: 12,
      ),
      child: Container(
        decoration: AppDecorations.inputField,
        child: TextField(
          controller: _searchController,
          onChanged: _filterStudents,
          style: AppTextStyles.bodyText,
          decoration: InputDecoration(
            hintText: 'Search by name, roll number, or department...',
            hintStyle: AppTextStyles.caption,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.iconLight,
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _filterStudents('');
                    },
                    child: const Icon(
                      Icons.clear,
                      color: AppColors.iconLight,
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Credit Shortage', 'Detained', 'Blocked'];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () => _applyStatusFilter(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryButton
                    : AppColors.secondaryButtonBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryButton
                      : AppColors.divider,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppColors.secondaryText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentList() {
    if (_filteredStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.iconLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No students found',
              style: AppTextStyles.bodyTextMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(
        left: AppSpacing.pageHorizontal,
        right: AppSpacing.pageHorizontal,
        top: 16,
        bottom: AppSpacing.bottomNavClearance,
      ),
      itemCount: _filteredStudents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return _StudentCard(
          student: student,
          onTap: () => _showStudentDetail(student),
        );
      },
    );
  }
}

/// Student Card Widget
class _StudentCard extends StatefulWidget {
  final Student student;
  final VoidCallback onTap;

  const _StudentCard({
    required this.student,
    required this.onTap,
  });

  @override
  State<_StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<_StudentCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;

    switch (widget.student.academicStatus) {
      case AcademicStatus.active:
        statusColor = AppColors.successColor;
        statusBgColor = AppColors.successBg;
        break;
      case AcademicStatus.creditShortage:
        statusColor = AppColors.warningColor;
        statusBgColor = AppColors.warningBg;
        break;
      case AcademicStatus.detained:
        statusColor = AppColors.errorColor;
        statusBgColor = AppColors.errorBg;
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.whiteCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.profileBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.student.name.substring(0, 1).toUpperCase(),
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.profileIcon,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and Roll Number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.student.name,
                          style: AppTextStyles.bodyTextMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.student.rollNumber,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.student.academicStatusText,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Department and Year
              Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 14,
                    color: AppColors.iconLight,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.student.department,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.iconLight,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.student.year,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Quick Status Indicators
              Row(
                children: [
                  _buildQuickStatus(
                    'Hall Ticket',
                    widget.student.hallTicketStatus == HallTicketStatus.uploaded,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickStatus(
                    'Seat',
                    widget.student.seatAllocationStatus ==
                        SeatAllocationStatus.assigned,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickStatus(
                    'Eligible',
                    widget.student.eligibilityStatus == EligibilityStatus.eligible,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatus(String label, bool isPositive) {
    return Row(
      children: [
        Icon(
          isPositive ? Icons.check_circle : Icons.cancel,
          size: 14,
          color: isPositive ? AppColors.successColor : AppColors.errorColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: isPositive ? AppColors.successColor : AppColors.errorColor,
          ),
        ),
      ],
    );
  }
}
