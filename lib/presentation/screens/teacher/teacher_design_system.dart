import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Teacher/Faculty Design System
/// Clean white background design with professional color accents

class TeacherColors {
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color primaryText = Color(0xFF212121);
  static const Color secondaryText = Color(0xFF757575);
  static const Color labelText = Color(0xFF9E9E9E);
  static const Color disabledText = Color(0xFFBDBDBD);
  static const Color captionText = Color(0xFF616161);
  
  // Divider & Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerLight = Color(0xFFEEEEEE);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color inputBorder = Color(0xFFE0E0E0);
  
  // Button & Icon Colors
  static const Color iconGray = Color(0xFF616161);
  static const Color iconLight = Color(0xFF9E9E9E);
  static const Color arrowIcon = Color(0xFFBDBDBD);
  
  // Status Colors (Brightened & More Vibrant)
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color successColor = Color(0xFF66BB6A); // Brighter green
  static const Color successDark = Color(0xFF43A047); // Brighter dark green
  static const Color successIcon = Color(0xFF4CAF50); // Brighter icon
  
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color warningColor = Color(0xFFFFA726); // Brighter orange
  static const Color warningDark = Color(0xFFEF6C00); // Brighter dark orange
  static const Color warningIcon = Color(0xFFFF9800); // Brighter icon
  
  static const Color errorBg = Color(0xFFFFEBEE);
  static const Color errorColor = Color(0xFFEF5350); // Brighter red
  static const Color errorDark = Color(0xFFE53935); // Brighter dark red
  static const Color errorIcon = Color(0xFFEF5350); // Brighter icon
  
  static const Color infoBg = Color(0xFFE3F2FD);
  static const Color infoColor = Color(0xFF42A5F5); // Brighter blue
  static const Color infoDark = Color(0xFF1E88E5); // Brighter dark blue
  static const Color infoIcon = Color(0xFF2196F3); // Brighter icon
  
  // Teacher-Specific Feature Colors (Brightened)
  static const Color invigilationBg = Color(0xFFF3E5F5);
  static const Color invigilationColor = Color(0xFF9C27B0); // Brighter purple
  static const Color invigilationDark = Color(0xFF8E24AA); // Brighter dark purple
  static const Color invigilationBorder = Color(0xFFE1BEE7);
  
  static const Color classesBg = Color(0xFFE0F2F1);
  static const Color classesColor = Color(0xFF26A69A); // Brighter teal
  static const Color classesDark = Color(0xFF00897B); // Brighter dark teal
  static const Color classesBorder = Color(0xFFB2DFDB);
  
  static const Color attendanceBg = Color(0xFFFFF3E0);
  static const Color attendanceColor = Color(0xFFFFA726); // Brighter orange
  static const Color attendanceDark = Color(0xFFEF6C00); // Brighter dark orange
  
  // Button Colors (Brightened)
  static const Color primaryButton = Color(0xFF2196F3); // Brighter blue
  static const Color secondaryButton = Color(0xFF757575);
  static const Color dangerButton = Color(0xFFE53935); // Brighter red
  static const Color successButton = Color(0xFF43A047); // Brighter green
  static const Color secondaryButtonBg = Color(0xFFF5F5F5);
  
  // Profile Icon
  static const Color profileBg = Color(0xFFE3F2FD);
  static const Color profileIcon = Color(0xFF1976D2);
  
  // Back Button
  static const Color backButtonBg = Color(0xFFF5F5F5);
  
  // Badge Colors
  static const Color badgeRed = Color(0xFFF44336);
  static const Color badgeOrange = Color(0xFFF57C00);
  static const Color badgeBlue = Color(0xFF1976D2);
  static const Color badgeGreen = Color(0xFF4CAF50);
  static const Color badgePurple = Color(0xFF7B1FA2);
  static const Color badgeTeal = Color(0xFF00897B);
  
  // Notification Card Colors
  static const Color notifInvigilationBg = Color(0xFFF3E5F5);
  static const Color notifInvigilationBorder = Color(0xFF7B1FA2);
  static const Color notifInvigilationIconBg = Color(0xFFE1BEE7);
  
  static const Color notifAttendanceBg = Color(0xFFFFF3E0);
  static const Color notifAttendanceBorder = Color(0xFFFF6F00);
  static const Color notifAttendanceIconBg = Color(0xFFFFE082);
  
  static const Color notifClassBg = Color(0xFFE0F2F1);
  static const Color notifClassBorder = Color(0xFF00897B);
  static const Color notifClassIconBg = Color(0xFFB2DFDB);
  
  static const Color notifGeneralBg = Color(0xFFE3F2FD);
  static const Color notifGeneralBorder = Color(0xFF1976D2);
  static const Color notifGeneralIconBg = Color(0xFF90CAF9);
  
  // Toggle Switch Colors
  static const Color toggleActive = Color(0xFF4CAF50);
  static const Color toggleInactive = Color(0xFFBDBDBD);
  static const Color toggleTrack = Color(0xFFE0E0E0);
  
  // Bottom Navigation (Brightened)
  static const Color bottomNavActive = Color(0xFF2196F3); // Brighter blue
  static const Color bottomNavInactive = Color(0xFF9E9E9E);
  static const Color bottomNavInactiveLabel = Color(0xFF757575);
  
  // Hover/Interaction
  static const Color hoverBg = Color(0xFFFAFAFA);
}

class TeacherTextStyles {
  // Page Title
  static TextStyle pageTitle = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: TeacherColors.primaryText,
  );
  
  // Page Title with Custom Color
  static TextStyle pageTitleColored(Color color) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
  );
  
  // Greeting Text
  static TextStyle greeting = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: TeacherColors.primaryText,
  );
  
  // Section Title (uppercase)
  static TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: TeacherColors.labelText,
    letterSpacing: 0.5,
  );
  
  // Section Title with Custom Color
  static TextStyle sectionTitleColored(Color color) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: 0.5,
  );
  
  // Card Title
  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: TeacherColors.primaryText,
  );
  
  // Large Card Title (for today's invigilation)
  static TextStyle largeCardTitle = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: TeacherColors.primaryText,
  );
  
  // Card Number (stats)
  static TextStyle cardNumber = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: TeacherColors.primaryText,
  );
  
  // Card Label
  static TextStyle cardLabel = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: TeacherColors.secondaryText,
  );
  
  // Body Text
  static TextStyle bodyText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TeacherColors.secondaryText,
  );
  
  // Body Text Medium
  static TextStyle bodyTextMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: TeacherColors.primaryText,
  );
  
  // Caption
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TeacherColors.secondaryText,
  );
  
  // Subtitle
  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TeacherColors.secondaryText,
  );
  
  // Date Text
  static TextStyle dateText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TeacherColors.secondaryText,
  );
  
  // Button Text
  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Button Text Secondary
  static TextStyle buttonTextSecondary = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TeacherColors.iconGray,
  );
  
  // Label Text
  static TextStyle labelText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: TeacherColors.primaryText,
  );
  
  // Small Label
  static TextStyle smallLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: TeacherColors.labelText,
  );
  
  // Badge Text
  static TextStyle badgeText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Time Badge Text
  static TextStyle timeBadgeText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: TeacherColors.invigilationColor,
  );
  
  // Notification Title
  static TextStyle notificationTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TeacherColors.primaryText,
  );
  
  // Student Name
  static TextStyle studentName = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TeacherColors.primaryText,
  );
  
  // Register Number
  static TextStyle registerNumber = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TeacherColors.secondaryText,
  );
}

class TeacherDecorations {
  // Standard White Card
  static BoxDecoration whiteCard = BoxDecoration(
    color: TeacherColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: TeacherColors.cardBorder,
      width: 1,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0A000000), // 4% opacity
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // White Card with Custom Radius
  static BoxDecoration whiteCardCustomRadius(double radius) {
    return BoxDecoration(
      color: TeacherColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: TeacherColors.cardBorder,
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
  
  // Card with Left Border Accent
  static BoxDecoration cardWithLeftBorder({
    required Color borderColor,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? TeacherColors.cardBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor,
        width: 2,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
  
  // Tinted Card (for today's invigilation, etc.)
  static BoxDecoration tintedCard({
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000), // 8% opacity
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
  
  // Notification Card
  static BoxDecoration notificationCard({
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor,
        width: 2,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
    );
  }
  
  // Badge Decoration
  static BoxDecoration badge(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    );
  }
  
  // Circular Badge
  static BoxDecoration circularBadge(Color color) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    );
  }
  
  // Input Field Decoration
  static BoxDecoration inputField = BoxDecoration(
    color: TeacherColors.background,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: TeacherColors.inputBorder,
      width: 1,
    ),
  );
  
  // Search Bar Decoration
  static BoxDecoration searchBar = BoxDecoration(
    color: TeacherColors.secondaryBackground,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: TeacherColors.cardBorder,
      width: 1,
    ),
  );
  
  // QR Scanner Container
  static BoxDecoration qrScannerContainer = BoxDecoration(
    color: TeacherColors.background,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: TeacherColors.infoBg,
      width: 2,
      style: BorderStyle.solid,
    ),
  );
}

class TeacherSpacing {
  // Page spacing
  static const double pageHorizontal = 20.0;
  static const double sectionVertical = 24.0;
  
  // Card spacing
  static const double cardPadding = 20.0;
  static const double cardRadius = 16.0;
  static const double cardSpacing = 12.0;
  static const double cardMarginBottom = 16.0;
  
  // Header spacing
  static const double headerVertical = 16.0;
  static const double headerHorizontal = 20.0;
  
  // Bottom navigation clearance
  static const double bottomNavClearance = 80.0;
  
  // Icon sizes
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 48.0;
  
  // Icon container sizes
  static const double iconContainerSmall = 40.0;
  static const double iconContainerMedium = 48.0;
  static const double iconContainerLarge = 80.0;
}

class TeacherElevations {
  static const double card = 1.0;
  static const double cardElevated = 2.0;
  static const double bottomNav = 8.0;
}

