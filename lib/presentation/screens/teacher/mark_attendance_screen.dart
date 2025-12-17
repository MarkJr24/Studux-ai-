import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import 'manual_attendance_entry_screen.dart';
import 'submit_qr_attendance_screen.dart';
import 'batch_attendance_screen.dart';
import 'booklet_entry_screen.dart';
import 'upload_signature_screen.dart';

/// Faculty Attendance Screen - QR-based and Manual Attendance
/// Follows strict one-time submission workflow
class MarkAttendanceScreen extends StatefulWidget {
  final String className;
  final String classCode;
  final DateTime date;

  const MarkAttendanceScreen({
    super.key,
    required this.className,
    required this.classCode,
    required this.date,
  });

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  bool _isSubmitted = false;
  int _scannedCount = 0;
  int _manuallyMarkedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isSubmitted
                  ? _buildSubmittedState()
                  : _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 1: HEADER ====================
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
          // Back button
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
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mark Attendance',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: TeacherColors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Scan QR or enter manually',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: TeacherColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MAIN CONTENT ====================
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class info
          _buildClassInfoCard(),
          const SizedBox(height: 24),

          // SECTION 2: QR SCANNER (PRIMARY ACTION - ONLY ONE)
          _buildQRScannerSection(),
          const SizedBox(height: 24),

          // Divider with "OR"
          _buildOrDivider(),
          const SizedBox(height: 24),

          // SECTION 3: ATTENDANCE METHODS (MANUAL ONLY)
          _buildAttendanceMethodsSection(),
          const SizedBox(height: 32),

          // SECTION 4: SUBMISSION ACTIONS
          _buildSubmissionSection(),
          const SizedBox(height: 32),

          // SECTION 5: ADDITIONAL OPTIONS (SECONDARY)
          _buildAdditionalOptionsSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Class info card
  Widget _buildClassInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TeacherColors.infoBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TeacherColors.infoDark.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.school,
              color: TeacherColors.infoDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: TeacherColors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.classCode} • ${_formatDate(widget.date)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: TeacherColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (_scannedCount > 0 || _manuallyMarkedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: TeacherColors.successBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_scannedCount + _manuallyMarkedCount} marked',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.successDark,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== SECTION 2: QR SCANNER (PRIMARY) ====================
  Widget _buildQRScannerSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TeacherColors.infoBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TeacherColors.infoDark.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TeacherColors.infoDark.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: TeacherColors.infoDark.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: TeacherColors.infoDark,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Scan Student QR Code',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: TeacherColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Position the QR code within the frame',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TeacherColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Primary Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _openQRScanner();
              },
              icon: const Icon(Icons.qr_code_scanner, size: 20),
              label: Text(
                'Open Scanner',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TeacherColors.infoDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),

          // Scan count indicator
          if (_scannedCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: TeacherColors.successDark,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_scannedCount student${_scannedCount > 1 ? 's' : ''} scanned',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.successDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // OR divider
  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: TeacherColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: TeacherColors.labelText,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Expanded(child: Divider(color: TeacherColors.divider)),
      ],
    );
  }

  // ==================== SECTION 3: ATTENDANCE METHODS ====================
  Widget _buildAttendanceMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ATTENDANCE METHODS',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TeacherColors.labelText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Manual Attendance Entry (ONLY option here - NO QR)
        _buildMethodCard(
          icon: Icons.edit,
          iconColor: TeacherColors.attendanceColor,
          backgroundColor: TeacherColors.attendanceBg,
          title: 'Manual Attendance Entry',
          subtitle: 'Mark attendance student-wise',
          onTap: () {
            _openManualEntry();
          },
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: TeacherDecorations.whiteCard,
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: TeacherColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow indicator
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: TeacherColors.arrowIcon,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 4: SUBMISSION ====================
  Widget _buildSubmissionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUBMISSION',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TeacherColors.labelText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Submit Attendance (Primary)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _canSubmit() ? () => _submitAttendance() : null,
            icon: const Icon(Icons.check_circle, size: 20),
            label: Text(
              'Submit Attendance',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherColors.successDark,
              foregroundColor: Colors.white,
              disabledBackgroundColor: TeacherColors.secondaryBackground,
              disabledForegroundColor: TeacherColors.labelText,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: _canSubmit() ? 2 : 0,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Submit as Batch (Only if multiple scans pending)
        if (_scannedCount > 1) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _submitAsBatch(),
              icon: const Icon(Icons.groups, size: 20),
              label: Text(
                'Submit as Batch',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: TeacherColors.successDark,
                side: BorderSide(
                  color: TeacherColors.successDark,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Submit $_scannedCount scanned students together',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: TeacherColors.secondaryText,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== SECTION 5: ADDITIONAL OPTIONS ====================
  Widget _buildAdditionalOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADDITIONAL (OPTIONAL)',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TeacherColors.labelText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Booklet Number Entry (Secondary)
        _buildSecondaryCard(
          icon: Icons.numbers,
          title: 'Booklet Number Entry',
          subtitle: 'Enter answer booklet numbers',
          onTap: () {
            _openBookletEntry();
          },
        ),
        const SizedBox(height: 12),

        // Upload Signature (Secondary)
        _buildSecondaryCard(
          icon: Icons.upload_file,
          title: 'Upload Signature Image',
          subtitle: 'Upload attendance signature',
          onTap: () {
            _uploadSignature();
          },
        ),
      ],
    );
  }

  Widget _buildSecondaryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TeacherColors.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TeacherColors.divider,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon (smaller, lighter)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: TeacherColors.iconGray,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: TeacherColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: TeacherColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow indicator (subtle)
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: TeacherColors.iconLight,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SUBMITTED STATE ====================
  Widget _buildSubmittedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: TeacherColors.successBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: TeacherColors.successDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Attendance Submitted',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: TeacherColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Attendance has been successfully recorded and locked. No further changes can be made.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TeacherColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(
                'Back to Classes',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: TeacherColors.infoDark,
                side: BorderSide(
                  color: TeacherColors.infoDark,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== HELPER METHODS ====================

  bool _canSubmit() {
    return (_scannedCount > 0 || _manuallyMarkedCount > 0) && !_isSubmitted;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _openQRScanner() {
    // Navigate to QR scanner screen (to be implemented)
    // For now, simulate scanning
    setState(() {
      _scannedCount += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'QR Code scanned successfully',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: TeacherColors.successDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openManualEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualAttendanceEntryScreen(
          className: widget.className,
          classCode: widget.classCode,
        ),
      ),
    );
  }

  void _submitAttendance() {
    // Navigate to Submit QR Scanned Attendance screen for review
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitQRAttendanceScreen(
          className: widget.className,
          classCode: widget.classCode,
        ),
      ),
    );
  }

  void _submitAsBatch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BatchAttendanceScreen(),
      ),
    );
  }

  void _openBookletEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookletEntryScreen(),
      ),
    );
  }

  void _uploadSignature() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadSignatureScreen(),
      ),
    );
  }
}

