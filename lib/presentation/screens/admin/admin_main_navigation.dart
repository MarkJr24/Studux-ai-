import 'package:flutter/material.dart';
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
    const AdminDashboard(),              // Index 0: Home
    const ExamInvigilatorScreen(),       // Index 1: Exams
    const AttendanceAuditScreen(),       // Index 2: Audit
    const EventApprovalScreen(),         // Index 3: Events
    const NotificationsManagementScreen(), // Index 4: Alerts
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If not on home page, navigate to home
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false; // Prevent route pop
        }

        // If on home page, show exit confirmation dialog
        return await _showExitDialog(context) ?? false;
      },
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

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Exit App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        content: const Text(
          'Do you want to exit the application?',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF616161),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Exit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD32F2F),
              ),
            ),
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

class _AnimatedNavItemState extends State<_AnimatedNavItem> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late Animation<double> _bounceAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _rippleAnim;

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
    ]).animate(CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut));
    
    // Scale animation for selected state
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
    
    // Ripple animation
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _scaleController.forward();
      _rippleController.forward(from: 0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _scaleController.dispose();
    _rippleController.dispose();
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
              Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple effect
                  if (widget.isSelected)
                    AnimatedBuilder(
                      animation: _rippleAnim,
                      builder: (context, child) {
                        return Container(
                          width: 40 + (20 * _rippleAnim.value),
                          height: 40 + (20 * _rippleAnim.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedColor.withOpacity(0.15 * (1 - _rippleAnim.value)),
                          ),
                        );
                      },
                    ),
                  
                  // Icon container with gradient background
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: widget.isSelected
                                  ? RadialGradient(
                                      colors: [
                                        selectedColor.withOpacity(0.15),
                                        selectedColor.withOpacity(0.05),
                                      ],
                                    )
                                  : null,
                              boxShadow: widget.isSelected
                                  ? [
                                      BoxShadow(
                                        color: selectedColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              widget.icon,
                              size: 26,
                              color: widget.isSelected ? selectedColor : unselectedColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Label with color transition
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: widget.isSelected ? 12 : 11,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
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
                  gradient: LinearGradient(
                    colors: [
                      selectedColor.withOpacity(0.5),
                      selectedColor,
                      selectedColor.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


