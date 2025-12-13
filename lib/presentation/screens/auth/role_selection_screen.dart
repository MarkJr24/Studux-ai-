import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'admin_login_screen.dart';
import 'teacher_login_screen.dart';
import 'student_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const RoleSelectionScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF2D1B4E).withOpacity(0.50),
                          const Color(0xFF1a1a2e).withOpacity(0.60),
                        ]
                      : [
                          const Color(0xFFE8D5F2).withOpacity(0.50),
                          const Color(0xFFD4E4F7).withOpacity(0.60),
                        ],
                ),
              ),
            ),
          ),
          
          // Animated Background with Particles
          _AnimatedBackground(isDark: isDark),
          
          // Main Content
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Education Illustration
                      _buildAnimatedIllustration(),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Student Management System',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Select Login Type',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Admin Login Card with Floating Animation
                      _FloatingCard(
                        delay: 0,
                        child: _AnimatedRoleCard(
                          role: 'Admin',
                          description: 'Manage system and users',
                          icon: Icons.shield_outlined,
                          gradientColors: const [
                            Color(0xFF6B2FBF),
                            Color(0xFF8B5FBF),
                          ],
                          iconBackgroundColor: const Color(0xFF5A2FA0),
                          onTap: () => _navigateToAdminLogin(context),
                          iconAnimationType: IconAnimationType.pulse,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Teacher Login Card with Floating Animation
                      _FloatingCard(
                        delay: 2000,
                        child: _AnimatedRoleCard(
                          role: 'Teacher',
                          description: 'Access teaching dashboard',
                          icon: Icons.co_present,
                          gradientColors: const [
                            Color(0xFFFF7B54),
                            Color(0xFFFFB84D),
                          ],
                          iconBackgroundColor: const Color(0xFFFF9068),
                          onTap: () => _navigateToTeacherLogin(context),
                          iconAnimationType: IconAnimationType.slide,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Student Login Card with Floating Animation
                      _FloatingCard(
                        delay: 4000,
                        child: _AnimatedRoleCard(
                          role: 'Student',
                          description: 'View courses and grades',
                          icon: Icons.account_circle,
                          gradientColors: const [
                            Color(0xFF4A90E2),
                            Color(0xFF50C9C3),
                          ],
                          iconBackgroundColor: const Color(0xFF5AA8D8),
                          onTap: () => _navigateToStudentLogin(context),
                          iconAnimationType: IconAnimationType.bounce,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Sign Up Link
                      _buildSignUpLink(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIllustration() {
    return _GlassmorphismIconCircle(
      child: Lottie.network(
        'https://assets2.lottiefiles.com/packages/lf20_DMgKk1.json',
        width: 120,
        height: 120,
        // Fallback to animated icon if network fails
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.school,
            size: 60,
            color: Color(0xFF6B2FBF),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3))
            .then()
            .shake(duration: 500.ms, hz: 2, curve: Curves.easeInOut);
        },
        repeat: true,
        animate: true,
      ),
    );
  }

  Widget _buildSignUpLink(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.inter(
            fontSize: 15,
            color: isDark ? Colors.white.withOpacity(0.7) : Colors.black54,
          ),
        ),
        TextButton(
          onPressed: () {
            debugPrint('Sign Up tapped');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign Up',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF6B5FBF) : const Color(0xFF6B2FBF),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToAdminLogin(BuildContext context) {
    debugPrint('Admin Login tapped');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminLoginScreen(),
      ),
    );
  }

  void _navigateToTeacherLogin(BuildContext context) {
    debugPrint('Teacher Login tapped');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TeacherLoginScreen(),
      ),
    );
  }

  void _navigateToStudentLogin(BuildContext context) {
    debugPrint('Student Login tapped');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentLoginScreen(),
      ),
    );
  }
}

// Floating Card Wrapper for Antigravity Effect
class _FloatingCard extends StatefulWidget {
  final Widget child;
  final int delay; // milliseconds

  const _FloatingCard({
    required this.child,
    required this.delay,
  });

  @override
  State<_FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<_FloatingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _animation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Delay start based on card position
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Animated Background with Particles
class _AnimatedBackground extends StatefulWidget {
  final bool isDark;

  const _AnimatedBackground({required this.isDark});

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Create particles
    for (int i = 0; i < 15; i++) {
      _particles.add(Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 4 + 2,
        speed: math.Random().nextDouble() * 0.5 + 0.3,
        delay: i * 0.5,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            isDark: widget.isDark,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final bool isDark;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark
              ? Colors.purple.withOpacity(0.15)
              : Colors.purple.withOpacity(0.08))
          .withOpacity(0.3);

    for (var particle in particles) {
      final adjustedProgress = ((progress + particle.delay) % 1.0);
      final yPos = size.height * (particle.y - adjustedProgress * particle.speed);
      
      if (yPos > -particle.size && yPos < size.height) {
        canvas.drawCircle(
          Offset(size.width * particle.x, yPos),
          particle.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Icon Animation Types
enum IconAnimationType {
  pulse,   // Admin - shield pulse
  slide,   // Teacher - slide animation
  bounce,  // Student - bounce animation
}

// Animated Role Card with Enhanced Antigravity Effects
class _AnimatedRoleCard extends StatefulWidget {
  final String role;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color iconBackgroundColor;
  final VoidCallback onTap;
  final IconAnimationType iconAnimationType;

  const _AnimatedRoleCard({
    required this.role,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.iconBackgroundColor,
    required this.onTap,
    required this.iconAnimationType,
  });

  @override
  State<_AnimatedRoleCard> createState() => _AnimatedRoleCardState();
}

class _AnimatedRoleCardState extends State<_AnimatedRoleCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _tapController;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapController.forward(from: 0).then((_) {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _handleTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _tapController,
          builder: (context, child) {
            final scale = _isPressed
                ? 1.05
                : _tapController.isAnimating
                    ? 1.0 + (0.05 * (1 - _tapController.value))
                    : isActive
                        ? 1.03
                        : 1.0;

            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: widget.gradientColors,
              ),
              border: Border.all(
                color: widget.gradientColors[0].withOpacity(isActive ? 0.8 : 0.4),
                width: isActive ? 2 : 1,
              ),
              boxShadow: [
                // Primary shadow - deeper on hover
                BoxShadow(
                  color: widget.gradientColors[0].withOpacity(isActive ? 0.5 : 0.4),
                  blurRadius: isActive ? 30 : 25,
                  offset: Offset(0, isActive ? 15 : 12),
                  spreadRadius: _isPressed ? 8 : (isActive ? 2 : 0),
                ),
                // Secondary shadow for depth
                BoxShadow(
                  color: widget.gradientColors[1].withOpacity(0.2),
                  blurRadius: isActive ? 20 : 15,
                  offset: Offset(0, isActive ? 8 : 6),
                ),
                // Neon glow effect - enhanced on press
                if (isActive)
                  BoxShadow(
                    color: widget.gradientColors[0].withOpacity(_isPressed ? 0.8 : 0.6),
                    blurRadius: _isPressed ? 50 : 40,
                    spreadRadius: _isPressed ? 8 : 5,
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Animated Icon Circle
                      _AnimatedIconCircle(
                        icon: widget.icon,
                        backgroundColor: widget.iconBackgroundColor,
                        isActive: isActive,
                        animationType: widget.iconAnimationType,
                      ),

                      const SizedBox(width: 20),

                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.role} Login',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.description,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              .animate(
                target: isActive ? 1 : 0,
              )
              .shimmer(
                duration: 1500.ms,
                color: Colors.white.withOpacity(0.3),
                angle: 0,
              ),
        ),
      ),
    );
  }
}

// Animated Icon Circle with Role-Specific Micro-Animations
class _AnimatedIconCircle extends StatefulWidget {
  final IconData icon;
  final Color backgroundColor;
  final bool isActive;
  final IconAnimationType animationType;

  const _AnimatedIconCircle({
    required this.icon,
    required this.backgroundColor,
    required this.isActive,
    required this.animationType,
  });

  @override
  State<_AnimatedIconCircle> createState() => _AnimatedIconCircleState();
}

class _AnimatedIconCircleState extends State<_AnimatedIconCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Different animation durations for each type
    final duration = switch (widget.animationType) {
      IconAnimationType.pulse => const Duration(milliseconds: 2000),
      IconAnimationType.slide => const Duration(milliseconds: 3000),
      IconAnimationType.bounce => const Duration(milliseconds: 2500),
    };

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start animation with delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _startAnimation();
      }
    });
  }

  void _startAnimation() {
    switch (widget.animationType) {
      case IconAnimationType.pulse:
        // Pulse: animate then pause
        _controller.forward().then((_) {
          _controller.reverse().then((_) {
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) _startAnimation();
            });
          });
        });
        break;
      case IconAnimationType.slide:
      case IconAnimationType.bounce:
        // Continuous loop
        _controller.repeat(reverse: true);
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        Widget iconWidget;
        
        // Use custom shield-person icon for Admin (pulse animation type)
        if (widget.animationType == IconAnimationType.pulse) {
          iconWidget = CustomPaint(
            size: const Size(32, 32),
            painter: _ShieldPersonIconPainter(color: Colors.white),
          );
        } 
        // Use custom teacher icon for Teacher (slide animation type)
        else if (widget.animationType == IconAnimationType.slide) {
          iconWidget = CustomPaint(
            size: const Size(32, 32),
            painter: _TeacherIconPainter(color: Colors.white),
          );
        }
        // Use custom student icon for Student (bounce animation type)
        else if (widget.animationType == IconAnimationType.bounce) {
          iconWidget = CustomPaint(
            size: const Size(32, 32),
            painter: _StudentIconPainter(color: Colors.white),
          );
        }
        else {
          iconWidget = Icon(
            widget.icon,
            size: 32,
            color: Colors.white,
          );
        }

        // Apply animation based on type
        switch (widget.animationType) {
          case IconAnimationType.pulse:
            // Scale pulse with glow
            final scale = 1.0 + (_animation.value * 0.1);
            iconWidget = Transform.scale(
              scale: scale,
              child: iconWidget,
            );
            break;
          case IconAnimationType.slide:
            // Horizontal slide
            final offset = (_animation.value - 0.5) * 6;
            iconWidget = Transform.translate(
              offset: Offset(offset, 0),
              child: iconWidget,
            );
            break;
          case IconAnimationType.bounce:
            // Vertical bounce
            final offset = -_animation.value * 3;
            iconWidget = Transform.translate(
              offset: Offset(0, offset),
              child: iconWidget,
            );
            break;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.backgroundColor.withOpacity(0.5),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    // Subtle ambient glow for Admin icon (pulse type) - purple
                    if (widget.animationType == IconAnimationType.pulse)
                      BoxShadow(
                        color: widget.backgroundColor.withOpacity(0.3 * _animation.value),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    // Subtle ambient glow for Teacher icon (slide type) - orange-yellow
                    if (widget.animationType == IconAnimationType.slide)
                      BoxShadow(
                        color: const Color(0xFFFF9068).withOpacity(0.4 * _animation.value),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    // Subtle ambient glow for Student icon (bounce type) - cyan-blue
                    if (widget.animationType == IconAnimationType.bounce)
                      BoxShadow(
                        color: const Color(0xFF50C9C3).withOpacity(0.4 * _animation.value),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                  ],
          ),
          child: iconWidget,
        );
      },
    );
  }
}

// Glassmorphism Icon Circle with Pulsing Animation
class _GlassmorphismIconCircle extends StatefulWidget {
  final Widget child;

  const _GlassmorphismIconCircle({
    required this.child,
  });

  @override
  State<_GlassmorphismIconCircle> createState() => _GlassmorphismIconCircleState();
}

class _GlassmorphismIconCircleState extends State<_GlassmorphismIconCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Slow pulsing animation (7 seconds)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 140,
          height: 140,
          child: ClipOval(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Glassmorphism gradient with inner glow and top shine
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.2,
                    colors: [
                      // Top shine (reflective) - soft white
                      Colors.white.withOpacity(0.6 * _pulseAnimation.value),
                      // Inner glow - very light blue
                      const Color(0xFFD4E4F7).withOpacity(0.35 * _pulseAnimation.value),
                      // Soft tint - light purple-blue
                      const Color(0xFFE8D5F2).withOpacity(0.25 * _pulseAnimation.value),
                      // Outer edge - subtle purple
                      const Color(0xFF9B8FBF).withOpacity(0.2 * _pulseAnimation.value),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                  // Soft blue-purple rim
                  border: Border.all(
                    color: const Color(0xFF8B7FBF).withOpacity(0.5 * _pulseAnimation.value),
                    width: 2.5,
                  ),
                ),
                child: Container(
                  // Additional inner border for enhanced neon effect
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3 * _pulseAnimation.value),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

// Custom Shield-Person Icon Painter
class _ShieldPersonIconPainter extends CustomPainter {
  final Color color;

  _ShieldPersonIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 32; // Scale to icon size

    // Draw shield outline
    final shieldPath = Path();
    shieldPath.moveTo(center.dx, center.dy - 14 * scale);
    shieldPath.lineTo(center.dx + 10 * scale, center.dy - 10 * scale);
    shieldPath.lineTo(center.dx + 10 * scale, center.dy + 4 * scale);
    shieldPath.quadraticBezierTo(
      center.dx + 10 * scale,
      center.dy + 10 * scale,
      center.dx,
      center.dy + 14 * scale,
    );
    shieldPath.quadraticBezierTo(
      center.dx - 10 * scale,
      center.dy + 10 * scale,
      center.dx - 10 * scale,
      center.dy + 4 * scale,
    );
    shieldPath.lineTo(center.dx - 10 * scale, center.dy - 10 * scale);
    shieldPath.close();

    // Draw shield outline (stroke)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0 * scale;
    canvas.drawPath(shieldPath, paint);

    // Draw person silhouette inside shield
    paint.style = PaintingStyle.fill;

    // Head (circle)
    canvas.drawCircle(
      Offset(center.dx, center.dy - 4 * scale),
      2.5 * scale,
      paint,
    );

    // Body (rounded rectangle/trapezoid)
    final bodyPath = Path();
    bodyPath.moveTo(center.dx - 4 * scale, center.dy + 1 * scale);
    bodyPath.lineTo(center.dx + 4 * scale, center.dy + 1 * scale);
    bodyPath.lineTo(center.dx + 5 * scale, center.dy + 8 * scale);
    bodyPath.lineTo(center.dx - 5 * scale, center.dy + 8 * scale);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(_ShieldPersonIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

// Custom Teacher Icon Painter (Teacher with book and graduation cap)
class _TeacherIconPainter extends CustomPainter {
  final Color color;

  _TeacherIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 32;

    // Graduation cap
    final capPath = Path();
    // Cap top (flat board)
    capPath.moveTo(center.dx - 10 * scale, center.dy - 10 * scale);
    capPath.lineTo(center.dx + 10 * scale, center.dy - 10 * scale);
    // Cap center point
    capPath.moveTo(center.dx, center.dy - 10 * scale);
    capPath.lineTo(center.dx, center.dy - 7 * scale);
    // Tassel
    capPath.moveTo(center.dx + 8 * scale, center.dy - 10 * scale);
    capPath.lineTo(center.dx + 10 * scale, center.dy - 12 * scale);
    canvas.drawPath(capPath, paint);

    // Head (circle)
    canvas.drawCircle(
      Offset(center.dx, center.dy - 3 * scale),
      4 * scale,
      paint,
    );

    // Body/Torso
    final bodyPath = Path();
    bodyPath.moveTo(center.dx - 5 * scale, center.dy + 2 * scale);
    bodyPath.lineTo(center.dx - 5 * scale, center.dy + 10 * scale);
    bodyPath.moveTo(center.dx + 5 * scale, center.dy + 2 * scale);
    bodyPath.lineTo(center.dx + 5 * scale, center.dy + 10 * scale);
    // Shoulders
    bodyPath.moveTo(center.dx - 5 * scale, center.dy + 2 * scale);
    bodyPath.lineTo(center.dx + 5 * scale, center.dy + 2 * scale);
    canvas.drawPath(bodyPath, paint);

    // Book (open book in hands)
    final bookPath = Path();
    // Left page
    bookPath.moveTo(center.dx - 6 * scale, center.dy + 6 * scale);
    bookPath.lineTo(center.dx - 6 * scale, center.dy + 12 * scale);
    bookPath.lineTo(center.dx, center.dy + 12 * scale);
    // Right page
    bookPath.moveTo(center.dx, center.dy + 6 * scale);
    bookPath.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    bookPath.lineTo(center.dx + 6 * scale, center.dy + 12 * scale);
    bookPath.lineTo(center.dx, center.dy + 12 * scale);
    // Spine
    bookPath.moveTo(center.dx, center.dy + 6 * scale);
    bookPath.lineTo(center.dx, center.dy + 12 * scale);
    canvas.drawPath(bookPath, paint);

    // Desk/podium (simple line)
    canvas.drawLine(
      Offset(center.dx - 8 * scale, center.dy + 13 * scale),
      Offset(center.dx + 8 * scale, center.dy + 13 * scale),
      paint,
    );
  }

  @override
  bool shouldRepaint(_TeacherIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

// Custom Student Icon Painter (Student with graduation cap outline)
class _StudentIconPainter extends CustomPainter {
  final Color color;

  _StudentIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 32;

    // Graduation cap (mortarboard)
    final capPath = Path();
    // Cap board (diamond/square rotated)
    capPath.moveTo(center.dx, center.dy - 12 * scale);
    capPath.lineTo(center.dx + 9 * scale, center.dy - 9 * scale);
    capPath.lineTo(center.dx, center.dy - 6 * scale);
    capPath.lineTo(center.dx - 9 * scale, center.dy - 9 * scale);
    capPath.close();
    canvas.drawPath(capPath, paint);

    // Tassel
    canvas.drawLine(
      Offset(center.dx + 7 * scale, center.dy - 10 * scale),
      Offset(center.dx + 9 * scale, center.dy - 13 * scale),
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + 9 * scale, center.dy - 13 * scale),
      1 * scale,
      paint,
    );

    // Head (circle)
    canvas.drawCircle(
      Offset(center.dx, center.dy - 2 * scale),
      4.5 * scale,
      paint,
    );

    // Shoulders/Body (trapezoid shape)
    final bodyPath = Path();
    bodyPath.moveTo(center.dx - 4 * scale, center.dy + 3 * scale);
    bodyPath.lineTo(center.dx - 7 * scale, center.dy + 12 * scale);
    bodyPath.lineTo(center.dx + 7 * scale, center.dy + 12 * scale);
    bodyPath.lineTo(center.dx + 4 * scale, center.dy + 3 * scale);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);

    // Neck/collar detail
    canvas.drawLine(
      Offset(center.dx - 2 * scale, center.dy + 3 * scale),
      Offset(center.dx + 2 * scale, center.dy + 3 * scale),
      paint,
    );
  }

  @override
  bool shouldRepaint(_StudentIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
