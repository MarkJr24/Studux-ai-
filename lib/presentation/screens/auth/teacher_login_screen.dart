import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../../../config/theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../teacher/teacher_main_navigation.dart';
import 'forgot_password_email.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _showSuccess = false;

  late AnimationController _entranceController;
  late AnimationController _successController;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _fieldsFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

  static const String _validEmail = 'teacher@studentms.com';
  static const String _validPassword = 'Teacher@123';

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _cardFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _fieldsFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _successController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (_emailController.text == _validEmail &&
        _passwordController.text == _validPassword) {
      setState(() => _showSuccess = true);
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;

      setState(() => _showSuccess = false);
      SnackbarHelper.showSuccess(context, 'Login successful!');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const TeacherMainNavigation(),
        ),
        (route) => false,
      );
    } else {
      SnackbarHelper.showError(
        context,
        'Invalid credentials. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/teacher_login_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFF7F8FA)),
            ),
          ),
          
          // Animated Teacher Icons Background
          const Positioned.fill(
            child: _AnimatedTeacherBackground(),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
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
          const _AnimatedHeaderText(text: 'Teacher Login'),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return FadeTransition(
      opacity: _cardFadeAnimation,
      child: SlideTransition(
        position: _cardSlideAnimation,
        child: _FloatingCard(
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
                      const Color(0xFFFFE8D9).withOpacity(0.92), // Light orange
                      const Color(0xFFFFF3E0).withOpacity(0.95), // Light amber
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7B54).withOpacity(0.2),
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
                        'Welcome Back, Teacher',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Sign in to access your teaching dashboard',
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
                      FadeTransition(
                        opacity: _buttonFadeAnimation,
                        child: _buildLoginButton(),
                      ),
                      const SizedBox(height: 20),
                      _buildForgotPassword(),
                      const SizedBox(height: 18),
                      _buildBackToRoleSelection(),
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
        hintText: 'teacher@studentms.com',
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF6B7280),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.school_outlined,
          color: Color(0xFF9CA3AF),
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
          borderSide: const BorderSide(color: Color(0xFFFF7B54), width: 2), // Orange focus
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
        hintText: 'Teacher@123',
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
          borderSide: const BorderSide(color: Color(0xFFFF7B54), width: 2), // Orange focus
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
          activeColor: const Color(0xFFFF7B54), // Orange color
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
                userType: 'teacher',
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
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 7))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 3).animate(_controller);
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
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, -_animation.value), child: child),
      child: widget.child,
    );
  }
}

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
                    Color(0xFFFF7B54), // Orange
                    Color(0xFFFFB84D), // Yellow-Orange
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
                  Color(0xFFFF7B54), // Orange
                  Color(0xFFFFB84D), // Yellow-Orange
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7B54).withOpacity(_isPressed ? 0.5 : 0.3),
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
                              'Sign In as Teacher',
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

// Animated Teacher Background with Education Icons
class _AnimatedTeacherBackground extends StatefulWidget {
  const _AnimatedTeacherBackground();

  @override
  State<_AnimatedTeacherBackground> createState() => _AnimatedTeacherBackgroundState();
}

class _AnimatedTeacherBackgroundState extends State<_AnimatedTeacherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_TeacherFloatingIcon> _icons = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Create floating teacher-related icons (books, teaching materials, education)
    final teacherIcons = [
      Icons.menu_book,
      Icons.auto_stories,
      Icons.book_outlined,
      Icons.chrome_reader_mode,
      Icons.library_books,
      Icons.import_contacts,
      Icons.subject_outlined,
      Icons.article_outlined,
      Icons.description_outlined,
      Icons.library_add_outlined,
      Icons.bookmark_outline,
      Icons.format_quote,
      Icons.text_snippet_outlined,
      Icons.note_outlined,
      Icons.sticky_note_2_outlined,
    ];

    // Use a grid-based distribution (3 columns x 5 rows) to ensure even coverage
    final random = math.Random(43); // Different seed
    
    for (int i = 0; i < 15; i++) {
      // Grid position
      final col = i % 3;
      final row = i ~/ 3;
      
      double x = (col * 0.33) + random.nextDouble() * 0.25;
      double y = (row * 0.2) + random.nextDouble() * 0.15;
      
      _icons.add(_TeacherFloatingIcon(
        icon: teacherIcons[i % teacherIcons.length],
        x: x,
        y: y,
        size: 25 + random.nextDouble() * 20,
        speed: 0.01 + random.nextDouble() * 0.02,
        delay: random.nextDouble(),
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
          painter: _TeacherIconPainter(
            icons: _icons,
            progress: _controller.value,
            color: const Color(0xFFFF7B54), // Orange
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _TeacherFloatingIcon {
  final IconData icon;
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  _TeacherFloatingIcon({
    required this.icon,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

class _TeacherIconPainter extends CustomPainter {
  final List<_TeacherFloatingIcon> icons;
  final double progress;
  final Color color;

  _TeacherIconPainter({
    required this.icons,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var iconData in icons) {
      final adjustedProgress = ((progress + iconData.delay) % 1.0);
      
      // Vertical movement (floating upward)
      final yPos = size.height * (iconData.y - adjustedProgress * iconData.speed * size.height / 100);
      
      // Horizontal wave motion (sine wave)
      final waveOffset = math.sin(adjustedProgress * math.pi * 4) * 15;
      final xPos = size.width * iconData.x + waveOffset;
      
      if (yPos > -iconData.size && yPos < size.height + iconData.size) {
        final opacity = (0.5 + (1 - adjustedProgress) * 0.1).clamp(0.5, 0.6);
        
        // Scale pulsing (gentle breathing effect)
        final scale = 1.0 + math.sin(adjustedProgress * math.pi * 2) * 0.1;
        
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
  bool shouldRepaint(_TeacherIconPainter oldDelegate) => true;
}
