import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AcademicCalendarScreen extends StatefulWidget {
  const AcademicCalendarScreen({super.key});

  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  Set<String> _selectedFilters = {'all'};
  bool _showUpcoming = true;

  final Map<String, EventTypeFilter> _eventTypes = {
    'exam': EventTypeFilter(
      name: 'Exams',
      icon: '📝',
      color: const Color(0xFFEF5350),
    ),
    'cia': EventTypeFilter(
      name: 'CIA',
      icon: '🎓',
      color: const Color(0xFF66BB6A),
    ),
    'event': EventTypeFilter(
      name: 'Events',
      icon: '🎉',
      color: const Color(0xFF42A5F5),
    ),
    'holiday': EventTypeFilter(
      name: 'Holidays',
      icon: '📚',
      color: const Color(0xFFFFCA28),
    ),
    'other': EventTypeFilter(
      name: 'Other',
      icon: '📌',
      color: const Color(0xFFFFA726),
    ),
  };

  // Mock event data
  final Map<String, List<CalendarEvent>> _events = {
    '2025-09-10': [
      CalendarEvent(
        title: 'Data Structures CIA',
        type: 'exam',
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        location: 'Hall A, B',
        description: 'CIA-1 examination for Data Structures course',
      ),
      CalendarEvent(
        title: 'Guest Lecture',
        type: 'event',
        startTime: '02:00 PM',
        endTime: '04:00 PM',
        location: 'Seminar Hall',
        description: 'Industry expert talk on AI/ML trends',
      ),
    ],
    '2025-09-12': [
      CalendarEvent(
        title: 'DBMS Exam',
        type: 'exam',
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        location: 'Hall C, D',
        description: 'CIA-1 examination for DBMS course',
      ),
    ],
    '2025-09-15': [
      CalendarEvent(
        title: 'Independence Day',
        type: 'holiday',
        startTime: 'All Day',
        endTime: '',
        location: 'National Holiday',
        description: 'Campus closed for Independence Day celebration',
      ),
    ],
    '2025-09-17': [
      CalendarEvent(
        title: 'Operating Systems CIA',
        type: 'cia',
        startTime: '02:00 PM',
        endTime: '04:00 PM',
        location: 'Lab 1, Lab 2',
        description: 'Continuous Internal Assessment',
      ),
    ],
    '2025-09-18': [
      CalendarEvent(
        title: 'Sports Day',
        type: 'event',
        startTime: '09:00 AM',
        endTime: '05:00 PM',
        location: 'Sports Complex',
        description: 'Annual inter-department sports meet',
      ),
    ],
    '2025-09-24': [
      CalendarEvent(
        title: 'Computer Networks Exam',
        type: 'exam',
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        location: 'Hall A, B, C',
        description: 'CIA-1 examination for Computer Networks',
      ),
    ],
  };

  List<CalendarEvent> _getEventsForDate(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final events = _events[dateKey] ?? [];
    
    if (_selectedFilters.contains('all')) {
      return events;
    }
    
    return events.where((event) => _selectedFilters.contains(event.type)).toList();
  }

  List<CalendarEvent> _getUpcomingEvents() {
    final List<CalendarEvent> upcoming = [];
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final events = _getEventsForDate(date);
      for (var event in events) {
        upcoming.add(event.copyWithDate(date));
      }
    }
    
    upcoming.sort((a, b) => a.date!.compareTo(b.date!));
    return upcoming.take(5).toList();
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (filter == 'all') {
        _selectedFilters = {'all'};
      } else {
        _selectedFilters.remove('all');
        if (_selectedFilters.contains(filter)) {
          _selectedFilters.remove(filter);
          if (_selectedFilters.isEmpty) {
            _selectedFilters.add('all');
          }
        } else {
          _selectedFilters.add(filter);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMonthSelector(),
          const SizedBox(height: 16),
          _buildEventFilters(),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
          const SizedBox(height: 24),
          _buildSelectedDateEvents(),
          const SizedBox(height: 24),
          _buildUpcomingEvents(),
          const SizedBox(height: 80), // Bottom nav spacing
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Academic Calendar',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF212121)),
          onPressed: () {
            // Search functionality
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Color(0xFF212121)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {
            if (value == 'today') {
              setState(() {
                _selectedDate = DateTime.now();
                _focusedMonth = DateTime.now();
              });
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'today',
              child: Row(
                children: [
                  const Icon(Icons.today, size: 20, color: Color(0xFF757575)),
                  const SizedBox(width: 12),
                  Text('Today', style: GoogleFonts.inter()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  const Icon(Icons.file_download, size: 20, color: Color(0xFF757575)),
                  const SizedBox(width: 12),
                  Text('Export calendar', style: GoogleFonts.inter()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _focusedMonth = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month - 1,
                );
              });
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(_focusedMonth),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _focusedMonth = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventFilters() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._eventTypes.entries.map((entry) {
            final isSelected = _selectedFilters.contains(entry.key);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                entry.value.icon,
                entry.value.name,
                entry.value.color,
                isSelected,
                () => _toggleFilter(entry.key),
              ),
            );
          }),
          _buildFilterChip(
            '📋',
            'All',
            const Color(0xFF4A90E2),
            _selectedFilters.contains('all'),
            () => _toggleFilter('all'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String icon,
    String label,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((day) => SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          // Calendar dates
          ...List.generate(6, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (dayIndex) {
                  final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox(width: 40, height: 50);
                  }
                  
                  final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
                  return _buildCalendarDay(date);
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(DateTime date) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = _isSameDay(date, _selectedDate);
    final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    final events = _getEventsForDate(date);
    final hasEvents = events.isNotEmpty;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 40,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFFE3F2FD) : Colors.transparent,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: const Color(0xFF4A90E2), width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isPast ? const Color(0xFFBDBDBD) : const Color(0xFF212121),
                  ),
                ),
              ),
            ),
            if (hasEvents)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.take(3).map((event) {
                  final color = _eventTypes[event.type]?.color ?? Colors.grey;
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateEvents() {
    final events = _getEventsForDate(_selectedDate);
    final dateStr = DateFormat('d MMMM yyyy').format(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EVENTS ON ${dateStr.toUpperCase()}',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF757575),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const Icon(
                    Icons.event_available,
                    size: 48,
                    color: Color(0xFFBDBDBD),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No events scheduled',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...events.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildEventCard(event),
              )),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    final eventType = _eventTypes[event.type];
    final color = eventType?.color ?? Colors.grey;

    return GestureDetector(
      onTap: () => _showEventDetails(event),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  eventType?.icon ?? '📌',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Color(0xFF757575)),
                const SizedBox(width: 6),
                Text(
                  event.endTime.isEmpty
                      ? event.startTime
                      : '${event.startTime} - ${event.endTime}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF757575)),
                const SizedBox(width: 6),
                Text(
                  event.location,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    if (!_showUpcoming) return const SizedBox.shrink();
    
    final upcoming = _getUpcomingEvents();
    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showUpcoming = !_showUpcoming;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'UPCOMING THIS WEEK',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF757575),
                  letterSpacing: 1.2,
                ),
              ),
              Icon(
                _showUpcoming ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF757575),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: upcoming.map((event) {
              final color = _eventTypes[event.type]?.color ?? Colors.grey;
              final dateStr = event.date != null
                  ? DateFormat('d MMM').format(event.date!)
                  : '';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = event.date ?? DateTime.now();
                      _focusedMonth = event.date ?? DateTime.now();
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        dateStr,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ':',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showEventDetails(CalendarEvent event) {
    final eventType = _eventTypes[event.type];
    final color = eventType?.color ?? Colors.grey;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  eventType?.icon ?? '📌',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event.title,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color),
              ),
              child: Text(
                eventType?.name ?? 'Event',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              Icons.access_time,
              'Time',
              event.endTime.isEmpty
                  ? event.startTime
                  : '${event.startTime} - ${event.endTime}',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.location_on, 'Location', event.location),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailRow(Icons.description, 'Description', event.description),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to phone calendar',
                              style: GoogleFonts.inter()),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text('Add to Calendar', style: GoogleFonts.inter()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: Text('Close', style: GoogleFonts.inter()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF757575),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF757575)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class EventTypeFilter {
  final String name;
  final String icon;
  final Color color;

  EventTypeFilter({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CalendarEvent {
  final String title;
  final String type;
  final String startTime;
  final String endTime;
  final String location;
  final String description;
  final DateTime? date;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.description,
    this.date,
  });

  CalendarEvent copyWithDate(DateTime newDate) {
    return CalendarEvent(
      title: title,
      type: type,
      startTime: startTime,
      endTime: endTime,
      location: location,
      description: description,
      date: newDate,
    );
  }
}

