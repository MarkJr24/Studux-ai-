import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_design_system.dart';
import '../auth/teacher_login_screen.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  bool _isEditingProfile = false;
  bool _isChangingPassword = false;

  // Profile data
  final TextEditingController _phoneController = TextEditingController(text: '+91 9876543210');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@college.edu');
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Notification preferences
  bool _attendanceAlerts = true;
  bool _evaluationAlerts = true;
  bool _examDutyAlerts = true;
  bool _systemAnnouncements = true;

  // App preferences
  String _theme = 'System';
  String _defaultLandingPage = 'Dashboard';

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFacultyIdentitySection(),
                    const SizedBox(height: 20),
                    _buildPersonalInformationSection(),
                    const SizedBox(height: 20),
                    _buildSecuritySection(),
                    const SizedBox(height: 20),
                    _buildNotificationPreferencesSection(),
                    const SizedBox(height: 20),
                    _buildAppPreferencesSection(),
                    const SizedBox(height: 20),
                    _buildActivityInformationSection(),
                    const SizedBox(height: 40),
                    
                    // Divider before logout
                    const Divider(color: TeacherColors.divider, height: 1),
                    const SizedBox(height: 24),
                    
                    // Logout Button
                    _buildLogoutButton(),
                    const SizedBox(height: 24),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: TeacherColors.background,
        border: Border(
          bottom: BorderSide(color: TeacherColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: TeacherColors.backButtonBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              color: TeacherColors.iconGray,
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
                  'Faculty Profile',
                  style: TeacherTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your profile and preferences',
                  style: TeacherTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyIdentitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FACULTY INFORMATION',
            style: TeacherTextStyles.sectionTitleColored(TeacherColors.primaryButton),
          ),
          const SizedBox(height: 16),
          
          // Profile Picture
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: TeacherColors.profileBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: TeacherColors.profileIcon,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Name
          Center(
            child: Text(
              'Dr. Rajesh Kumar',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: TeacherColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 4),
          
          // Faculty ID
          Center(
            child: Text(
              'Faculty ID: FAC12345',
              style: TeacherTextStyles.bodyText,
            ),
          ),
          const SizedBox(height: 20),
          
          // Department
          _buildInfoRow(Icons.business, 'Department', 'Computer Science & Engineering'),
          const SizedBox(height: 12),
          
          // Email
          _buildInfoRow(Icons.email, 'Email', 'john.doe@college.edu'),
          const SizedBox(height: 12),
          
          // Phone
          _buildInfoRow(Icons.phone, 'Phone', '+91 9876543210'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: TeacherColors.primaryButton),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.labelText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TeacherColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PERSONAL INFORMATION',
                style: TeacherTextStyles.sectionTitleColored(TeacherColors.primaryButton),
              ),
              if (!_isEditingProfile)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditingProfile = true;
                    });
                  },
                  child: Text(
                    'Edit',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.primaryButton,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildTextField('Phone', _phoneController, _isEditingProfile),
          const SizedBox(height: 12),
          _buildTextField('Email', _emailController, _isEditingProfile),
          
          if (_isEditingProfile) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    'Cancel',
                    () {
                      setState(() {
                        _isEditingProfile = false;
                      });
                    },
                    isSecondary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildButton(
                    'Save',
                    () {
                      setState(() {
                        _isEditingProfile = false;
                      });
                      _showSuccessToast('Profile updated successfully');
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SECURITY',
                style: TeacherTextStyles.sectionTitleColored(TeacherColors.primaryButton),
              ),
              if (!_isChangingPassword)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isChangingPassword = true;
                    });
                  },
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.primaryButton,
                    ),
                  ),
                ),
            ],
          ),
          
          if (_isChangingPassword) ...[
            const SizedBox(height: 16),
            _buildPasswordField('Current Password', _currentPasswordController),
            const SizedBox(height: 12),
            _buildPasswordField('New Password', _newPasswordController),
            const SizedBox(height: 12),
            _buildPasswordField('Confirm Password', _confirmPasswordController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    'Cancel',
                    () {
                      setState(() {
                        _isChangingPassword = false;
                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      });
                    },
                    isSecondary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildButton(
                    'Update',
                    () {
                      setState(() {
                        _isChangingPassword = false;
                      });
                      _showSuccessToast('Password changed successfully');
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationPreferencesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICATION PREFERENCES',
            style: TeacherTextStyles.sectionTitleColored(TeacherColors.primaryButton),
          ),
          const SizedBox(height: 16),
          
          _buildToggleRow('Attendance Alerts', _attendanceAlerts, (val) {
            setState(() {
              _attendanceAlerts = val;
            });
          }),
          const SizedBox(height: 12),
          _buildToggleRow('Evaluation Alerts', _evaluationAlerts, (val) {
            setState(() {
              _evaluationAlerts = val;
            });
          }),
          const SizedBox(height: 12),
          _buildToggleRow('Exam Duty Alerts', _examDutyAlerts, (val) {
            setState(() {
              _examDutyAlerts = val;
            });
          }),
          const SizedBox(height: 12),
          _buildToggleRow('System Announcements', _systemAnnouncements, (val) {
            setState(() {
              _systemAnnouncements = val;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildAppPreferencesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APP PREFERENCES',
            style: TeacherTextStyles.sectionTitleColored(TeacherColors.primaryButton),
          ),
          const SizedBox(height: 16),
          
          _buildDropdownField('Theme', _theme, ['Light', 'Dark', 'System'], (val) {
            setState(() {
              _theme = val!;
            });
          }),
          const SizedBox(height: 12),
          _buildDropdownField('Default Landing Page', _defaultLandingPage, 
            ['Dashboard', 'Classes', 'Evaluation', 'Insights'], (val) {
            setState(() {
              _defaultLandingPage = val!;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildActivityInformationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVITY INFORMATION',
            style: TeacherTextStyles.sectionTitleColored(TeacherColors.primaryButton),
          ),
          const SizedBox(height: 16),
          
          _buildActivityRow('Last Attendance Submitted', '2 hours ago'),
          const SizedBox(height: 12),
          _buildActivityRow('Last Marks Submission', '1 day ago'),
          const SizedBox(height: 12),
          _buildActivityRow('Last Login', '5 minutes ago'),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TeacherTextStyles.bodyText,
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TeacherColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: TeacherColors.labelText,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: TeacherDecorations.inputField,
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TeacherColors.primaryText,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: TeacherColors.labelText,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: TeacherDecorations.inputField,
          child: TextField(
            controller: controller,
            obscureText: true,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TeacherColors.primaryText,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TeacherTextStyles.bodyText,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: TeacherColors.toggleActive,
          inactiveThumbColor: TeacherColors.toggleInactive,
          inactiveTrackColor: TeacherColors.toggleTrack,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: TeacherColors.labelText,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: TeacherDecorations.inputField,
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: TeacherColors.primaryButton),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TeacherColors.primaryText,
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, {bool isSecondary = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSecondary ? TeacherColors.secondaryButtonBg : TeacherColors.primaryButton,
          borderRadius: BorderRadius.circular(12),
          border: isSecondary ? Border.all(color: TeacherColors.divider) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSecondary ? TeacherColors.iconGray : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: TeacherColors.dangerButton,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: TeacherColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TeacherColors.divider),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                size: 48,
                color: TeacherColors.errorColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TeacherColors.secondaryText,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: TeacherColors.secondaryButtonBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: TeacherColors.divider),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: TeacherColors.iconGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close dialog
                        // Navigate to login screen and clear entire navigation stack
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherLoginScreen(),
                          ),
                          (route) => false, // Remove ALL previous routes
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: TeacherColors.dangerButton,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: TeacherColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
