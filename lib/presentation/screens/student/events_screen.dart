import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Technical',
    'Cultural',
    'Sports',
    'Workshop',
  ];

  final List<EventItem> _events = [
    EventItem(
      title: 'Tech Fest 2025',
      category: 'Technical',
      date: '20 Dec 2025',
      time: '09:00 AM - 05:00 PM',
      location: 'Main Campus',
      description: '24-hour hackathon with amazing prizes',
      participants: 150,
      status: 'Upcoming',
    ),
    EventItem(
      title: 'Cultural Night',
      category: 'Cultural',
      date: '22 Dec 2025',
      time: '06:00 PM - 09:00 PM',
      location: 'Auditorium',
      description: 'Annual cultural celebration with performances',
      participants: 200,
      status: 'Upcoming',
    ),
    EventItem(
      title: 'AI Workshop',
      category: 'Workshop',
      date: '15 Dec 2025',
      time: '02:00 PM - 04:00 PM',
      location: 'Seminar Hall',
      description: 'Hands-on AI & ML workshop by industry experts',
      participants: 80,
      status: 'Registrations Open',
    ),
    EventItem(
      title: 'Inter-College Cricket',
      category: 'Sports',
      date: '18 Dec 2025',
      time: '08:00 AM - 05:00 PM',
      location: 'Sports Ground',
      description: 'Inter-college cricket tournament',
      participants: 120,
      status: 'Upcoming',
    ),
  ];

  List<EventItem> get _filteredEvents {
    if (_selectedFilter == 'All') {
      return _events;
    }
    return _events.where((e) => e.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Events',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE91E63)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE91E63)
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Text(
                          filter,
                          style: GoogleFonts.inter(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF757575),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Events list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _filteredEvents.map((event) {
                return _buildEventCard(event);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventItem event) {
    Color categoryColor;
    IconData categoryIcon;

    switch (event.category) {
      case 'Technical':
        categoryColor = const Color(0xFF4A90E2);
        categoryIcon = Icons.computer;
        break;
      case 'Cultural':
        categoryColor = const Color(0xFFE91E63);
        categoryIcon = Icons.music_note;
        break;
      case 'Sports':
        categoryColor = const Color(0xFF4CAF50);
        categoryIcon = Icons.sports_cricket;
        break;
      case 'Workshop':
        categoryColor = const Color(0xFFFF9800);
        categoryIcon = Icons.school;
        break;
      default:
        categoryColor = const Color(0xFF9E9E9E);
        categoryIcon = Icons.event;
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _buildEventDetails(event, categoryColor, categoryIcon),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: categoryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          event.category,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event.status,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  event.date,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time,
                    size: 14, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  event.time,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  event.location,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 14, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  '${event.participants} participants',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails(EventItem event, Color categoryColor, IconData categoryIcon) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: categoryColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Text(
                      event.category,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow(Icons.calendar_today, 'Date', event.date),
          _buildDetailRow(Icons.access_time, 'Time', event.time),
          _buildDetailRow(Icons.location_on, 'Location', event.location),
          _buildDetailRow(Icons.people, 'Participants', '${event.participants} registered'),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registered for ${event.title}',
                        style: GoogleFonts.inter()),
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Register Now',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF757575)),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventItem {
  final String title;
  final String category;
  final String date;
  final String time;
  final String location;
  final String description;
  final int participants;
  final String status;

  EventItem({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.participants,
    required this.status,
  });
}

