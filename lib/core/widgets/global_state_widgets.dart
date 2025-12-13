import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global state widgets with glassmorphic futuristic neon styling
/// for empty, warning, error, and success states across all admin modules

class GlobalStateWidgets {
  // ═══════════════════════════════════════════════════════
  // EMPTY STATES
  // ═══════════════════════════════════════════════════════

  /// 1. No Exams Created
  static Widget noExamsCreated(BuildContext context, VoidCallback onCreateExam) {
    return _buildEmptyState(
      icon: '📝',
      title: 'No exams found',
      subtitle: 'You need to create an exam to continue.',
      buttonLabel: 'Go to Create Exam',
      onButtonTap: onCreateExam,
      glowColor: const Color(0xFF9333EA),
    );
  }

  /// 2. No Pending Seating
  static Widget noPendingSeating() {
    return _buildEmptyState(
      icon: '✅',
      title: 'No pending seating allocations',
      subtitle: 'All exams are up to date.',
      glowColor: const Color(0xFF00D9FF),
    );
  }

  /// 3. No Pending Audits
  static Widget noPendingAudits() {
    return _buildEmptyState(
      icon: '✅',
      title: 'No audits pending',
      subtitle: 'Attendance records are verified.',
      glowColor: const Color(0xFFFF6B00),
    );
  }

  /// 4. No Alerts
  static Widget noAlerts() {
    return _buildEmptyState(
      icon: '🎉',
      title: 'No new alerts',
      subtitle: 'You\'re all caught up.',
      glowColor: const Color(0xFF00D9FF),
    );
  }

  /// 5. No Pending Events
  static Widget noPendingEvents() {
    return _buildEmptyState(
      icon: '🎉',
      title: 'No pending event requests',
      subtitle: 'All events are up to date.',
      glowColor: const Color(0xFFFF6B00),
    );
  }

  // ═══════════════════════════════════════════════════════
  // BLOCKING ERROR STATES
  // ═══════════════════════════════════════════════════════

  /// 6. Audit Blocked - Attendance Not Available
  static Widget auditBlockedNoAttendance(BuildContext context, VoidCallback onViewAttendance) {
    return _buildErrorState(
      icon: '🚫',
      title: 'Audit cannot be generated',
      subtitle: 'Attendance data is not available.',
      buttonLabel: 'View Attendance Status',
      onButtonTap: onViewAttendance,
    );
  }

  /// 7. Seating Capacity Error
  static Widget seatingCapacityError(BuildContext context, VoidCallback onModifyHalls) {
    return _buildErrorState(
      icon: '⚠️',
      title: 'Selected halls do not have enough capacity',
      subtitle: 'Please modify your hall selection.',
      buttonLabel: 'Modify Hall Selection',
      onButtonTap: onModifyHalls,
    );
  }

  /// 8. Unsaved Changes Warning
  static Future<bool?> showUnsavedChangesDialog(
    BuildContext context, {
    required VoidCallback onSave,
    required VoidCallback onDiscard,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFFFFB800).withOpacity(0.4),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('⚠️', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Unsaved Changes',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'You have unsaved changes.',
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onDiscard();
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3366),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Discard',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onSave();
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF87),
              foregroundColor: const Color(0xFF0A0E27),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// 9. Session Expired
  static Widget sessionExpired(BuildContext context, VoidCallback onLoginAgain) {
    return _buildErrorState(
      icon: '🔒',
      title: 'Your session has expired',
      subtitle: 'Please log in again.',
      buttonLabel: 'Login Again',
      onButtonTap: onLoginAgain,
    );
  }

  // ═══════════════════════════════════════════════════════
  // NON-BLOCKING WARNINGS
  // ═══════════════════════════════════════════════════════

  static Widget warningBanner(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFB800).withOpacity(0.15),
            const Color(0xFFFFB800).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFB800).withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB800).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Color(0xFFFFB800), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warning',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFB800),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // SUCCESS STATES
  // ═══════════════════════════════════════════════════════

  static void showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00FF87), Color(0xFF00D9FF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF87).withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color(0xFF00FF87).withOpacity(0.3),
            width: 1,
          ),
        ),
        duration: const Duration(milliseconds: 2000),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // PRIVATE HELPER METHODS
  // ═══════════════════════════════════════════════════════

  static Widget _buildEmptyState({
    required String icon,
    required String title,
    required String subtitle,
    String? buttonLabel,
    VoidCallback? onButtonTap,
    Color glowColor = const Color(0xFF00D9FF),
  }) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: glowColor.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              if (buttonLabel != null && onButtonTap != null) ...[
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onButtonTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [glowColor, glowColor.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildErrorState({
    required String icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onButtonTap,
  }) {
    const errorColor = Color(0xFFFF3366);
    
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: errorColor.withOpacity(0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: errorColor.withOpacity(0.25),
                blurRadius: 25,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: errorColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onButtonTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [errorColor, Color(0xFFFF6B9D)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: errorColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    buttonLabel,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
