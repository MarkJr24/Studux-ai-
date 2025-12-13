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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
                child: Column(
                  children: [
                    // QR Scanner Section
                    _buildSectionTitle('QR SCANNER'),
                    const SizedBox(height: 12),
                    _buildQRScannerCard(context),
                    const SizedBox(height: 24),
                    
                    // Attendance Methods
                    _buildSectionTitle('ATTENDANCE METHODS'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Open QR Scanner',
                      Icons.qr_code_scanner,
                      TeacherColors.infoDark,
                      TeacherColors.infoBg,
                      () => debugPrint('Open QR Scanner'),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Manual Attendance Entry',
                      Icons.edit,
                      TeacherColors.classesColor,
                      TeacherColors.classesBg,
                      () => debugPrint('Manual Entry'),
                    ),
                    const SizedBox(height: 24),
                    
                    // Submission Options
                    _buildSectionTitle('SUBMISSION'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Submit QR Scanned Attendance',
                      Icons.send,
                      TeacherColors.successIcon,
                      TeacherColors.successBg,
                      () => debugPrint('Submit QR Attendance'),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Submit as Batch',
                      Icons.done_all,
                      TeacherColors.successDark,
                      TeacherColors.successBg,
                      () => debugPrint('Submit Batch'),
                    ),
                    const SizedBox(height: 24),
                    
                    // Additional Options
                    _buildSectionTitle('ADDITIONAL'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Booklet Number Entry',
                      Icons.book,
                      TeacherColors.attendanceDark,
                      TeacherColors.attendanceBg,
                      () => debugPrint('Booklet Number'),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Upload Signature Image',
                      Icons.upload_file,
                      TeacherColors.invigilationColor,
                      TeacherColors.invigilationBg,
                      () => debugPrint('Upload Signature'),
                    ),
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TeacherTextStyles.sectionTitle,
      ),
    );
  }

  Widget _buildQRScannerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: TeacherDecorations.qrScannerContainer,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: TeacherColors.infoBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 60,
              color: TeacherColors.infoDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scan Student QR Code',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: TeacherColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Position the QR code within the frame',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TeacherColors.secondaryText,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => debugPrint('Open Scanner'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: TeacherColors.primaryButton,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Open Scanner',
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
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Color accentColor,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: TeacherDecorations.whiteCard,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: TeacherColors.arrowIcon,
            ),
          ],
        ),
      ),
    );
  }
}
