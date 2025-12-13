import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import 'class_workspace_screen.dart';

class TeacherClassesScreen extends StatefulWidget {
  const TeacherClassesScreen({super.key});

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
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
                padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY CLASSES',
                      style: TeacherTextStyles.sectionTitleColored(TeacherColors.classesColor),
                    ),
                    const SizedBox(height: 16),
                    _buildClassCard(
                      context,
                      className: 'Data Structures - CSE 3A',
                      schedule: 'Mon, Wed, Fri • 10:00 AM - 11:00 AM',
                      attendanceComplete: true,
                      materialsComplete: true,
                    ),
                    const SizedBox(height: 16),
                    _buildClassCard(
                      context,
                      className: 'Operating Systems - CSE 3B',
                      schedule: 'Tue, Thu • 2:00 PM - 3:30 PM',
                      attendanceComplete: false,
                      materialsComplete: true,
                    ),
                    const SizedBox(height: 16),
                    _buildClassCard(
                      context,
                      className: 'Database Management - CSE 4A',
                      schedule: 'Mon, Wed • 11:30 AM - 1:00 PM',
                      attendanceComplete: true,
                      materialsComplete: false,
                    ),
                    const SizedBox(height: TeacherSpacing.bottomNavClearance),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
          // Back Button
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

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Classes',
                  style: TeacherTextStyles.pageTitleColored(TeacherColors.classesColor),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your classes',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context, {
    required String className,
    required String schedule,
    required bool attendanceComplete,
    required bool materialsComplete,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassWorkspaceScreen(
              className: className,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: TeacherDecorations.cardWithLeftBorder(
          borderColor: TeacherColors.classesColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              className,
              style: TeacherTextStyles.cardTitle,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: TeacherColors.secondaryText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    schedule,
                    style: TeacherTextStyles.bodyText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusIndicator(
                  'Attendance',
                  attendanceComplete,
                ),
                const SizedBox(width: 16),
                _buildStatusIndicator(
                  'Materials',
                  materialsComplete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isComplete) {
    return Row(
      children: [
        Icon(
          isComplete ? Icons.check_circle : Icons.pending,
          size: 18,
          color: isComplete ? TeacherColors.successColor : TeacherColors.warningColor,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isComplete ? TeacherColors.successColor : TeacherColors.warningColor,
          ),
        ),
      ],
    );
  }
}
