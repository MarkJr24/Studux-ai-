import 'package:flutter/material.dart';
import '../../../core/navigation_service.dart';
import 'admin_dashboard.dart';
import 'exam_invigilator_screen.dart';
import 'attendance_audit_screen.dart';
import 'notifications_management_screen.dart';
import 'event_approval_screen.dart';

/// Admin Main Navigation Wrapper
/// Prevents back navigation to login and keeps bottom nav visible
class AdminMainNavigation extends StatefulWidget {
  const AdminMainNavigation({super.key});

  @override
  State<AdminMainNavigation> createState() => _AdminMainNavigationState();
}

class _AdminMainNavigationState extends State<AdminMainNavigation> {
  int _currentIndex = 0;

  // Core pages displayed in bottom navigation
  final List<Widget> _pages = [
    const AdminDashboard(), // Index 0: Home
    const ExamInvigilatorScreen(), // Index 1: Exams
    const AttendanceAuditScreen(), // Index 2: Audit
    const EventApprovalScreen(), // Index 3: Events
    const NotificationsManagementScreen(), // Index 4: Alerts
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => LogoutHandler.handleBackToLogin(context),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AnimatedNavItem(
            icon: Icons.home,
            label: 'Home',
            isSelected: _currentIndex == 0,
            onTap: () => setState(() => _currentIndex = 0),
          ),
          _AnimatedNavItem(
            icon: Icons.assignment,
            label: 'Exams',
            isSelected: _currentIndex == 1,
            onTap: () => setState(() => _currentIndex = 1),
          ),
          _AnimatedNavItem(
            icon: Icons.checklist,
            label: 'Audit',
            isSelected: _currentIndex == 2,
            onTap: () => setState(() => _currentIndex = 2),
          ),
          _AnimatedNavItem(
            icon: Icons.event,
            label: 'Events',
            isSelected: _currentIndex == 3,
            onTap: () => setState(() => _currentIndex = 3),
          ),
          _AnimatedNavItem(
            icon: Icons.notifications,
            label: 'Alerts',
            isSelected: _currentIndex == 4,
            onTap: () => setState(() => _currentIndex = 4),
          ),
        ],
      ),
    );
  }
}

// Custom Animated Navigation Item Widget
class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _scaleController;
  late Animation<double> _bounceAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Bounce animation
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut));

    // Scale animation for selected state
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _scaleController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = const Color(0xFF2196F3);
    final unselectedColor = const Color(0xFF757575);

    return Expanded(
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animations
              ScaleTransition(
                scale: _bounceAnim,
                child: AnimatedBuilder(
                  animation: _scaleAnim,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnim.value,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          size: 26,
                          color: widget.isSelected
                              ? selectedColor
                              : unselectedColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),

              // Label with color transition
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: widget.isSelected ? 12 : 11,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected ? selectedColor : unselectedColor,
                ),
                child: Text(widget.label),
              ),

              // Sliding indicator
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: widget.isSelected ? 24 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
