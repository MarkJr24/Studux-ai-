import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'manual_attendance_entry_screen.dart';
import 'submit_qr_attendance_screen.dart';
import 'batch_attendance_screen.dart';
import 'booklet_entry_screen.dart';
import 'upload_signature_screen.dart';

/// Mark Attendance Screen
/// Implements exact 4-section structure with single QR button
class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final List<String> scannedQRCodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mark Attendance',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Scan QR or enter manually',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION 1: QR SCANNER (Primary Widget)
            _buildQRScannerSection(),
            
            const SizedBox(height: 24),
            
            // OR Divider
            _buildOrDivider(),
            
            const SizedBox(height: 24),
            
            // SECTION 2: ATTENDANCE METHODS
            _buildAttendanceMethodsSection(),
            
            const SizedBox(height: 32),
            
            // SECTION 3: SUBMISSION OPTIONS
            _buildSubmissionOptionsSection(),
            
            const SizedBox(height: 32),
            
            // SECTION 4: ADDITIONAL OPTIONS
            _buildAdditionalOptionsSection(),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 1: QR SCANNER ====================
  Widget _buildQRScannerSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Camera Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 48,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Title
          const Text(
            'Scan Student QR Code',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Position QR code within frame',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // ONLY QR BUTTON - "Open Scanner"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openQRScanner,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Open Scanner',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          // Scanned count badge
          if (scannedQRCodes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${scannedQRCodes.length} codes scanned',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  // ==================== OR DIVIDER ====================
  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 1),
        ),
      ],
    );
  }

  // ==================== SECTION 2: ATTENDANCE METHODS ====================
  Widget _buildAttendanceMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'ATTENDANCE METHODS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // ONLY ONE OPTION: Manual Attendance Entry
        _buildMethodCard(
          icon: Icons.edit,
          iconColor: const Color(0xFF8B5CF6),
          backgroundColor: const Color(0xFFF3E8FF),
          title: 'Manual Attendance Entry',
          subtitle: 'Mark attendance student-wise',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManualAttendanceEntryScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==================== SECTION 3: SUBMISSION OPTIONS ====================
  Widget _buildSubmissionOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'SUBMISSION OPTIONS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Option 1: Submit QR Scanned Attendance
        _buildMethodCard(
          icon: Icons.upload,
          iconColor: const Color(0xFF10B981),
          backgroundColor: const Color(0xFFD1FAE5),
          title: 'Submit QR Scanned Attendance',
          subtitle: 'Review and submit scanned codes',
          badge: scannedQRCodes.isNotEmpty ? '${scannedQRCodes.length}' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubmitQRAttendanceScreen(
                  className: 'Sample Class',
                  classCode: 'CS101',
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Option 2: Submit as Batch
        _buildMethodCard(
          icon: Icons.inventory_2,
          iconColor: const Color(0xFF3B82F6),
          backgroundColor: const Color(0xFFDBEAFE),
          title: 'Submit as Batch',
          subtitle: 'Batch submission workflow',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BatchAttendanceScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==================== SECTION 4: ADDITIONAL OPTIONS ====================
  Widget _buildAdditionalOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'ADDITIONAL OPTIONS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Option 1: Booklet Number Entry
        _buildMethodCard(
          icon: Icons.menu_book,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFFEF3C7),
          title: 'Booklet Number Entry',
          subtitle: 'Enter answer booklet numbers',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookletEntryScreen(),
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Option 2: Upload Signature Image
        _buildMethodCard(
          icon: Icons.draw,
          iconColor: const Color(0xFFEC4899),
          backgroundColor: const Color(0xFFFCE7F3),
          title: 'Upload Signature Image',
          subtitle: 'Upload attendance signature',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadSignatureScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==================== REUSABLE METHOD CARD ====================
  Widget _buildMethodCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
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
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Badge (if provided)
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            
            // Chevron
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== QR SCANNER FUNCTIONALITY ====================
  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _QRScannerScreen(
          onCodeScanned: (String code) {
            setState(() {
              // Avoid duplicates
              if (!scannedQRCodes.contains(code)) {
                scannedQRCodes.add(code);
              }
            });
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('QR Code scanned successfully'),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==================== QR SCANNER SCREEN ====================
class _QRScannerScreen extends StatefulWidget {
  final Function(String) onCodeScanned;

  const _QRScannerScreen({required this.onCodeScanned});

  @override
  State<_QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<_QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              widget.onCodeScanned(barcode.rawValue!);
              Navigator.pop(context);
              break;
            }
          }
        },
      ),
    );
  }
}
