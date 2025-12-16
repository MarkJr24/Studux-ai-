import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordResetScreen extends StatefulWidget {
  final String userType; // 'admin', 'student', or 'teacher'
  final String email;
  final String otp;

  const ForgotPasswordResetScreen({
    super.key,
    required this.userType,
    required this.email,
    required this.otp,
  });

  @override
  State<ForgotPasswordResetScreen> createState() =>
      _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Color get _themeColor {
    switch (widget.userType) {
      case 'admin':
        return const Color(0xFF6366F1); // Indigo
      case 'student':
        return const Color(0xFF3B82F6); // Blue
      case 'teacher':
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String get _userTypeDisplay {
    return widget.userType[0].toUpperCase() + widget.userType.substring(1);
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/forgot-password/reset'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'email': widget.email,
      //     'otp': widget.otp,
      //     'newPassword': _newPasswordController.text,
      //     'userType': widget.userType,
      //   }),
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success response
      // if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to login screen (pop all forgot password screens)
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      // } else {
      //   throw Exception('Failed to reset password');
      // }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Reset Password',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Create a new password for your account. Make sure it\'s strong and secure.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Password Requirements Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _themeColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _themeColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: _themeColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Password Requirements',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _themeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildRequirement('At least 8 characters'),
                        _buildRequirement('Include uppercase and lowercase'),
                        _buildRequirement('Include numbers'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // New Password Field
                  Text(
                    'New Password',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    enabled: !_isLoading,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0xFF9CA3AF),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: _themeColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _themeColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain uppercase letters';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain lowercase letters';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain numbers';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Confirm Password Field
                  Text(
                    'Confirm Password',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    enabled: !_isLoading,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Confirm new password',
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0xFF9CA3AF),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: _themeColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _themeColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _themeColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _themeColor.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  'Reset Password',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: _themeColor.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

