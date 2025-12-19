import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../../../config/theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../admin/admin_main_navigation.dart';
import 'forgot_password_email.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _showSuccess = false;

  // Hardcoded credentials
  static const String _validEmail = 'admin@studentms.com';
  static const String _validPassword = 'Admin@123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Check credentials
    if (_emailController.text == _validEmail &&
        _passwordController.text == _validPassword) {
      if (mounted) {
        // Show success animation
        setState(() => _showSuccess = true);
        
        // Wait for success animation
        await Future.delayed(const Duration(milliseconds: 250));
        
        if (!mounted) return;
        setState(() => _showSuccess = false);
        
        SnackbarHelper.showSuccess(context, 'Login successful!');
        // Navigate to admin main navigation (clears entire navigation stack)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminMainNavigation(),
          ),
          (route) => false, // Remove ALL previous routes
        );
      }
    } else {
      if (mounted) {
        SnackbarHelper.showError(
          context,
          'Invalid credentials. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Login Screen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_screen.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // If no image found, show a subtle gradient background
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Semi-transparent White Overlay for Readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          
          // Animated Admin Icons Background
          const Positioned.fill(
            child: _AnimatedAdminBackground(),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(),

                // Login Card
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildLoginCard(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          _AnimatedHeaderText(
            text: 'Admin Login',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return _FloatingCard(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.95),
                  const Color(0xFFF3E8FF).withOpacity(0.92),
                  const Color(0xFFEFF6FF).withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9333EA).withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Welcome Back, Admin',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Sign in to access the admin dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 22),

                  // Email Field
                  _buildEmailField(),

                  const SizedBox(height: 16),

                  // Password Field
                  _buildPasswordField(),

                  const SizedBox(height: 16),

                  // Remember Me
                  _buildRememberMe(),

                  const SizedBox(height: 24),

                  // Login Button
                  _buildLoginButton(),

                  const SizedBox(height: 20),

                  // Forgot Password
                  _buildForgotPassword(),

                  const SizedBox(height: 18),

                  // Back to Role Selection
                  _buildBackToRoleSelection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'admin@studentms.com',
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Color(0xFF9CA3AF),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // gray-300
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: Validators.validatePassword,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'Admin@123',
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF9CA3AF),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF9CA3AF),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Text(
          'Remember Me',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return _NeonButton(
      onTap: _isLoading ? null : _handleLogin,
      isLoading: _isLoading,
      showSuccess: _showSuccess,
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordEmailScreen(
                userType: 'admin',
              ),
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToRoleSelection() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Back to Login Selection',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Floating Card Animation Widget
class _FloatingCard extends StatefulWidget {
  final Widget child;

  const _FloatingCard({required this.child});

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
      duration: const Duration(seconds: 7),
    );

    _animation = Tween<double>(begin: 0, end: 3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
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
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // Create particles
    for (int i = 0; i < 12; i++) {
      _particles.add(_Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 3 + 2,
        speed: math.Random().nextDouble() * 0.3 + 0.2,
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
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9333EA).withOpacity(0.08);

    for (var particle in particles) {
      final yPos = size.height * (particle.y - progress * particle.speed) % size.height;
      canvas.drawCircle(
        Offset(size.width * particle.x, yPos),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}

// Animated Header Text with Underline
class _AnimatedHeaderText extends StatefulWidget {
  final String text;

  const _AnimatedHeaderText({required this.text});

  @override
  State<_AnimatedHeaderText> createState() => _AnimatedHeaderTextState();
}

class _AnimatedHeaderTextState extends State<_AnimatedHeaderText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
          Text(
          widget.text,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 2,
              width: 100 * _animation.value,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB794F6), // Lighter purple
                    Color(0xFF60D5F4), // Bright cyan
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Neon Button with Success Animation
class _NeonButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showSuccess;

  const _NeonButton({
    required this.onTap,
    required this.isLoading,
    required this.showSuccess,
  });

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _successAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.2),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(_NeonButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showSuccess && !oldWidget.showSuccess) {
      _successController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 1.03 : 1.0;

    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.showSuccess ? _successAnimation.value : scale,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF9333EA),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9333EA).withOpacity(_isPressed ? 0.5 : 0.3),
                  blurRadius: _isPressed ? 20 : 15,
                  offset: const Offset(0, 8),
                  spreadRadius: _isPressed ? 2 : 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : widget.showSuccess
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            )
                          : Text(
                              'Sign In as Admin',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Parallax Background with Futuristic Image
class _ParallaxBackground extends StatefulWidget {
  const _ParallaxBackground();

  @override
  State<_ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<_ParallaxBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.002, 0.002), // Very subtle 2px drift
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
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
          offset: Offset(
            _animation.value.dx * MediaQuery.of(context).size.width,
            _animation.value.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/admin_login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Animated Admin Background with Security Icons
class _AnimatedAdminBackground extends StatefulWidget {
  const _AnimatedAdminBackground();

  @override
  State<_AnimatedAdminBackground> createState() => _AnimatedAdminBackgroundState();
}

class _AnimatedAdminBackgroundState extends State<_AnimatedAdminBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FloatingIcon> _icons = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Create floating admin-related icons (unique admin dashboard items)
    final adminIcons = [
      Icons.dashboard_outlined,
      Icons.admin_panel_settings,
      Icons.settings_outlined,
      Icons.analytics_outlined,
      Icons.bar_chart_outlined,
      Icons.supervisor_account_outlined,
      Icons.pie_chart_outline,
      Icons.trending_up,
      Icons.assessment_outlined,
      Icons.show_chart,
      Icons.leaderboard_outlined,
      Icons.business_center_outlined,
      Icons.verified_user_outlined,
      Icons.security_outlined,
      Icons.policy_outlined,
    ];

    // Use a grid-based distribution (3 columns x 5 rows) to ensure even coverage
    final random = math.Random(42); // Fixed seed for consistent layout
    
    for (int i = 0; i < 15; i++) {
      // Grid position
      final col = i % 3;
      final row = i ~/ 3;
      
      // Base position + random offset within grid cell
      // X: 0-0.33, 0.33-0.66, 0.66-1.0
      // Y: 0-0.2, 0.2-0.4, etc.
      double x = (col * 0.33) + random.nextDouble() * 0.25;
      double y = (row * 0.2) + random.nextDouble() * 0.15;
      
      _icons.add(_FloatingIcon(
        icon: adminIcons[i % adminIcons.length],
        x: x,
        y: y,
        size: 25 + random.nextDouble() * 20, // Random size 25-45
        speed: 0.01 + random.nextDouble() * 0.02, // Random speed
        delay: random.nextDouble(), // Random delay
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
          painter: _FloatingIconPainter(
            icons: _icons,
            progress: _controller.value,
            color: const Color(0xFF9333EA), // Purple
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _FloatingIcon {
  final IconData icon;
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  _FloatingIcon({
    required this.icon,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

class _FloatingIconPainter extends CustomPainter {
  final List<_FloatingIcon> icons;
  final double progress;
  final Color color;

  _FloatingIconPainter({
    required this.icons,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var iconData in icons) {
      final adjustedProgress = ((progress + iconData.delay) % 1.0);
      
      // Vertical position (static - no movement)
      final yPos = size.height * iconData.y;
      
      // Horizontal position (static - no wave motion)
      final xPos = size.width * iconData.x;
      
      if (yPos > -iconData.size && yPos < size.height + iconData.size) {
        // Static opacity - no blinking
        final opacity = 0.15;
        
        // No scale pulsing - static size
        final scale = 1.0;
        
        canvas.save();
        canvas.translate(xPos + iconData.size / 2, yPos + iconData.size / 2);
        canvas.scale(scale);
        
        final textPainter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(iconData.icon.codePoint),
            style: TextStyle(
              fontSize: iconData.size,
              fontFamily: iconData.icon.fontFamily,
              color: color.withOpacity(opacity),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_FloatingIconPainter oldDelegate) => true;
}
