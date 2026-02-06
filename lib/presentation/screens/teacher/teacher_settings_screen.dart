import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import '../../../core/navigation_service.dart';
import '../../../core/widgets/glassmorphic_widgets.dart';
import 'teacher_profile_screen.dart';

class TeacherSettingsScreen extends StatefulWidget {
  const TeacherSettingsScreen({super.key});

  @override
  State<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends State<TeacherSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _parallaxController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _parallaxAnimation;

  // Appearance settings
  String _theme = 'System';
  String _fontSize = 'Medium';

  // Notification settings
  bool _attendanceReminders = true;
  bool _evaluationAlerts = true;
  final bool _examDutyAlerts = true; // Fixed always-on toggle (disabled in UI)
  bool _systemAnnouncements = true;

  // App behavior
  String _defaultLandingPage = 'Dashboard';
  bool _rememberLastClass = true;
  String _autoLogoutTimeout = '30 minutes';

  // Privacy
  bool _showLastActiveStatus = true;
  bool _allowAnonymousAnalytics = false;

  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );

    _parallaxController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    _parallaxAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(2, 1),
    ).animate(
      CurvedAnimation(parent: _parallaxController, curve: Curves.easeInOut),
    );

    _headerController.forward();
    _parallaxController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  void _markAsChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => LogoutHandler.handleBackToLogin(context),
      child: Scaffold(
        body: Stack(
          children: [
            // Parallax background
            AnimatedBuilder(
              animation: _parallaxAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: _parallaxAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.teal.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppearanceSection(),
                          const SizedBox(height: 20),
                          _buildNotificationSettingsSection(),
                          const SizedBox(height: 20),
                          _buildAppBehaviorSection(),
                          const SizedBox(height: 20),
                          _buildPrivacySection(),
                          const SizedBox(height: 20),
                          _buildSecurityShortcutsSection(),
                          const SizedBox(height: 20),
                          _buildAboutSupportSection(),
                          const SizedBox(height: 20),
                          _buildActionButtons(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeTransition(
      opacity: _headerAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => LogoutHandler.handleBackToLogin(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF00695C),
                        Color(0xFF4CAF50),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'SETTINGS',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 72, top: 4),
              child: Text(
                'Customize app behavior & preferences',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _FloatingCard(
      child: GlassmorphicContainer(
        blur: 15,
        opacity: 0.1,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Theme',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildThemeButton('Light'),
                const SizedBox(width: 8),
                _buildThemeButton('Dark'),
                const SizedBox(width: 8),
                _buildThemeButton('System'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Font Size',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFontSizeButton('Small'),
                const SizedBox(width: 8),
                _buildFontSizeButton('Medium'),
                const SizedBox(width: 8),
                _buildFontSizeButton('Large'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton(String theme) {
    final isSelected = _theme == theme;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _theme = theme;
            _markAsChanged();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF4CAF50)],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00695C).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Text(
            theme,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeButton(String size) {
    final isSelected = _fontSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _fontSize = size;
            _markAsChanged();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF4CAF50)],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00695C).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Text(
            size,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSettingsSection() {
    return _FloatingCard(
      child: GlassmorphicContainer(
        blur: 15,
        opacity: 0.1,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Settings',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleRow('Attendance Reminders', _attendanceReminders,
                (value) {
              setState(() {
                _attendanceReminders = value;
                _markAsChanged();
              });
            }),
            _buildToggleRow('Evaluation Alerts', _evaluationAlerts, (value) {
              setState(() {
                _evaluationAlerts = value;
                _markAsChanged();
              });
            }),
            _buildToggleRow('Exam Duty Alerts', _examDutyAlerts, null,
                canDisable: false),
            _buildToggleRow('System Announcements', _systemAnnouncements,
                (value) {
              setState(() {
                _systemAnnouncements = value;
                _markAsChanged();
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool)? onChanged,
      {bool canDisable = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          _NeonToggle(
            value: value,
            onChanged: canDisable ? onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBehaviorSection() {
    return _FloatingCard(
      child: GlassmorphicContainer(
        blur: 15,
        opacity: 0.1,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Behavior',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Default Landing Page',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              _defaultLandingPage,
              ['Dashboard', 'Classes', 'Evaluation', 'Insights'],
              (value) {
                setState(() {
                  _defaultLandingPage = value!;
                  _markAsChanged();
                });
              },
            ),
            const SizedBox(height: 16),
            _buildToggleRow('Remember Last Class', _rememberLastClass, (value) {
              setState(() {
                _rememberLastClass = value;
                _markAsChanged();
              });
            }),
            const SizedBox(height: 8),
            Text(
              'Auto Logout Timeout',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              _autoLogoutTimeout,
              ['15 minutes', '30 minutes', '1 hour', 'Never'],
              (value) {
                setState(() {
                  _autoLogoutTimeout = value!;
                  _markAsChanged();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF2C2C2C),
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPrivacySection() {
    return _FloatingCard(
      child: GlassmorphicContainer(
        blur: 15,
        opacity: 0.1,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleRow('Show Last Active Status', _showLastActiveStatus,
                (value) {
              setState(() {
                _showLastActiveStatus = value;
                _markAsChanged();
              });
            }),
            _buildToggleRow(
                'Allow Anonymous Analytics', _allowAnonymousAnalytics, (value) {
              setState(() {
                _allowAnonymousAnalytics = value;
                _markAsChanged();
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityShortcutsSection() {
    return GlassmorphicContainer(
      blur: 15,
      opacity: 0.1,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Shortcuts',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityLink('Change Password', Icons.lock, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TeacherProfileScreen(),
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildSecurityLink('Active Sessions', Icons.devices, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Active Sessions feature')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSecurityLink(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF00BCD4), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF00BCD4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSupportSection() {
    return _FloatingCard(
      child: GlassmorphicContainer(
        blur: 15,
        opacity: 0.1,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About & Support',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('App Version', '1.0.0'),
            _buildInfoRow('Institution', 'ABC Engineering College'),
            _buildInfoRow('Build', '2024.12.09'),
            const SizedBox(height: 12),
            _buildSupportLink('FAQ', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('FAQ page')),
              );
            }),
            const SizedBox(height: 8),
            _buildSupportLink('Contact Support', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact Support')),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportLink(String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFFB39DDB),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFB39DDB),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFFB39DDB),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _PulsingSaveButton(
            hasUnsavedChanges: _hasUnsavedChanges,
            onTap: () {
              setState(() {
                _hasUnsavedChanges = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NeonGlowButton(
            label: 'Discard',
            onTap: () {
              setState(() {
                _hasUnsavedChanges = false;
                // Reset to defaults
                _theme = 'System';
                _fontSize = 'Medium';
                _attendanceReminders = true;
                _evaluationAlerts = true;
                _systemAnnouncements = true;
                _defaultLandingPage = 'Dashboard';
                _rememberLastClass = true;
                _autoLogoutTimeout = '30 minutes';
                _showLastActiveStatus = true;
                _allowAnonymousAnalytics = false;
              });
            },
            gradientColors: const [Color(0xFF616161), Color(0xFF424242)],
            height: 50,
          ),
        ),
      ],
    );
  }
}

/// Floating card with gentle animation
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
      duration: const Duration(seconds: 8),
    );
    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}

/// Neon toggle switch
class _NeonToggle extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;

  const _NeonToggle({
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: value
              ? const LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF4CAF50)],
                )
              : null,
          color: value ? null : Colors.grey.shade400,
          boxShadow: value
              ? [
                  BoxShadow(
                    color: const Color(0xFF00695C).withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pulsing save button
class _PulsingSaveButton extends StatefulWidget {
  final bool hasUnsavedChanges;
  final VoidCallback onTap;

  const _PulsingSaveButton({
    required this.hasUnsavedChanges,
    required this.onTap,
  });

  @override
  State<_PulsingSaveButton> createState() => _PulsingSaveButtonState();
}

class _PulsingSaveButtonState extends State<_PulsingSaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.hasUnsavedChanges) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_PulsingSaveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasUnsavedChanges && !oldWidget.hasUnsavedChanges) {
      _controller.repeat(reverse: true);
    } else if (!widget.hasUnsavedChanges && oldWidget.hasUnsavedChanges) {
      _controller.stop();
      _controller.reset();
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
      builder: (context, _) {
        return NeonGlowButton(
          label: 'Save Changes',
          onTap: widget.onTap,
          gradientColors: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          height: 50,
        );
      },
    );
  }
}
