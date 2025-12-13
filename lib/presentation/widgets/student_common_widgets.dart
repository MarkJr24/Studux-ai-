
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';

/// Small pill badge for status indicators
class BadgeWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final bool isOutline;

  const BadgeWidget({
    super.key,
    required this.text,
    this.icon,
    this.color = const Color(0xFF3B82F6),
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(12),
        border: isOutline ? Border.all(color: color) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 10,
              color: isOutline ? color : Colors.white,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isOutline ? color : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Live updating countdown timer
class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;
  final TextStyle? style;

  const CountdownTimer({
    super.key,
    required this.targetTime,
    this.style,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    setState(() {
      _timeLeft = widget.targetTime.difference(DateTime.now());
      if (_timeLeft.isNegative) {
        _timeLeft = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero) {
      return Text(
        'Started',
        style: widget.style ?? GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF10B981),
        ),
      );
    }

    final hours = _timeLeft.inHours;
    final minutes = _timeLeft.inMinutes % 60;

    return Row(
      children: [
        const Icon(Icons.timer_outlined, size: 18, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          'Starts in ${hours}h ${minutes}m',
          style: widget.style ?? GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// State-aware exam action card (enabled/disabled)
class StateAwareExamActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isEnabled;
  final String? lockMessage;
  final VoidCallback onTap;

  const StateAwareExamActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isEnabled = true,
    this.lockMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled 
                ? color.withOpacity(0.3) 
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onTap : () {
              if (lockMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(lockMessage!),
                    backgroundColor: Colors.grey[800],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isEnabled 
                          ? color.withOpacity(0.1) 
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isEnabled ? icon : Icons.lock_outline,
                      color: isEnabled ? color : Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isEnabled ? AppColors.textPrimary : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEnabled ? subtitle : (lockMessage ?? subtitle),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isEnabled ? AppColors.textSecondary : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isEnabled)
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Standardized section header
class SectionHeader extends StatelessWidget {
  final String title;
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider) ...[
          Divider(color: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 16),
        ],
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
