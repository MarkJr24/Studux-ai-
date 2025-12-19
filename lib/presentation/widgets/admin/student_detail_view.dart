import 'package:flutter/material.dart';
import '../../../../models/student_model.dart';
import '../../screens/admin/admin_design_system.dart';

/// Student Detail View Widget
/// Displays comprehensive student information in a modal bottom sheet
/// with subtle animations and clean design

class StudentDetailView extends StatefulWidget {
  final Student student;
  final VoidCallback onClose;

  const StudentDetailView({
    super.key,
    required this.student,
    required this.onClose,
  });

  @override
  State<StudentDetailView> createState() => _StudentDetailViewState();
}

class _StudentDetailViewState extends State<StudentDetailView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _animationController.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: _handleClose,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping on the content
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  constraints: BoxConstraints(
                    maxWidth: 500,
                    maxHeight: screenHeight * 0.85, // Max 85% of screen height
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cardBorder,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      Flexible(
                        child: _buildContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Student Details',
              style: AppTextStyles.cardTitle.copyWith(
                decoration: TextDecoration.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: _handleClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.iconGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInformation(),
          const SizedBox(height: 24),
          _buildAcademicStatus(),
          const SizedBox(height: 24),
          _buildOperationalStatus(),
          const SizedBox(height: 24),
          _buildActivitySummary(),
        ],
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BASIC INFORMATION',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.primaryButton,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildInfoRow('Student Name', widget.student.name, isLarge: true),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildInfoRow('Roll Number', widget.student.rollNumber),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildInfoRow('Department', widget.student.department),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildInfoRow('Year', widget.student.year),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildInfoRow('Semester', widget.student.semester),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicStatus() {
    Color statusColor;
    Color statusBgColor;

    switch (widget.student.academicStatus) {
      case AcademicStatus.active:
        statusColor = AppColors.successDark;
        statusBgColor = AppColors.successBg;
        break;
      case AcademicStatus.creditShortage:
        statusColor = AppColors.warningDark;
        statusBgColor = AppColors.warningBg;
        break;
      case AcademicStatus.detained:
        statusColor = AppColors.errorDark;
        statusBgColor = AppColors.errorBg;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACADEMIC STATUS',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.primaryButton,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: statusBgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: statusColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.student.academicStatusText,
                style: AppTextStyles.bodyTextBold.copyWith(
                  color: statusColor,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOperationalStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OPERATIONAL STATUS',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.primaryButton,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildStatusRow(
                'Hall Ticket Status',
                widget.student.hallTicketStatusText,
                widget.student.hallTicketStatus == HallTicketStatus.uploaded,
              ),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildStatusRow(
                'Seat Allocation Status',
                widget.student.seatAllocationStatusText,
                widget.student.seatAllocationStatus ==
                    SeatAllocationStatus.assigned,
              ),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildStatusRow(
                'Eligibility Status',
                widget.student.eligibilityStatusText,
                widget.student.eligibilityStatus == EligibilityStatus.eligible,
              ),
              if (widget.student.isBlocked && widget.student.blockReason != null)
                ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.errorDark.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 20,
                          color: AppColors.errorDark,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.student.blockReason!,
                            style: AppTextStyles.bodyTextMedium.copyWith(
                              color: AppColors.errorDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVITY SUMMARY',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.primaryButton,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                'Club Participation',
                widget.student.clubParticipation ? 'Yes' : 'No',
              ),
              Divider(color: AppColors.dividerLight, height: 20),
              _buildInfoRow(
                'Events Registered',
                widget.student.eventsRegistered.toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.secondaryText,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: isLarge
                  ? AppTextStyles.bodyTextBold.copyWith(
                      fontSize: 16,
                      color: AppColors.primaryText,
                      decoration: TextDecoration.none,
                    )
                  : AppTextStyles.bodyTextMedium.copyWith(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, bool isPositive) {
    final color = isPositive ? AppColors.successDark : AppColors.errorDark;
    final bgColor = isPositive ? AppColors.successBg : AppColors.errorBg;
    final icon = isPositive ? Icons.check_circle : Icons.cancel;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.secondaryText,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    value,
                    style: AppTextStyles.bodyTextMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
