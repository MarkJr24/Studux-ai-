import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme.dart';
import 'student_profile_screen.dart';
import 'exam_schedule_screen.dart';
import 'hall_ticket_screen.dart';
import 'seating_information_screen.dart';
import 'marks_results_screen.dart';
import 'exam_guidelines_screen.dart';
import 'exam_history_screen.dart';

class StudentExamsScreen extends StatefulWidget {
  const StudentExamsScreen({super.key});

  @override
  State<StudentExamsScreen> createState() => _StudentExamsScreenState();
}

class _StudentExamsScreenState extends State<StudentExamsScreen> {
  // Mock data - Replace with actual API calls
  final bool _hasExamToday = true;
  final String _todayExamSubject = 'Data Structures';
  final String _todayExamType = 'CIA';
  final String _todayExamTime = '10:00 AM – 01:00 PM';
  final DateTime _examStartTime = DateTime.now().add(const Duration(hours: 2, minutes: 15));
  
  final bool _hallTicketReleased = true;
  final bool _seatingPublished = true;
  final bool _resultsAvailable = true;

  Timer? _countdownTimer;
  Duration _timeUntilExam = const Duration();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    setState(() {
      _timeUntilExam = _examStartTime.difference(DateTime.now());
    });
  }

  String _formatCountdown() {
    final hours = _timeUntilExam.inHours;
    final minutes = _timeUntilExam.inMinutes % 60;
    return 'Starts in $hours hours $minutes minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExamOverview(),
          const SizedBox(height: 24),
          _buildExamActions(),
          const SizedBox(height: 24),
          _buildQuickStatus(),
          const SizedBox(height: 80), // Bottom nav spacing
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exams',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Exam schedules, hall tickets & results',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentProfileScreen()),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D50A9), // Dark Blue
                    Color(0xFF8FFEB0), // Cyan/Mint
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamOverview() {
    if (_hasExamToday) {
      return _buildTodayExamCard();
    } else {
      return _buildNoExamCard();
    }
  }

  Widget _buildTodayExamCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'EXAM OVERVIEW',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              const Text('🎯', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Today\'s Exam: $_todayExamSubject',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _todayExamType,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Time: $_todayExamTime',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Status: Upcoming',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatCountdown(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoExamCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'EXAM OVERVIEW',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              const Text('✅', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'No exams scheduled for today',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Next Exam: Operating Systems',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Date: Dec 15, 2025 | 10:00 AM',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXAM ACTIONS',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.calendar_today,
          iconColor: Colors.blue,
          title: 'Exam Schedule',
          subtitle: 'View upcoming & past exams',
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExamScheduleScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.confirmation_number,
          iconColor: Colors.purple,
          title: 'Hall Ticket',
          subtitle: _hallTicketReleased
              ? 'Download your hall ticket'
              : 'Not released yet',
          enabled: _hallTicketReleased,
          statusBadge: _hallTicketReleased ? '✅' : '🔒',
          onTap: _hallTicketReleased
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HallTicketScreen()),
                  );
                }
              : null,
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.event_seat,
          iconColor: Colors.orange,
          title: 'Seating Information',
          subtitle: _seatingPublished
              ? 'View your seat allocation'
              : 'Not available yet',
          enabled: _seatingPublished,
          statusBadge: _seatingPublished ? '✅' : '🔒',
          onTap: _seatingPublished
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SeatingInformationScreen()),
                  );
                }
              : null,
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.assessment,
          iconColor: Colors.green,
          title: 'Marks / Results',
          subtitle: 'View your exam results',
          enabled: true,
          badge: _resultsAvailable ? 'New' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarksResultsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.info_outline,
          iconColor: Colors.teal,
          title: 'Exam Guidelines',
          subtitle: 'Important exam instructions',
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExamGuidelinesScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          icon: Icons.history,
          iconColor: Colors.indigo,
          title: 'Exam History',
          subtitle: 'View past exam records',
          enabled: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExamHistoryScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool enabled,
    String? statusBadge,
    String? badge,
    VoidCallback? onTap,
  }) {
    return _AnimatedActionCard(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      statusBadge: statusBadge,
      badge: badge,
      onTap: onTap,
    );
  }

  Widget _buildQuickStatus() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[100]!, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'QUICK STATUS',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.touch_app,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            icon: Icons.confirmation_number,
            label: 'Hall Ticket',
            status: _hallTicketReleased ? 'Released' : 'Not Released',
            isAvailable: _hallTicketReleased,
            onTap: () {
              if (_hallTicketReleased) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HallTicketScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Hall ticket will be available soon',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _buildStatusItem(
            icon: Icons.event_seat,
            label: 'Seating',
            status: _seatingPublished ? 'Published' : 'Not Available',
            isAvailable: _seatingPublished,
            onTap: () {
              if (_seatingPublished) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeatingInformationScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Seating information will be available soon',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _buildStatusItem(
            icon: Icons.assessment,
            label: 'Results',
            status: _resultsAvailable ? 'Announced' : 'Not Announced',
            isAvailable: _resultsAvailable,
            onTap: () {
              if (_resultsAvailable) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarksResultsScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Results will be announced soon',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String status,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: isAvailable ? Colors.green : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Icon(
              isAvailable ? Icons.check_circle : Icons.cancel,
              color: isAvailable ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '$label: ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isAvailable ? Colors.grey[700] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (isAvailable)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Animated Action Card Widget
class _AnimatedActionCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool enabled;
  final String? statusBadge;
  final String? badge;
  final VoidCallback? onTap;

  const _AnimatedActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.statusBadge,
    this.badge,
    this.onTap,
  });

  @override
  State<_AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<_AnimatedActionCard> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _scaleController;
  late Animation<double> _shimmerAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    
    // Shimmer animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.enabled) {
      _shimmerController.repeat();
    }
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(_shimmerController);
    
    // Scale animation for tap
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return [
      hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor(),
      baseColor,
      hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor(),
    ];
  }

  void _handleTap() {
    if (widget.enabled && widget.onTap != null) {
      _scaleController.forward().then((_) => _scaleController.reverse());
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors(widget.iconColor);

    return ScaleTransition(
      scale: _scaleAnim,
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              onTapDown: widget.enabled ? (_) => _scaleController.forward() : null,
              onTapUp: widget.enabled ? (_) => _scaleController.reverse() : null,
              onTapCancel: widget.enabled ? () => _scaleController.reverse() : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Gradient icon container with shimmer
                    AnimatedBuilder(
                      animation: _shimmerAnim,
                      builder: (context, child) {
                        return Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: widget.enabled
                                ? [
                                    BoxShadow(
                                      color: widget.iconColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Stack(
                            children: [
                              // Shimmer overlay
                              if (widget.enabled)
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Transform.translate(
                                      offset: Offset(_shimmerAnim.value * 60, 0),
                                      child: Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withOpacity(0.3),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Icon
                              Center(
                                child: Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 24,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.statusBadge != null)
                      Text(widget.statusBadge!, style: const TextStyle(fontSize: 20)),
                    if (widget.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.badge!,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (widget.enabled) const SizedBox(width: 8),
                    if (widget.enabled)
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

