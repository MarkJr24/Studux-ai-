import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Faculty Attendance Screen - Completely Restructured UI
/// Follows strict one-time submission workflow
/// NO DUPLICATION - Single QR entry point only
class ClassAttendanceScreen extends StatefulWidget {
  const ClassAttendanceScreen({super.key});

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  bool _isSubmitted = false;
  int _scannedCount = 0;
  final int _manuallyMarkedCount = 0;
  
  // Class details (would come from navigation params in real app)
  final String _className = 'Data Structures – CSE 3A';
  final String _classCode = 'CS301';
  final String _dateStr = 'Monday, December 15, 2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _isSubmitted ? _buildSubmittedState() : _buildMainContent(),
    );
  }

  // ==================== SECTION 1: APP BAR ====================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mark Attendance',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Scan QR or enter manually',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MAIN CONTENT ====================
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class info banner
          _buildClassInfoBanner(),
          const SizedBox(height: 24),
          
          // SECTION 2: PRIMARY QR SCANNER (ONLY ONE)
          _buildQRScannerSection(),
          const SizedBox(height: 24),
          
          // OR Divider
          _buildOrDivider(),
          const SizedBox(height: 24),
          
          // SECTION 3: ATTENDANCE METHOD (MANUAL ONLY - NO QR)
          _buildAttendanceMethodSection(),
          const SizedBox(height: 32),
          
          // SECTION 4: SUBMISSION ACTIONS
          _buildSubmissionSection(),
          const SizedBox(height: 32),
          
          // SECTION 5: ADDITIONAL DETAILS (OPTIONAL)
          _buildAdditionalSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  // Class info banner
  Widget _buildClassInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.school,
              color: Color(0xFF2196F3),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _className,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_classCode • $_dateStr',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          if (_scannedCount > 0 || _manuallyMarkedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_scannedCount + _manuallyMarkedCount} marked',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF43A047),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== SECTION 2: PRIMARY QR SCANNER ====================
  // THIS IS THE ONLY QR SCANNER ON THE ENTIRE SCREEN
  Widget _buildQRScannerSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Soft blue
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Icon - centered, prominent
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 16),
          
          // Title
          Text(
            'Scan Student QR Code',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Position the QR code within the frame',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // PRIMARY ACTION BUTTON - Open Scanner
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openQRScanner(),
              icon: const Icon(Icons.qr_code_scanner, size: 20),
              label: Text(
                'Open Scanner',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3), // Soft blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          
          // Scan counter (if any scans done)
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
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFF43A047),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_scannedCount student${_scannedCount > 1 ? 's' : ''} scanned',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43A047),
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
        const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9E9E9E),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
      ],
    );
  }

  // ==================== SECTION 3: ATTENDANCE METHOD ====================
  // MANUAL ENTRY ONLY - NO QR SCANNER HERE
  Widget _buildAttendanceMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ATTENDANCE METHOD',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF9E9E9E),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        // Manual Attendance Entry - ONLY option
        _buildMethodCard(
          icon: Icons.edit,
          iconColor: const Color(0xFFFFA726),
          iconBackground: const Color(0xFFFFF3E0),
          title: 'Manual Attendance Entry',
          subtitle: 'Mark attendance student-wise',
          onTap: () => _openManualEntry(),
        ),
      ],
    );
  }
  
  Widget _buildMethodCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackground,
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
                      color: const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            
            // Right arrow
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFBDBDBD),
            ),
          ],
        ),
      ),
    );
  }
  
  // ==================== SECTION 4: SUBMISSION ACTIONS ====================
  // FINAL ACTION BUTTONS - Not navigation
  Widget _buildSubmissionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUBMISSION',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF9E9E9E),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        // Button 1: Submit Attendance (Primary - Green)
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
              backgroundColor: const Color(0xFF43A047), // Green
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFF5F5F5),
              disabledForegroundColor: const Color(0xFF9E9E9E),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: _canSubmit() ? 2 : 0,
            ),
          ),
        ),
        
        // Button 2: Submit as Batch (Only if multiple QR scans)
        if (_scannedCount > 1) ...[
          const SizedBox(height: 12),
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
                foregroundColor: const Color(0xFF43A047),
                side: const BorderSide(
                  color: Color(0xFF43A047),
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
                color: const Color(0xFF757575),
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  // ==================== SECTION 5: ADDITIONAL DETAILS ====================
  // OPTIONAL features - visually secondary
  Widget _buildAdditionalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADDITIONAL',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF9E9E9E),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        // Booklet Number Entry
        _buildAdditionalCard(
          icon: Icons.numbers,
          title: 'Booklet Number Entry',
          subtitle: 'For exam / audit reference',
          onTap: () => _openBookletEntry(),
        ),
        const SizedBox(height: 12),
        
        // Upload Signature
        _buildAdditionalCard(
          icon: Icons.upload_file,
          title: 'Upload Signature Image',
          subtitle: 'Optional verification',
          onTap: () => _uploadSignature(),
        ),
      ],
    );
  }
  
  Widget _buildAdditionalCard({
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
          color: const Color(0xFFF8F9FA), // Lighter background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            // Icon (smaller, neutral)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF616161),
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
                      color: const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow (subtle)
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF9E9E9E),
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
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: Color(0xFF43A047),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Attendance Submitted',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Attendance has been successfully recorded and locked. No further changes can be made.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF757575),
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
                foregroundColor: const Color(0xFF2196F3),
                side: const BorderSide(
                  color: Color(0xFF2196F3),
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
  
  void _openQRScanner() {
    // Navigate to QR scanner (to be implemented)
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
        backgroundColor: const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _openManualEntry() {
    // Navigate to manual attendance entry screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening manual attendance entry...',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: const Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _submitAttendance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Submit Attendance?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Once submitted, attendance cannot be modified. Are you sure?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF757575),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSubmitted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
            ),
            child: Text('Submit', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
  
  void _submitAsBatch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Submit Batch Attendance?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Submit all $_scannedCount scanned students together? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF757575),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSubmitted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
            ),
            child: Text('Submit', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
  
  void _openBookletEntry() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening booklet number entry...',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: const Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _uploadSignature() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening signature upload...',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: const Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

