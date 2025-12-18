import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';

class AttendanceSystemScreen extends StatelessWidget {
  const AttendanceSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Content Available',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This section is currently empty',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
                  'Mark Attendance',
                  style: TeacherTextStyles.pageTitleColored(TeacherColors.infoDark),
                ),
                const SizedBox(height: 2),
                Text(
                  'Scan QR or enter manually',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
