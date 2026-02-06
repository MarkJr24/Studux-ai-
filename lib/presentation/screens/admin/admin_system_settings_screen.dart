import 'package:flutter/material.dart';
import '../../../core/navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_design_system.dart';

class AdminSystemSettingsScreen extends StatefulWidget {
  const AdminSystemSettingsScreen({super.key});

  @override
  State<AdminSystemSettingsScreen> createState() =>
      _AdminSystemSettingsScreenState();
}

class _AdminSystemSettingsScreenState extends State<AdminSystemSettingsScreen> {
  // Seating Rules
  bool _sameDeptInSameRow = true;
  bool _alternateRollNumbers = true;
  String _bufferSeatPolicy = '1 empty seat';

  // Event Approval Rules
  bool _showExamClashWarnings = true;
  bool _showVenueCapacityWarnings = true;

  // Notification Settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _criticalAlertsOnly = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => LogoutHandler.handleBackToLogin(context),
      child: Scaffold(
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
                      _buildSeatingRules(),
                      const SizedBox(height: 20),
                      _buildEventApprovalRules(),
                      const SizedBox(height: 20),
                      _buildNotificationSettings(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.backButtonBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => LogoutHandler.handleBackToLogin(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              color: AppColors.iconGray,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'System Settings',
                  style: AppTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Configure system preferences',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatingRules() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.pendingSeatingBg,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.pendingSeatingAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock,
                size: 16,
                color: AppColors.pendingSeatingAccent,
              ),
              const SizedBox(width: 8),
              Text(
                'SEATING RULES',
                style: AppTextStyles.sectionTitleColored(
                  AppColors.pendingSeatingAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingRow(
            'Same Dept in Same Row',
            _sameDeptInSameRow,
            (value) => setState(() => _sameDeptInSameRow = value),
          ),
          const SizedBox(height: 12),
          _buildSettingRow(
            'Alternate Roll Numbers',
            _alternateRollNumbers,
            (value) => setState(() => _alternateRollNumbers = value),
          ),
          const SizedBox(height: 16),
          Text(
            'Buffer Seat Policy',
            style: AppTextStyles.labelText,
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            _bufferSeatPolicy,
            ['1 empty seat', '2 empty seats', 'No buffer'],
            (value) => setState(() => _bufferSeatPolicy = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildEventApprovalRules() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warningColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EVENT APPROVAL RULES',
            style: AppTextStyles.sectionTitleColored(AppColors.warningDark),
          ),
          const SizedBox(height: 16),
          _buildSettingRow(
            'Show Exam Clash Warnings',
            _showExamClashWarnings,
            (value) => setState(() => _showExamClashWarnings = value),
          ),
          const SizedBox(height: 12),
          _buildSettingRow(
            'Show Venue Capacity Warnings',
            _showVenueCapacityWarnings,
            (value) => setState(() => _showVenueCapacityWarnings = value),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.infoDark.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICATION SETTINGS',
            style: AppTextStyles.sectionTitleColored(AppColors.infoDark),
          ),
          const SizedBox(height: 16),
          _buildSettingRow(
            'Push Notifications',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
          const SizedBox(height: 12),
          _buildSettingRow(
            'Email Notifications',
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
          ),
          const SizedBox(height: 12),
          _buildSettingRow(
            'Critical Alerts Only',
            _criticalAlertsOnly,
            (value) => setState(() => _criticalAlertsOnly = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelText,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: value ? AppColors.successBg : AppColors.errorBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value ? 'Enabled' : 'Disabled',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: value ? AppColors.successDark : AppColors.errorDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.toggleActive,
            inactiveTrackColor: AppColors.toggleTrack,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.background,
          style: GoogleFonts.inter(
            color: AppColors.primaryText,
            fontSize: 14,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primaryButton,
          ),
          isExpanded: true,
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
