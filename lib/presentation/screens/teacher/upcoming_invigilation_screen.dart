import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'teacher_design_system.dart';
import '../../widgets/invigilation_widgets.dart';

class UpcomingInvigilationScreen extends StatefulWidget {
  const UpcomingInvigilationScreen({super.key});

  @override
  State<UpcomingInvigilationScreen> createState() =>
      _UpcomingInvigilationScreenState();
}

class _UpcomingInvigilationScreenState
    extends State<UpcomingInvigilationScreen> {
  bool _isLoading = false;
  bool _isListView = true; // true = list view, false = calendar view
  String _selectedFilter = 'All';
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data - Replace with actual API data
  final List<Map<String, dynamic>> _upcomingDuties = [
    {
      'id': '1',
      'date': DateTime(2025, 12, 23),
      'time': '2:00 PM - 5:00 PM',
      'subject': 'Data Structures',
      'examType': 'CIA-2 Examination',
      'hall': 'Lab - 301',
      'students': 60,
      'status': 'Confirmed',
    },
    {
      'id': '2',
      'date': DateTime(2025, 12, 27),
      'time': '10:00 AM - 1:00 PM',
      'subject': 'Operating Systems',
      'examType': 'Semester End Exam',
      'hall': 'Exam Hall A',
      'students': 120,
      'status': 'Tentative',
    },
    {
      'id': '3',
      'date': DateTime(2025, 12, 30),
      'time': '2:00 PM - 4:00 PM',
      'subject': 'Computer Networks',
      'examType': 'CIA-2 Examination',
      'hall': 'Lab - 302',
      'students': 55,
      'status': 'Confirmed',
    },
    {
      'id': '4',
      'date': DateTime(2026, 1, 3),
      'time': '10:00 AM - 1:00 PM',
      'subject': 'Software Engineering',
      'examType': 'Semester End Exam',
      'hall': 'Exam Hall B',
      'students': 110,
      'status': 'Confirmed',
    },
  ];

  List<Map<String, dynamic>> get _filteredDuties {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'This Week':
        final endOfWeek = now.add(const Duration(days: 7));
        return _upcomingDuties
            .where((duty) =>
                duty['date'].isAfter(now) && duty['date'].isBefore(endOfWeek))
            .toList();
      case 'Next Week':
        final startOfNextWeek = now.add(const Duration(days: 7));
        final endOfNextWeek = now.add(const Duration(days: 14));
        return _upcomingDuties
            .where((duty) =>
                duty['date'].isAfter(startOfNextWeek) &&
                duty['date'].isBefore(endOfNextWeek))
            .toList();
      case 'This Month':
        return _upcomingDuties
            .where((duty) =>
                duty['date'].month == now.month &&
                duty['date'].year == now.year)
            .toList();
      default:
        return _upcomingDuties;
    }
  }

  Map<DateTime, List<Map<String, dynamic>>> get _eventsByDate {
    final events = <DateTime, List<Map<String, dynamic>>>{};
    for (var duty in _upcomingDuties) {
      final date = DateTime(
        duty['date'].year,
        duty['date'].month,
        duty['date'].day,
      );
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(duty);
    }
    return events;
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _eventsByDate[date] ?? [];
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
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TeacherSpacing.headerHorizontal,
        vertical: TeacherSpacing.headerVertical,
      ),
      decoration: const BoxDecoration(
        color: TeacherColors.background,
        border: Border(
          bottom: BorderSide(
            color: TeacherColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Upcoming Duties',
                  style: TeacherTextStyles.pageTitleColored(
                    TeacherColors.infoDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_filteredDuties.length} scheduled',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: TeacherColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
            icon: Icon(
              _isListView ? Icons.calendar_month : Icons.list,
              size: 24,
            ),
            color: TeacherColors.infoDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingStateWidget(
        message: 'Loading upcoming duties...',
      );
    }

    return Column(
      children: [
        _buildFilterBar(),
        if (_isListView) ...[
          _buildStatsCard(),
        ],
        Expanded(
          child: _isListView ? _buildListView() : _buildCalendarView(),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    final filters = ['All', 'This Week', 'Next Week', 'This Month'];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: TeacherColors.background,
        border: Border(
          bottom: BorderSide(
            color: TeacherColors.divider,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : TeacherColors.primaryText,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: TeacherColors.infoDark,
              backgroundColor: TeacherColors.secondaryBackground,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? TeacherColors.infoDark
                    : TeacherColors.cardBorder,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    final thisMonth = _upcomingDuties
        .where((duty) =>
            duty['date'].month == DateTime.now().month &&
            duty['date'].year == DateTime.now().year)
        .length;
    final next7Days = _upcomingDuties
        .where((duty) =>
            duty['date'].isAfter(DateTime.now()) &&
            duty['date']
                .isBefore(DateTime.now().add(const Duration(days: 7))))
        .length;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: TeacherDecorations.tintedCard(
        backgroundColor: TeacherColors.infoBg,
        borderColor: TeacherColors.infoDark.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                size: 20,
                color: TeacherColors.infoDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Stats',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Upcoming',
                  '${_upcomingDuties.length}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: TeacherColors.cardBorder,
              ),
              Expanded(
                child: _buildStatItem(
                  'This Month',
                  '$thisMonth',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: TeacherColors.cardBorder,
              ),
              Expanded(
                child: _buildStatItem(
                  'Next 7 Days',
                  '$next7Days',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: TeacherColors.infoDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: TeacherColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (_filteredDuties.isEmpty) {
      return EmptyStateWidget(
        emoji: '📅',
        title: 'No Upcoming Duties',
        subtitle: 'You\'ll be notified when new duties are assigned',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      color: TeacherColors.infoDark,
      child: ListView.builder(
        padding: const EdgeInsets.all(TeacherSpacing.pageHorizontal),
        itemCount: _filteredDuties.length,
        itemBuilder: (context, index) {
          final duty = _filteredDuties[index];
          return _buildDutyCard(duty);
        },
      ),
    );
  }

  Widget _buildDutyCard(Map<String, dynamic> duty) {
    final dateStr = DateFormat('EEE, d MMM yyyy').format(duty['date']);
    final statusType = duty['status'] == 'Confirmed'
        ? StatusType.confirmed
        : StatusType.tentative;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: TeacherDecorations.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TeacherColors.secondaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: TeacherColors.secondaryText,
                ),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TeacherColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 18,
                      color: TeacherColors.infoDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      duty['time'],
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: TeacherColors.infoDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  duty['subject'],
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: TeacherColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duty['examType'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: TeacherColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: TeacherColors.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duty['hall'],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: TeacherColors.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.people,
                      size: 16,
                      color: TeacherColors.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${duty['students']} Students',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: TeacherColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StatusBadge(
                      text: duty['status'],
                      type: statusType,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Navigate to details
                      },
                      child: Row(
                        children: [
                          Text(
                            'View Details',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: TeacherColors.infoDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: TeacherColors.infoDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: TeacherDecorations.whiteCard,
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: TeacherColors.infoDark.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: TeacherColors.infoDark,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: TeacherColors.invigilationColor,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TeacherColors.primaryText,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duties on ${DateFormat('d MMM yyyy').format(_selectedDay!)}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: TeacherColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._getEventsForDay(_selectedDay!).map((duty) {
                    return _buildDutyCard(duty);
                  }),
                  if (_getEventsForDay(_selectedDay!).isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: TeacherDecorations.whiteCard,
                      child: Center(
                        child: Text(
                          'No duties scheduled for this day',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: TeacherColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

