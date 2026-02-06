import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Admin Dashboard Design System
/// Clean white background design with soft accent colors

class AppColors {
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

  static const Color pendingBg = Color(0xFFFFF8E1);
  static const Color pendingColor = Color(0xFFFFCA28); // Brighter yellow
  static const Color pendingDark = Color(0xFFFFA726); // Brighter dark yellow
  static const Color pendingIcon = Color(0xFFFFA726); // Brighter icon

  // Page-Specific Accent Colors (Brightened)
  static const Color examAccent =
      Color(0xFFEF5350); // Brighter red for Exam page
  static const Color auditAccent =
      Color(0xFFFFA726); // Brighter orange for Audit page
  static const Color eventAccent =
      Color(0xFFFF7043); // Brighter orange-red for Events page
  static const Color alertsAccent =
      Color(0xFF2196F3); // Brighter blue for Alerts page
  static const Color settingsAccent =
      Color(0xFF757575); // Lighter gray for Settings page

  // Status Card Accent Colors (Dashboard) - Brightened
  static const Color upcomingExamsBg = Color(0xFFE8F5E9);
  static const Color upcomingExamsAccent = Color(0xFF43A047); // Brighter green

  static const Color pendingSeatingBg = Color(0xFFE3F2FD);
  static const Color pendingSeatingAccent = Color(0xFF1E88E5); // Brighter blue

  static const Color pendingAuditsBg = Color(0xFFFFF3E0);
  static const Color pendingAuditsAccent = Color(0xFFEF6C00); // Brighter orange

  static const Color pendingEventsBg = Color(0xFFFCE4EC);
  static const Color pendingEventsAccent = Color(0xFFD81B60); // Brighter pink

  // Action Required Colors (Purple for less alarm, more informational)
  static const Color actionRequiredBg = Color(0xFFF3E5F5);
  static const Color actionRequiredText = Color(0xFF7B1FA2); // Purple
  static const Color actionRequiredBorder = Color(0xFF9C27B0); // Purple
  static const Color actionRequiredDot = Color(0xFF9C27B0); // Purple

  // Quick Action Colors (Brightened)
  static const Color createExamBg = Color(0xFFE3F2FD);
  static const Color createExamAccent = Color(0xFF1E88E5); // Brighter blue

  static const Color generateSeatingBg = Color(0xFFF3E5F5);
  static const Color generateSeatingAccent =
      Color(0xFF9C27B0); // Brighter purple

  static const Color generateAuditBg = Color(0xFFFFF3E0);
  static const Color generateAuditAccent = Color(0xFFEF6C00); // Brighter orange

  static const Color reviewEventsBg = Color(0xFFFCE4EC);
  static const Color reviewEventsAccent = Color(0xFFD81B60); // Brighter pink

  // Button Colors (Brightened)
  static const Color primaryButton = Color(0xFF2196F3); // Brighter blue
  static const Color secondaryButton = Color(0xFF757575);
  static const Color dangerButton = Color(0xFFE53935); // Brighter red
  static const Color successButton = Color(0xFF43A047); // Brighter green
  static const Color secondaryButtonBg = Color(0xFFF5F5F5);

  // Bottom Navigation
  static const Color bottomNavActive = Color(0xFF1976D2);
  static const Color bottomNavInactive = Color(0xFF9E9E9E);
  static const Color bottomNavInactiveLabel = Color(0xFF757575);

  // Profile Icon
  static const Color profileBg = Color(0xFFE3F2FD);
  static const Color profileIcon = Color(0xFF1565C0);

  // Back Button
  static const Color backButtonBg = Color(0xFFF5F5F5);

  // Tab Navigation
  static const Color tabActiveBg = Color(0xFFFFFFFF);
  static const Color tabInactiveBg = Colors.transparent;
  static const Color tabContainerBg = Color(0xFFF5F5F5);

  // Badge Colors
  static const Color badgeRed = Color(0xFFF44336);
  static const Color badgeOrange = Color(0xFFF57C00);
  static const Color badgeBlue = Color(0xFF1976D2);
  static const Color badgeGreen = Color(0xFF4CAF50);

  // Alert Card Border Colors (Left Border)
  static const Color alertCriticalBorder = Color(0xFFD32F2F);
  static const Color alertWarningBorder = Color(0xFFF57C00);
  static const Color alertInfoBorder = Color(0xFF1976D2);
  static const Color alertSuccessBorder = Color(0xFF388E3C);

  // Alert Card Icon Backgrounds
  static const Color alertCriticalIconBg = Color(0xFFFFCDD2);
  static const Color alertWarningIconBg = Color(0xFFFFE082);
  static const Color alertInfoIconBg = Color(0xFF90CAF9);
  static const Color alertSuccessIconBg = Color(0xFFA5D6A7);

  // Settings Section Colors
  static const Color examConfigBg = Color(0xFFE3F2FD);
  static const Color examConfigBorder = Color(0xFFBBDEFB);
  static const Color examConfigText = Color(0xFF1565C0);

  static const Color seatingRulesBg = Color(0xFFE0F2F1);
  static const Color seatingRulesBorder = Color(0xFFB2DFDB);
  static const Color seatingRulesText = Color(0xFF00695C);

  static const Color eventRulesBg = Color(0xFFFFF3E0);
  static const Color eventRulesBorder = Color(0xFFFFE0B2);
  static const Color eventRulesText = Color(0xFFE65100);

  static const Color notificationSettingsBg = Color(0xFFE8EAF6);
  static const Color notificationSettingsBorder = Color(0xFFC5CAE9);
  static const Color notificationSettingsText = Color(0xFF3949AB);

  // Toggle Switch Colors
  static const Color toggleActive = Color(0xFF4CAF50);
  static const Color toggleInactive = Color(0xFFBDBDBD);
  static const Color toggleTrack = Color(0xFFE0E0E0);

  // Hover/Interaction
  static const Color hoverBg = Color(0xFFFAFAFA);
}

class AppTextStyles {
  // Page Title
  static TextStyle pageTitle = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    decoration: TextDecoration.none,
  );

  // Page Title with Custom Color
  static TextStyle pageTitleColored(Color color) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Section Title (uppercase)
  static TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.labelText,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
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
    color: AppColors.primaryText,
    decoration: TextDecoration.none,
  );

  // Card Number
  static TextStyle cardNumber = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  // Card Label
  static TextStyle cardLabel = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF616161),
  );

  // Body Text
  static TextStyle bodyText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    decoration: TextDecoration.none,
  );

  // Body Text Medium
  static TextStyle bodyTextMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
    decoration: TextDecoration.none,
  );

  // Caption
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  // Subtitle
  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  // Action Required Title
  static TextStyle actionRequiredTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.actionRequiredText,
  );

  // Quick Action Label
  static TextStyle quickActionLabel = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
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
    color: AppColors.iconGray,
  );

  // Label Text
  static TextStyle labelText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  // Small Caption
  static TextStyle smallCaption = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.labelText,
  );

  // Badge Text
  static TextStyle badgeText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Tab Text Active
  static TextStyle tabTextActive = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryButton,
  );

  // Tab Text Inactive
  static TextStyle tabTextInactive = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  // Header (for page headers)
  static TextStyle header = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  // Label (for form labels)
  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.captionText,
    decoration: TextDecoration.none,
  );

  // Body Text Bold
  static TextStyle bodyTextBold = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    decoration: TextDecoration.none,
  );

  // Caption Bold
  static TextStyle captionBold = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    decoration: TextDecoration.none,
  );

  // Table Header
  static TextStyle tableHeader = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.pendingSeatingAccent,
    decoration: TextDecoration.none,
  );

  // Button Text White
  static TextStyle buttonTextWhite = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Dialog Title
  static TextStyle dialogTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  // Text Button
  static TextStyle textButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}

class AppDecorations {
  // Status Card Decoration
  static BoxDecoration statusCard({
    required Color backgroundColor,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      border: Border.all(
        color: borderColor ?? AppColors.cardBorder,
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F000000), // 6% opacity
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  // Standard Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.cardBorder,
      width: 1,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0F000000), // 6% opacity
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  // White Card Decoration (Standard)
  static BoxDecoration whiteCard = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.cardBorder,
      width: 1,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0F000000), // 6% opacity
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  // White Card with Custom Radius
  static BoxDecoration whiteCardCustomRadius(double radius) {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: AppColors.cardBorder,
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  // Action Card with Left Border
  static BoxDecoration actionCard({
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor ?? AppColors.actionRequiredBorder,
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

  // Quick Action Card Decoration
  static BoxDecoration quickActionCard({
    required Color backgroundColor,
  }) {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.cardBorder,
        width: 1,
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

  // Alert Card Decoration
  static BoxDecoration alertCard({
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

  // Tab Container Decoration
  static BoxDecoration tabContainer = BoxDecoration(
    color: AppColors.tabContainerBg,
    borderRadius: BorderRadius.circular(12),
  );

  // Active Tab Decoration
  static BoxDecoration activeTab = BoxDecoration(
    color: AppColors.tabActiveBg,
    borderRadius: BorderRadius.circular(12),
  );

  // Badge Decoration
  static BoxDecoration badge(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    );
  }

  // Circular Badge Decoration
  static BoxDecoration circularBadge(Color color) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    );
  }

  // Input Field Decoration
  static BoxDecoration inputField = BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: AppColors.inputBorder,
      width: 1,
    ),
  );

  // Settings Section Card
  static BoxDecoration settingsSectionCard({
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
    );
  }

  // Gradient Button Decorations
  static BoxDecoration gradientButton({
    required List<Color> colors,
    double borderRadius = 12.0,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: colors[0].withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Primary Gradient Button (Blue)
  static BoxDecoration primaryGradientButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFF42A5F5), // Lighter blue
        Color(0xFF2196F3), // Primary blue
        Color(0xFF1976D2), // Darker blue
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryButton.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Success Gradient Button (Green)
  static BoxDecoration successGradientButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFF66BB6A), // Lighter green
        Color(0xFF4CAF50), // Primary green
        Color(0xFF43A047), // Darker green
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.successColor.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Danger Gradient Button (Red)
  static BoxDecoration dangerGradientButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFFEF5350), // Lighter red
        Color(0xFFE53935), // Primary red
        Color(0xFFD32F2F), // Darker red
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.errorColor.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Warning Gradient Button (Orange)
  static BoxDecoration warningGradientButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFFFFA726), // Lighter orange
        Color(0xFFFF9800), // Primary orange
        Color(0xFFEF6C00), // Darker orange
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.warningColor.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Purple Gradient Button (for Generate Seating)
  static BoxDecoration purpleGradientButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFFAB47BC), // Lighter purple
        Color(0xFF9C27B0), // Primary purple
        Color(0xFF7B1FA2), // Darker purple
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.generateSeatingAccent.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

class AppSpacing {
  // Page spacing
  static const double pageHorizontal = 20.0;
  static const double sectionVertical = 24.0;

  // Card spacing
  static const double cardPadding = 20.0;
  static const double cardRadius = 16.0;
  static const double cardSpacing = 12.0;

  // Header spacing
  static const double headerVertical = 16.0;
  static const double headerHorizontal = 20.0;

  // Bottom navigation clearance
  static const double bottomNavClearance = 80.0;
}

class AppElevations {
  static const double card = 2.0;
  static const double actionCard = 1.0;
  static const double bottomNav = 8.0;
}

// Gradient Button Widget
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final BoxDecoration decoration;
  final double? width;
  final double height;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.decoration,
    this.width,
    this.height = 50,
    this.textStyle,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: widget.decoration,
          child: Center(
            child: Text(
              widget.text,
              style: widget.textStyle ?? AppTextStyles.buttonText,
            ),
          ),
        ),
      ),
    );
  }
}

// Animated Card Widget with Premium Effects
class AnimatedGradientCard extends StatefulWidget {
  final Widget child;
  final Color gradientColor;

  const AnimatedGradientCard({
    super.key,
    required this.child,
    this.gradientColor = AppColors.primaryButton,
  });

  @override
  State<AnimatedGradientCard> createState() => _AnimatedGradientCardState();
}

class _AnimatedGradientCardState extends State<AnimatedGradientCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.gradientColor.withOpacity(0.1),
            border: Border.all(
              color: widget.gradientColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
