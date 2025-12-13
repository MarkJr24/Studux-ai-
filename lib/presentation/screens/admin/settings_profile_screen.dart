import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_design_system.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  // Settings state
  bool qrAttendance = true;
  int qrValidityDuration = 15;
  bool autoHallAllocation = false;
  bool showExamClashWarnings = true;
  bool showVenueCapacityWarnings = true;
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool criticalAlertsOnly = false;
  
  bool hasUnsavedChanges = false;

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
                    // SECTION 1: Exam Configuration
                    _buildExamConfiguration(),
                    const SizedBox(height: 20),
                    
                    // SECTION 2: Seating Rules (Reference)
                    _buildSeatingRules(),
                    const SizedBox(height: 20),
                    
                    // SECTION 3: Event Approval Rules
                    _buildEventApprovalRules(),
                    const SizedBox(height: 20),
                    
                    // SECTION 4: Notification Settings
                    _buildNotificationSettings(),
                    const SizedBox(height: 80),
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
          
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'System Settings',
                  style: AppTextStyles.pageTitleColored(AppColors.settingsAccent),
                ),
                const SizedBox(height: 2),
                Text(
                  'Configure system preferences',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.labelText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamConfiguration() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.settingsSectionCard(
        backgroundColor: AppColors.examConfigBg,
        borderColor: AppColors.examConfigBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXAM CONFIGURATION',
            style: AppTextStyles.sectionTitleColored(AppColors.examConfigText),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchRow(
            'QR Code Attendance',
            qrAttendance,
            (val) => setState(() => qrAttendance = val),
          ),
          const Divider(height: 24),
          
          // QR Duration Input
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QR Validity Duration',
                style: AppTextStyles.labelText,
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: AppDecorations.inputField,
                    child: IconButton(
                      onPressed: () {
                        if (qrValidityDuration > 5) {
                          setState(() => qrValidityDuration--);
                        }
                      },
                      icon: Icon(Icons.remove, size: 16, color: AppColors.iconGray),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: AppDecorations.inputField,
                    child: Center(
                      child: Text(
                        '$qrValidityDuration min',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: AppDecorations.inputField,
                    child: IconButton(
                      onPressed: () {
                        if (qrValidityDuration < 60) {
                          setState(() => qrValidityDuration++);
                        }
                      },
                      icon: Icon(Icons.add, size: 16, color: AppColors.iconGray),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          
          _buildSwitchRow(
            'Auto Hall Allocation',
            autoHallAllocation,
            (val) => setState(() => autoHallAllocation = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatingRules() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.settingsSectionCard(
        backgroundColor: AppColors.seatingRulesBg,
        borderColor: AppColors.seatingRulesBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SEATING RULES',
                style: AppTextStyles.sectionTitleColored(AppColors.seatingRulesText),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.lock,
                size: 14,
                color: AppColors.secondaryText,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildReadOnlyRow('Same Dept in Same Row', 'Enabled'),
          const Divider(height: 20),
          _buildReadOnlyRow('Alternate Roll Numbers', 'Enabled'),
          const Divider(height: 20),
          _buildReadOnlyRow('Buffer Seat Policy', '1 empty seat'),
        ],
      ),
    );
  }

  Widget _buildEventApprovalRules() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.settingsSectionCard(
        backgroundColor: AppColors.eventRulesBg,
        borderColor: AppColors.eventRulesBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EVENT APPROVAL RULES',
            style: AppTextStyles.sectionTitleColored(AppColors.eventRulesText),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchRow(
            'Show Exam Clash Warnings',
            showExamClashWarnings,
            (val) => setState(() => showExamClashWarnings = val),
          ),
          const Divider(height: 24),
          
          _buildSwitchRow(
            'Show Venue Capacity Warnings',
            showVenueCapacityWarnings,
            (val) => setState(() => showVenueCapacityWarnings = val),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.settingsSectionCard(
        backgroundColor: AppColors.notificationSettingsBg,
        borderColor: AppColors.notificationSettingsBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICATION SETTINGS',
            style: AppTextStyles.sectionTitleColored(AppColors.notificationSettingsText),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchRow(
            'Push Notifications',
            pushNotifications,
            (val) => setState(() => pushNotifications = val),
          ),
          const Divider(height: 24),
          
          _buildSwitchRow(
            'Email Notifications',
            emailNotifications,
            (val) => setState(() => emailNotifications = val),
          ),
          const Divider(height: 24),
          
          _buildSwitchRow(
            'Critical Alerts Only',
            criticalAlertsOnly,
            (val) => setState(() => criticalAlertsOnly = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
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

  Widget _buildReadOnlyRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
