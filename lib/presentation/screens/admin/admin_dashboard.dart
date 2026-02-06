import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seating_management_screen.dart';
import 'exam_invigilator_screen.dart';
import 'attendance_audit_screen.dart';
import 'event_approval_screen.dart';
import 'notifications_management_screen.dart';
import 'admin_profile_screen.dart';
import 'student_management_screen.dart';
import 'admin_design_system.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  // Mock data - Replace with actual data from backend
  final int _upcomingExams = 5;
  final int _pendingSeating = 2;
  final int _pendingAudits = 1;
  final int _pendingEvents = 3;

  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            // Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.pageHorizontal,
                  right: 16, // Fixed right padding
                  top: 16,
                  bottom: AppSpacing.bottomNavClearance,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // System Status Overview
                    _StaggeredFadeIn(
                      delay: 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('SYSTEM STATUS OVERVIEW'),
                          const SizedBox(height: 12),
                          _buildSystemStatusOverview(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Action Required
                    _StaggeredFadeIn(
                      delay: 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('ACTION REQUIRED'),
                          const SizedBox(height: 12),
                          _buildActionRequiredSection(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Quick Actions
                    _StaggeredFadeIn(
                      delay: 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('QUICK ACTIONS'),
                          const SizedBox(height: 12),
                          _buildQuickActionsSection(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Manage Modules
                    _StaggeredFadeIn(
                      delay: 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('MANAGE MODULES'),
                          const SizedBox(height: 12),
                          _buildDashboardGrid(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Recent Activity
                    _StaggeredFadeIn(
                      delay: 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('RECENT ACTIVITY'),
                          const SizedBox(height: 12),
                          _buildRecentActivitySection(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionVertical),

                    // Notifications
                    _StaggeredFadeIn(
                      delay: 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('NOTIFICATIONS'),
                          const SizedBox(height: 12),
                          _buildNotificationPreviewSection(context),
                        ],
                      ),
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
    return _StaggeredFadeIn(
      delay: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.headerHorizontal,
          vertical: AppSpacing.headerVertical,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            bottom: BorderSide(
              color: AppColors.divider,
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
                color: AppColors.backButtonBg,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 20),
                color: AppColors.primaryText,
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
                    'Admin Dashboard',
                    style: AppTextStyles.pageTitle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Welcome, Admin',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ),

            // Profile Icon with Pink-to-Purple Gradient
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminProfileScreen(),
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF5894), // Top: Pink
                      Color(0xFF8441A4), // Bottom: Purple
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle,
    );
  }

  Widget _buildSystemStatusOverview(BuildContext context) {
    return Column(
      children: [
        // First row: 2 cards
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: 'Upcoming Exams',
                count: _upcomingExams.toString(),
                icon: Icons.event,
                backgroundColor: AppColors.upcomingExamsBg,
                accentColor: AppColors.upcomingExamsAccent,
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _StatusCard(
                title: 'Pending Seating',
                count: _pendingSeating.toString(),
                icon: Icons.event_seat,
                backgroundColor: AppColors.pendingSeatingBg,
                accentColor: AppColors.pendingSeatingAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardSpacing),

        // Second row: 2 cards
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: 'Pending Audits',
                count: _pendingAudits.toString(),
                icon: Icons.fact_check,
                backgroundColor: AppColors.pendingAuditsBg,
                accentColor: AppColors.pendingAuditsAccent,
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _StatusCard(
                title: 'Pending Events',
                count: _pendingEvents.toString(),
                icon: Icons.approval,
                backgroundColor: AppColors.pendingEventsBg,
                accentColor: AppColors.pendingEventsAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRequiredSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActionRequiredTile(
          title: 'Seating not published',
          subtitle: 'Publish seating arrangements for upcoming exams',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SeatingManagementScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _ActionRequiredTile(
          title: 'Audit pending',
          subtitle: 'Review and complete attendance audit',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttendanceAuditScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _ActionRequiredTile(
          title: 'Event approval pending',
          subtitle: '$_pendingEvents events waiting for approval',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventApprovalScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Create Exam',
                icon: Icons.add_circle_outline,
                baseColor: Colors.blue, // Premium Blue Gradient
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamInvigilatorScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _QuickActionButton(
                label: 'Generate Seating',
                icon: Icons.event_seat,
                baseColor: Colors.green, // Premium Green Gradient
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SeatingManagementScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardSpacing),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Generate Audit',
                icon: Icons.fact_check,
                baseColor: Colors.purple, // Premium Purple Gradient
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceAuditScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: _QuickActionButton(
                label: 'Review Events',
                icon: Icons.approval,
                baseColor: Colors.orange, // Premium Orange Gradient
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventApprovalScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardSpacing),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Student Management',
                icon: Icons.people_outline,
                baseColor: Colors.teal, // Premium Teal Gradient
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.cardSpacing),
            Expanded(
              child: Container(), // Empty space for alignment
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final tiles = [
      _DashboardTile(
        title: 'Seating Management',
        icon: Icons.event_seat_outlined, // More minimal outlined icon
        backgroundColor: AppColors.pendingSeatingBg, // Light Blue
        accentColor: const Color(0xFF1565C0), // Darker blue for better contrast
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SeatingManagementScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Exam & Invigilator',
        icon: Icons.assignment_outlined, // More minimal outlined icon
        backgroundColor: AppColors.upcomingExamsBg, // Light Green
        accentColor:
            const Color(0xFF2E7D32), // Darker green for better contrast
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExamInvigilatorScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Attendance & Audit',
        icon: Icons.fact_check_outlined, // More minimal outlined icon
        backgroundColor: AppColors.pendingAuditsBg, // Light Orange
        accentColor:
            const Color(0xFFE65100), // Darker orange for better contrast
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceAuditScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Event Approval',
        icon: Icons.approval_outlined, // More minimal outlined icon
        backgroundColor: AppColors.pendingEventsBg, // Light Pink
        accentColor:
            const Color(0xFF6A1B9A), // Darker purple for better contrast
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventApprovalScreen(),
            ),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) => tiles[index],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    final activities = [
      _ActivityItem(
        title: 'Seating published',
        timestamp: '2 hours ago',
        icon: Icons.event_seat,
        accentColor: AppColors.pendingSeatingAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SeatingManagementScreen(),
            ),
          );
        },
      ),
      _ActivityItem(
        title: 'Audit generated',
        timestamp: '5 hours ago',
        icon: Icons.fact_check,
        accentColor: AppColors.pendingAuditsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceAuditScreen(),
            ),
          );
        },
      ),
      _ActivityItem(
        title: 'Event approved',
        timestamp: '1 day ago',
        icon: Icons.approval,
        accentColor: AppColors.pendingEventsAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventApprovalScreen(),
            ),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          activities.length,
          (index) => Padding(
            padding:
                EdgeInsets.only(bottom: index < activities.length - 1 ? 8 : 0),
            child: _RecentActivityTile(
              activity: activities[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationPreviewSection(BuildContext context) {
    const unreadCount = 3;

    return _NotificationPreview(
      unreadCount: unreadCount,
      onViewAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationsManagementScreen(),
          ),
        );
      },
    );
  }
}

// Staggered Fade In Widget
class _StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final double delay;

  const _StaggeredFadeIn({required this.child, required this.delay});

  @override
  State<_StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<_StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

// Status Card Widget with Animated Border
// Status Card Widget with Animated Border
class _StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientCard(
      gradientColor: accentColor,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.95),
              backgroundColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                size: 28,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 12),

            // Count text
            Text(
              count,
              style: AppTextStyles.cardNumber.copyWith(color: accentColor),
            ),
            const SizedBox(height: 4),

            // Label
            Text(
              title,
              style: AppTextStyles.cardLabel.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Action Required Tile Widget with Pulse Animation
class _ActionRequiredTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionRequiredTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ActionRequiredTile> createState() => _ActionRequiredTileState();
}

class _ActionRequiredTileState extends State<_ActionRequiredTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.actionCard(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pulsing red dot indicator
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.actionRequiredDot,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.actionRequiredDot.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.actionRequiredTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: AppTextStyles.bodyText,
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.arrowIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Quick Action Button with Gradient Effects
class _QuickActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color baseColor; // Base color for gradient
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.baseColor,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Simple tap animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Get accent color for icon
  Color _getAccentColor() {
    final hsl = HSLColor.fromColor(widget.baseColor);
    return hsl.withLightness(0.45).withSaturation(0.7).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: (_) => _animController.forward(),
          onTapUp: (_) {
            _animController.reverse();
            widget.onTap();
          },
          onTapCancel: () => _animController.reverse(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 120,
            decoration: BoxDecoration(
              color: widget.baseColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: _isHovered
                    ? widget.baseColor.withOpacity(0.3)
                    : widget.baseColor.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: accentColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                      height: 1.2,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard Tile Widget with Simplified Animations and Gradient
class _DashboardTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<_DashboardTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _tapController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Simple tap animation only
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapController.forward().then((_) => _tapController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: _isHovered
                    ? widget.accentColor.withOpacity(0.3)
                    : AppColors.divider,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with gradient background
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          size: 28,
                          color: widget.accentColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
}

// Activity Item Data Class
class _ActivityItem {
  final String title;
  final String timestamp;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActivityItem({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });
}

// Recent Activity Tile Widget
class _RecentActivityTile extends StatelessWidget {
  final _ActivityItem activity;

  const _RecentActivityTile({
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.whiteCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: activity.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: activity.accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activity.icon,
                    size: 20,
                    color: activity.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    activity.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                Text(
                  activity.timestamp,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.arrowIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Notification Preview Widget
class _NotificationPreview extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onViewAll;

  const _NotificationPreview({
    required this.unreadCount,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.whiteCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewAll,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.createExamBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    size: 24,
                    color: AppColors.createExamAccent,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Notifications',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),

                // Unread count badge
                if (unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.actionRequiredDot,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                const SizedBox(width: 12),

                // View All arrow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.createExamAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.createExamAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
