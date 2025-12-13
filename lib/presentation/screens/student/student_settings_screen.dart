import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';

class StudentSettingsScreen extends StatefulWidget {
  const StudentSettingsScreen({super.key});

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  // Appearance Settings
  String _selectedTheme = 'Light';
  String _selectedFontSize = 'Medium';

  // Notification Settings
  bool _examAlerts = true;
  bool _academicAlerts = true;
  bool _eventAlerts = true;
  bool _feeReminders = true;
  bool _announcements = true;
  String _quietHoursFrom = '10:00 PM';
  String _quietHoursTo = '07:00 AM';

  // Privacy Settings
  bool _showProfilePhoto = true;
  bool _showActivityStatus = false;
  bool _enableChatbot = true;

  // App Behavior
  String _defaultLandingPage = 'Home';
  String _selectedLanguage = 'English';

  // Track changes
  bool _hasUnsavedChanges = false;

  // Original values for comparison
  late String _originalTheme;
  late String _originalFontSize;
  late bool _originalExamAlerts;
  late bool _originalAcademicAlerts;
  late bool _originalEventAlerts;
  late bool _originalFeeReminders;
  late bool _originalAnnouncements;
  late bool _originalShowProfilePhoto;
  late bool _originalShowActivityStatus;
  late bool _originalEnableChatbot;
  late String _originalDefaultLandingPage;
  late String _originalLanguage;

  @override
  void initState() {
    super.initState();
    _saveOriginalValues();
  }

  void _saveOriginalValues() {
    _originalTheme = _selectedTheme;
    _originalFontSize = _selectedFontSize;
    _originalExamAlerts = _examAlerts;
    _originalAcademicAlerts = _academicAlerts;
    _originalEventAlerts = _eventAlerts;
    _originalFeeReminders = _feeReminders;
    _originalAnnouncements = _announcements;
    _originalShowProfilePhoto = _showProfilePhoto;
    _originalShowActivityStatus = _showActivityStatus;
    _originalEnableChatbot = _enableChatbot;
    _originalDefaultLandingPage = _defaultLandingPage;
    _originalLanguage = _selectedLanguage;
  }

  void _checkForChanges() {
    setState(() {
      _hasUnsavedChanges = _selectedTheme != _originalTheme ||
          _selectedFontSize != _originalFontSize ||
          _examAlerts != _originalExamAlerts ||
          _academicAlerts != _originalAcademicAlerts ||
          _eventAlerts != _originalEventAlerts ||
          _feeReminders != _originalFeeReminders ||
          _announcements != _originalAnnouncements ||
          _showProfilePhoto != _originalShowProfilePhoto ||
          _showActivityStatus != _originalShowActivityStatus ||
          _enableChatbot != _originalEnableChatbot ||
          _defaultLandingPage != _originalDefaultLandingPage ||
          _selectedLanguage != _originalLanguage;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You have unsaved changes. Save before leaving?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Discard', style: GoogleFonts.inter()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              _saveChanges();
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Save', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveChanges() {
    // Save to SharedPreferences or backend
    _saveOriginalValues();
    setState(() {
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _discardChanges() {
    setState(() {
      _selectedTheme = _originalTheme;
      _selectedFontSize = _originalFontSize;
      _examAlerts = _originalExamAlerts;
      _academicAlerts = _originalAcademicAlerts;
      _eventAlerts = _originalEventAlerts;
      _feeReminders = _originalFeeReminders;
      _announcements = _originalAnnouncements;
      _showProfilePhoto = _originalShowProfilePhoto;
      _showActivityStatus = _originalShowActivityStatus;
      _enableChatbot = _originalEnableChatbot;
      _defaultLandingPage = _originalDefaultLandingPage;
      _selectedLanguage = _originalLanguage;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes discarded'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAppearanceSection(),
                  const SizedBox(height: 20),
                  _buildNotificationsSection(),
                  const SizedBox(height: 20),
                  _buildPrivacySection(),
                  const SizedBox(height: 20),
                  _buildAppBehaviorSection(),
                  const SizedBox(height: 20),
                  _buildSupportSection(),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
            if (_hasUnsavedChanges) _buildStickyBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () async {
          if (await _onWillPop()) {
            if (mounted) Navigator.pop(context);
          }
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Customize app appearance & preferences',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      title: 'APPEARANCE',
      children: [
        Text(
          'Theme',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Light', style: GoogleFonts.inter(fontSize: 14)),
                value: 'Light',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  _checkForChanges();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Dark', style: GoogleFonts.inter(fontSize: 14)),
                value: 'Dark',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  _checkForChanges();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('System', style: GoogleFonts.inter(fontSize: 14)),
                value: 'System',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  _checkForChanges();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Font Size',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Small', style: GoogleFonts.inter(fontSize: 12)),
                value: 'Small',
                groupValue: _selectedFontSize,
                onChanged: (value) {
                  setState(() {
                    _selectedFontSize = value!;
                  });
                  _checkForChanges();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Medium', style: GoogleFonts.inter(fontSize: 14)),
                value: 'Medium',
                groupValue: _selectedFontSize,
                onChanged: (value) {
                  setState(() {
                    _selectedFontSize = value!;
                  });
                  _checkForChanges();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Large', style: GoogleFonts.inter(fontSize: 16)),
                value: 'Large',
                groupValue: _selectedFontSize,
                onChanged: (value) {
                  setState(() {
                    _selectedFontSize = value!;
                  });
                  _checkForChanges();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: 'NOTIFICATIONS',
      children: [
        _buildSwitchTile('Exam Alerts', _examAlerts, (value) {
          setState(() => _examAlerts = value);
          _checkForChanges();
        }),
        _buildSwitchTile('Academic Alerts', _academicAlerts, (value) {
          setState(() => _academicAlerts = value);
          _checkForChanges();
        }),
        _buildSwitchTile('Event Alerts', _eventAlerts, (value) {
          setState(() => _eventAlerts = value);
          _checkForChanges();
        }),
        _buildSwitchTile('Fee Reminders', _feeReminders, (value) {
          setState(() => _feeReminders = value);
          _checkForChanges();
        }),
        _buildSwitchTile('Announcements', _announcements, (value) {
          setState(() => _announcements = value);
          _checkForChanges();
        }),
        const SizedBox(height: 16),
        Text(
          'Quiet Hours',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _quietHoursFrom,
                decoration: InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: ['10:00 PM', '11:00 PM', '12:00 AM']
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time, style: GoogleFonts.inter(fontSize: 14)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _quietHoursFrom = value!);
                  _checkForChanges();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _quietHoursTo,
                decoration: InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: ['06:00 AM', '07:00 AM', '08:00 AM']
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time, style: GoogleFonts.inter(fontSize: 14)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _quietHoursTo = value!);
                  _checkForChanges();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return _buildSection(
      title: 'PRIVACY & PERMISSIONS',
      children: [
        _buildSwitchTile('Show Profile Photo', _showProfilePhoto, (value) {
          setState(() => _showProfilePhoto = value);
          _checkForChanges();
        }),
        _buildSwitchTile('Show Activity Status', _showActivityStatus, (value) {
          setState(() => _showActivityStatus = value);
          _checkForChanges();
        }),
        _buildSwitchTile('Enable AI Chatbot', _enableChatbot, (value) {
          setState(() => _enableChatbot = value);
          _checkForChanges();
        }),
      ],
    );
  }

  Widget _buildAppBehaviorSection() {
    return _buildSection(
      title: 'APP BEHAVIOR',
      children: [
        Text(
          'Default Landing Page',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _defaultLandingPage,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: ['Home', 'Academics', 'Exams']
              .map((page) => DropdownMenuItem(
                    value: page,
                    child: Text(page, style: GoogleFonts.inter()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => _defaultLandingPage = value!);
            _checkForChanges();
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Language',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedLanguage,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: ['English', 'Hindi', 'Tamil', 'Telugu']
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang, style: GoogleFonts.inter()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => _selectedLanguage = value!);
            _checkForChanges();
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      title: 'SUPPORT & ABOUT',
      children: [
        _buildReadOnlyField('App Version', 'v1.0.0'),
        _buildReadOnlyField('College', 'XYZ College'),
        const SizedBox(height: 12),
        _buildLinkTile('Help & FAQ', Icons.help_outline, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Help & FAQ...')),
          );
        }),
        const SizedBox(height: 8),
        _buildLinkTile('Contact Support', Icons.support_agent, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Contact Support...')),
          );
        }),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkTile(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save Changes',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: _discardChanges,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Discard Changes',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
