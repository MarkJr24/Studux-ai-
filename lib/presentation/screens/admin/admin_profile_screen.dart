import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_design_system.dart';
import '../../core/navigation_service.dart';
import '../auth/admin_login_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  // Profile state
  bool isEditingProfile = false;
  bool isChangingPassword = false;
  
  // Profile fields
  String fullName = 'Dr. Rajesh Kumar';
  String adminId = 'ADM001';
  String email = 'rajesh.kumar@college.edu';
  String phone = '+91 98765 43210';
  String role = 'Admin';
  String accountStatus = 'Active';
  
  // Preferences
  String theme = 'Light';
  String defaultLandingPage = 'Dashboard';
  bool notificationPreview = true;
  
  // Password fields
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION 1: Profile Information
                    _buildProfileInformation(),
                    const SizedBox(height: 20),
                    
                    // SECTION 2: Account Security
                    _buildAccountSecurity(),
                    const SizedBox(height: 20),
                    
                    // SECTION 3: Access & Role Summary
                    _buildAccessRoleSummary(),
                    const SizedBox(height: 20),
                    
                    // SECTION 4: Preferences
                    _buildPreferences(),
                    const SizedBox(height: 20),
                    
                    // SECTION 5: Logout
                    _buildLogout(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
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
              color: AppColors.iconGray,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Admin Profile',
                  style: AppTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your account and preferences',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),

          // Quick logout action
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.errorBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'Logout',
              onPressed: _showLogoutConfirmation,
              icon: const Icon(Icons.logout, size: 20, color: AppColors.errorDark),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 1: Profile Information
  Widget _buildProfileInformation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROFILE INFORMATION',
            style: AppTextStyles.sectionTitleColored(AppColors.infoDark),
          ),
          const SizedBox(height: 16),
          
          if (!isEditingProfile) ...[
            _buildReadOnlyField('Full Name', fullName),
            const SizedBox(height: 12),
            _buildReadOnlyField('Admin ID', adminId),
            const SizedBox(height: 12),
            _buildReadOnlyField('Email Address', email),
            const SizedBox(height: 12),
            _buildReadOnlyField('Phone Number', phone),
            const SizedBox(height: 12),
            _buildReadOnlyField('Role', role),
            const SizedBox(height: 12),
            _buildReadOnlyField('Account Status', accountStatus),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => isEditingProfile = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ] else ...[
            _buildEditableField('Full Name', fullName),
            const SizedBox(height: 12),
            _buildReadOnlyField('Admin ID', adminId),
            const SizedBox(height: 12),
            _buildEditableField('Email Address', email),
            const SizedBox(height: 12),
            _buildEditableField('Phone Number', phone),
            const SizedBox(height: 12),
            _buildReadOnlyField('Role', role),
            const SizedBox(height: 12),
            _buildReadOnlyField('Account Status', accountStatus),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => isEditingProfile = false);
                      _showSuccessToast('Profile updated successfully');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isEditingProfile = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryButtonBg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.buttonTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // SECTION 2: Account Security
  Widget _buildAccountSecurity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT SECURITY',
            style: AppTextStyles.sectionTitleColored(AppColors.warningDark),
          ),
          const SizedBox(height: 16),
          
          if (!isChangingPassword) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => isChangingPassword = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryButtonBg,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 18, color: AppColors.iconGray),
                    const SizedBox(width: 8),
                    Text(
                      'Change Password',
                      style: AppTextStyles.buttonTextSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            _buildPasswordField('Current Password', currentPasswordController),
            const SizedBox(height: 12),
            _buildPasswordField('New Password', newPasswordController),
            const SizedBox(height: 12),
            _buildPasswordField('Confirm New Password', confirmPasswordController),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isChangingPassword = false;
                    currentPasswordController.clear();
                    newPasswordController.clear();
                    confirmPasswordController.clear();
                  });
                  _showSuccessToast('Password updated successfully');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Update Password',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // SECTION 3: Access & Role Summary
  Widget _buildAccessRoleSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ACCESS & ROLE SUMMARY',
                style: AppTextStyles.sectionTitleColored(AppColors.settingsAccent),
              ),
              const SizedBox(width: 8),
              Icon(Icons.lock, size: 14, color: AppColors.secondaryText),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildReadOnlyField('Role', 'Admin'),
          const SizedBox(height: 12),
          _buildReadOnlyField('Access Level', 'Full System Access'),
          const SizedBox(height: 12),
          
          Text(
            'Permissions:',
            style: AppTextStyles.labelText,
          ),
          const SizedBox(height: 8),
          ...[
            'Create and manage exams',
            'Allocate seating',
            'Generate attendance audits',
            'Approve events',
            'Modify system settings',
          ].map((permission) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: AppColors.successColor),
                const SizedBox(width: 8),
                Text(
                  permission,
                  style: AppTextStyles.bodyText,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // SECTION 4: Preferences
  Widget _buildPreferences() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENCES',
            style: AppTextStyles.sectionTitleColored(AppColors.primaryButton),
          ),
          const SizedBox(height: 16),
          
          _buildDropdownField('Theme', theme, ['Light', 'Dark'], (value) {
            setState(() => theme = value!);
          }),
          const SizedBox(height: 12),
          
          _buildDropdownField('Default Landing Page', defaultLandingPage, ['Dashboard', 'Seating'], (value) {
            setState(() => defaultLandingPage = value!);
          }),
          const SizedBox(height: 12),
          
          _buildToggleRow('Notification Preview', notificationPreview, (value) {
            setState(() => notificationPreview = value);
          }),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showSuccessToast('Preferences saved'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save Preferences',
                style: AppTextStyles.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 5: Logout
  Widget _buildLogout() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOGOUT',
            style: AppTextStyles.sectionTitleColored(AppColors.errorDark),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showLogoutConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dangerButton,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: AppTextStyles.buttonText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppTextStyles.bodyText,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyTextMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: AppDecorations.inputField,
          child: TextField(
            controller: TextEditingController(text: initialValue),
            style: GoogleFonts.inter(color: AppColors.primaryText, fontSize: 14),
            decoration: const InputDecoration.collapsed(hintText: ''),
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
          style: AppTextStyles.bodyText,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: AppDecorations.inputField,
          child: TextField(
            controller: controller,
            obscureText: true,
            style: GoogleFonts.inter(color: AppColors.primaryText, fontSize: 14),
            decoration: const InputDecoration.collapsed(hintText: ''),
          ),
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
          style: AppTextStyles.bodyText,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: AppDecorations.inputField,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: AppColors.background,
              style: GoogleFonts.inter(color: AppColors.primaryText, fontSize: 14),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryButton),
              isExpanded: true,
              items: options.map((option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: onChanged,
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
          style: AppTextStyles.labelText,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.toggleActive,
          inactiveTrackColor: AppColors.toggleTrack,
        ),
      ],
    );
  }

  void _showSuccessToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.pageTitle,
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate to login screen and clear entire navigation stack
              LogoutHandler.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerButton,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
