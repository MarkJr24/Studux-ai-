import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_design_system.dart';

// Event data model
class EventRequest {
  final String id;
  final String title;
  final String organizer;
  final DateTime date;
  final String time;
  final String venue;
  final int expectedAttendees;
  final String description;
  final List<String> conflicts;
  final String status; // pending, approved, rejected

  EventRequest({
    required this.id,
    required this.title,
    required this.organizer,
    required this.date,
    required this.time,
    required this.venue,
    required this.expectedAttendees,
    required this.description,
    this.conflicts = const [],
    this.status = 'pending',
  });
}

class EventApprovalScreen extends StatefulWidget {
  const EventApprovalScreen({super.key});

  @override
  State<EventApprovalScreen> createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  List<EventRequest> pendingEvents = [];
  EventRequest? selectedEvent;

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  void _loadDemoData() {
    pendingEvents = [
      EventRequest(
        id: '1',
        title: 'Cultural Day 2024',
        organizer: 'Student Council',
        date: DateTime.now().add(const Duration(days: 15)),
        time: '10:00 AM - 4:00 PM',
        venue: 'Main Auditorium',
        expectedAttendees: 500,
        description:
            'Annual cultural festival with performances, competitions, and exhibitions.',
        conflicts: [
          'Exam clash on 15th March',
          'Main Auditorium capacity: 450'
        ],
      ),
      EventRequest(
        id: '2',
        title: 'Tech Symposium',
        organizer: 'CSE Department',
        date: DateTime.now().add(const Duration(days: 20)),
        time: '9:00 AM - 5:00 PM',
        venue: 'Seminar Hall',
        expectedAttendees: 200,
        description:
            'Technical symposium featuring guest lectures and project presentations.',
        conflicts: [],
      ),
    ];
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
              child: selectedEvent == null
                  ? _buildEventList()
                  : _buildEventDetails(),
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
              onPressed: () {
                if (selectedEvent != null) {
                  setState(() {
                    selectedEvent = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
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
                  'Event Approval',
                  style: AppTextStyles.pageTitleColored(AppColors.eventAccent),
                ),
                const SizedBox(height: 2),
                Text(
                  selectedEvent != null
                      ? 'Event Details'
                      : 'Review and approve event requests',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PENDING EVENT REQUESTS',
            style: AppTextStyles.sectionTitleColored(AppColors.eventAccent),
          ),
          const SizedBox(height: 16),
          ...pendingEvents.map((event) => _buildEventCard(event)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventRequest event) {
    final hasConflicts = event.conflicts.isNotEmpty;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEvent = event;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: _AnimatedCard(
          accentColor: AppColors.eventAccent,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTextStyles.cardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.pendingBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Pending',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pendingDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Info Rows
                _buildInfoRow(Icons.person, event.organizer),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.calendar_today,
                    '${event.date.day}/${event.date.month}/${event.date.year}'),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.access_time, event.time),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.location_on, event.venue),

                // Conflicts Warning
                if (hasConflicts) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: AppColors.warningDark,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${event.conflicts.length} conflict${event.conflicts.length > 1 ? 's' : ''} detected',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warningDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // View Details Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View Details',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.eventAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.eventAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryText),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyText,
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    if (selectedEvent == null) return const SizedBox();

    final event = selectedEvent!;
    final hasConflicts = event.conflicts.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Info Card
          _AnimatedCard(
            accentColor: AppColors.eventAccent,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Organizer', event.organizer),
                  const Divider(height: 20),
                  _buildDetailRow('Date',
                      '${event.date.day}/${event.date.month}/${event.date.year}'),
                  const Divider(height: 20),
                  _buildDetailRow('Time', event.time),
                  const Divider(height: 20),
                  _buildDetailRow('Venue', event.venue),
                  const Divider(height: 20),
                  _buildDetailRow(
                      'Expected Attendees', '${event.expectedAttendees}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description Card
          _AnimatedCard(
            accentColor: AppColors.eventAccent,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: AppTextStyles.bodyText,
                  ),
                ],
              ),
            ),
          ),

          // Conflicts Card
          if (hasConflicts) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warningColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: AppColors.warningDark,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Conflicts Detected',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warningDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...event.conflicts.map((conflict) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                color: AppColors.warningDark,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                conflict,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.warningDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: 'Reject',
                  onPressed: () {
                    _showRejectDialog();
                  },
                  decoration: AppDecorations.dangerGradientButton,
                  height: 50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  text: 'Approve',
                  onPressed: () {
                    _showApproveDialog();
                  },
                  decoration: AppDecorations.successGradientButton,
                  height: 50,
                ),
              ),
            ],
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText,
        ),
        Text(
          value,
          style: AppTextStyles.bodyTextMedium,
        ),
      ],
    );
  }

  void _showApproveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Approve Event',
          style: AppTextStyles.pageTitle,
        ),
        content: Text(
          'Are you sure you want to approve this event?',
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
              Navigator.pop(context);
              setState(() {
                pendingEvents.removeWhere((e) => e.id == selectedEvent!.id);
                selectedEvent = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event approved successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Approve',
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

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Reject Event',
          style: AppTextStyles.pageTitle,
        ),
        content: Text(
          'Are you sure you want to reject this event?',
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
              Navigator.pop(context);
              setState(() {
                pendingEvents.removeWhere((e) => e.id == selectedEvent!.id);
                selectedEvent = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event rejected')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Reject',
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

// Animated Card Widget
class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final Color accentColor;

  const _AnimatedCard({
    required this.child,
    required this.accentColor,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.accentColor.withOpacity(0.1),
            border: Border.all(
              color: widget.accentColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: AppDecorations.whiteCard,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
