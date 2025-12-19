import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seating_management_screen.dart';
import 'exam_invigilator_screen.dart';
import 'attendance_audit_screen.dart';
import 'event_approval_screen.dart';
import 'notifications_management_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_design_system.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Mock data - Replace with actual data from backend
  final int _upcomingExams = 5;
  final int _pendingSeating = 2;
  final int _pendingAudits = 1;
  final int _pendingEvents = 3;

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

            // Profile Icon
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
                  color: AppColors.profileBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.profileIcon,
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
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final tiles = [
      _DashboardTile(
        title: 'Seating Management',
        icon: Icons.event_seat,
        backgroundColor: AppColors.pendingSeatingBg,
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
      _DashboardTile(
        title: 'Exam & Invigilator',
        icon: Icons.assignment,
        backgroundColor: AppColors.upcomingExamsBg,
        accentColor: AppColors.upcomingExamsAccent,
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
        icon: Icons.fact_check,
        backgroundColor: AppColors.pendingAuditsBg,
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
      _DashboardTile(
        title: 'Event Approval',
        icon: Icons.approval,
        backgroundColor: AppColors.pendingEventsBg,
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
      _DashboardTile(
        title: 'Notifications',
        icon: Icons.notifications_active,
        backgroundColor: AppColors.createExamBg,
        accentColor: AppColors.createExamAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsManagementScreen(),
            ),
          );
        },
      ),
      _DashboardTile(
        title: 'Admin Profile',
        icon: Icons.person,
        backgroundColor: Color(0xFFE3F2FD),
        accentColor: Color(0xFF1976D2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminProfileScreen(),
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
            padding: EdgeInsets.only(bottom: index < activities.length - 1 ? 8 : 0),
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

class _StaggeredFadeInState extends State<_StaggeredFadeIn> with SingleTickerProviderStateMixin {
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

    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
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
class _StatusCard extends StatefulWidget {
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
  State<_StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<_StatusCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: SweepGradient(
                  colors: [
                    widget.accentColor.withOpacity(0.3),
                    widget.accentColor,
                    widget.accentColor.withOpacity(0.5),
                    widget.accentColor.withOpacity(0.8),
                    widget.accentColor,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  transform: GradientRotation(_controller.value * 2 * 3.14159),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.backgroundColor,
                      widget.backgroundColor.withOpacity(0.95),
                      widget.backgroundColor.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Icon with premium glow
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.accentColor.withOpacity(0.2),
                            widget.backgroundColor,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.accentColor.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 28,
                        color: widget.accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Count with gradient text effect
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          widget.accentColor,
                          widget.accentColor.withOpacity(0.7),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        widget.count,
                        style: AppTextStyles.cardNumber.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Label
                    Text(
                      widget.title,
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
          },
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

class _ActionRequiredTileState extends State<_ActionRequiredTile> with SingleTickerProviderStateMixin {
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

// Premium Quick Action Button Widget
class _QuickActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color baseColor; // Base color to derive gradient
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

class _QuickActionButtonState extends State<_QuickActionButton> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getDarkerShade(Color color) {
    return Color.fromRGBO(
      (color.red * 0.7).toInt(),
      (color.green * 0.7).toInt(),
      (color.blue * 0.7).toInt(),
      1,
    );
  }

  Color _getLighterShade(Color color) {
    return Color.fromRGBO(
      (color.red + (255 - color.red) * 0.3).toInt(),
      (color.green + (255 - color.green) * 0.3).toInt(),
      (color.blue + (255 - color.blue) * 0.3).toInt(),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate rich gradient from base color
    final gradient = LinearGradient(
      colors: [
        _getLighterShade(widget.baseColor),
        widget.baseColor,
        _getDarkerShade(widget.baseColor),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
    );

    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) => _animController.reverse(),
      onTapCancel: () => _animController.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedBuilder(
          animation: Listenable.merge([_shimmerAnim, _pulseAnim]),
          builder: (context, child) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.baseColor.withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated gradient background overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(
                                  0.5 + (_pulseAnim.value - 0.9) * 2,
                                  0.5 + (_pulseAnim.value - 0.9) * 2,
                                ),
                                radius: _pulseAnim.value * 1.5,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Shimmer effect overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Transform.translate(
                        offset: Offset(_shimmerAnim.value * 200, 0),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Particle effect (decorative circles)
                  Positioned(
                    top: 10,
                    right: 15,
                    child: FadeTransition(
                      opacity: _pulseAnim,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 20,
                    child: ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with animated glow
                        AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, child) {
                            return Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3 * _pulseAnim.value),
                                    blurRadius: 8 + (4 * _pulseAnim.value),
                                    spreadRadius: 2 * _pulseAnim.value,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                size: 26,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),

                        // Label
                        Text(
                          widget.label,
                          style: AppTextStyles.quickActionLabel.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Dashboard Tile Widget with Hover Effect
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

class _DashboardTileState extends State<_DashboardTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: AppDecorations.statusCard(
            backgroundColor: widget.backgroundColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: widget.accentColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 28,
                        color: widget.accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
