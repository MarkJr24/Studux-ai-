import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // 0 = Monday
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  final Map<int, List<TimetableSlot>> _schedule = {
    0: [ // Monday
      TimetableSlot('09:00 AM - 10:00 AM', 'Data Structures', 'Dr. Kumar', 'Room 301'),
      TimetableSlot('10:00 AM - 11:00 AM', 'DBMS', 'Dr. Sharma', 'Room 302'),
      TimetableSlot('11:00 AM - 12:00 PM', 'Operating Systems', 'Dr. Patel', 'Lab 1'),
      TimetableSlot('12:00 PM - 01:00 PM', 'Lunch Break', '', '', isBreak: true),
      TimetableSlot('01:00 PM - 02:00 PM', 'Computer Networks', 'Dr. Singh', 'Room 303'),
      TimetableSlot('02:00 PM - 03:00 PM', 'AI & ML', 'Dr. Reddy', 'Lab 2'),
    ],
    1: [ // Tuesday
      TimetableSlot('09:00 AM - 10:00 AM', 'DBMS', 'Dr. Sharma', 'Room 302'),
      TimetableSlot('10:00 AM - 11:00 AM', 'Data Structures', 'Dr. Kumar', 'Room 301'),
      TimetableSlot('11:00 AM - 12:00 PM', 'AI & ML', 'Dr. Reddy', 'Lab 2'),
      TimetableSlot('12:00 PM - 01:00 PM', 'Lunch Break', '', '', isBreak: true),
      TimetableSlot('01:00 PM - 02:00 PM', 'Operating Systems', 'Dr. Patel', 'Lab 1'),
      TimetableSlot('02:00 PM - 03:00 PM', 'Computer Networks', 'Dr. Singh', 'Room 303'),
    ],
    2: [ // Wednesday
      TimetableSlot('09:00 AM - 10:00 AM', 'Computer Networks', 'Dr. Singh', 'Room 303'),
      TimetableSlot('10:00 AM - 11:00 AM', 'Operating Systems', 'Dr. Patel', 'Lab 1'),
      TimetableSlot('11:00 AM - 12:00 PM', 'Data Structures', 'Dr. Kumar', 'Room 301'),
      TimetableSlot('12:00 PM - 01:00 PM', 'Lunch Break', '', '', isBreak: true),
      TimetableSlot('01:00 PM - 02:00 PM', 'DBMS', 'Dr. Sharma', 'Room 302'),
      TimetableSlot('02:00 PM - 03:00 PM', 'AI & ML', 'Dr. Reddy', 'Lab 2'),
    ],
    3: [ // Thursday
      TimetableSlot('09:00 AM - 10:00 AM', 'AI & ML', 'Dr. Reddy', 'Lab 2'),
      TimetableSlot('10:00 AM - 11:00 AM', 'Computer Networks', 'Dr. Singh', 'Room 303'),
      TimetableSlot('11:00 AM - 12:00 PM', 'DBMS', 'Dr. Sharma', 'Room 302'),
      TimetableSlot('12:00 PM - 01:00 PM', 'Lunch Break', '', '', isBreak: true),
      TimetableSlot('01:00 PM - 02:00 PM', 'Data Structures', 'Dr. Kumar', 'Room 301'),
      TimetableSlot('02:00 PM - 03:00 PM', 'Operating Systems', 'Dr. Patel', 'Lab 1'),
    ],
    4: [ // Friday
      TimetableSlot('09:00 AM - 10:00 AM', 'Operating Systems', 'Dr. Patel', 'Lab 1'),
      TimetableSlot('10:00 AM - 11:00 AM', 'AI & ML', 'Dr. Reddy', 'Lab 2'),
      TimetableSlot('11:00 AM - 12:00 PM', 'Computer Networks', 'Dr. Singh', 'Room 303'),
      TimetableSlot('12:00 PM - 01:00 PM', 'Lunch Break', '', '', isBreak: true),
      TimetableSlot('01:00 PM - 02:00 PM', 'DBMS', 'Dr. Sharma', 'Room 302'),
      TimetableSlot('02:00 PM - 03:00 PM', 'Data Structures', 'Dr. Kumar', 'Room 301'),
    ],
    5: [ // Saturday
      TimetableSlot('09:00 AM - 10:00 AM', 'Data Structures', 'Dr. Kumar', 'Room 301'),
      TimetableSlot('10:00 AM - 11:00 AM', 'DBMS', 'Dr. Sharma', 'Room 302'),
      TimetableSlot('11:00 AM - 12:00 PM', 'Free Period', '', '', isBreak: true),
    ],
  };

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
          'Timetable',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF212121)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading timetable PDF...',
                      style: GoogleFonts.inter()),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Week selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_days.length, (index) {
                bool isSelected = index == _selectedDay;
                bool isToday = index == DateTime.now().weekday - 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A90E2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: isToday && !isSelected
                          ? Border.all(color: const Color(0xFF4A90E2), width: 2)
                          : null,
                    ),
                    child: Text(
                      _days[index],
                      style: GoogleFonts.inter(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF757575),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Timetable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _schedule[_selectedDay]
                      ?.map((slot) => slot.isBreak
                          ? _buildBreak(slot.time, slot.subject)
                          : _buildTimeSlot(
                              slot.time, slot.subject, slot.faculty, slot.room))
                      .toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(
      String time, String subject, String faculty, String room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A90E2), width: 2),
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
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subject,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Color(0xFF757575)),
              const SizedBox(width: 4),
              Text(faculty,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF757575))),
              const SizedBox(width: 16),
              const Icon(Icons.room, size: 14, color: Color(0xFF757575)),
              const SizedBox(width: 4),
              Text(room,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF757575))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreak(String time, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_cafe, color: Color(0xFFFF9800)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF757575)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimetableSlot {
  final String time;
  final String subject;
  final String faculty;
  final String room;
  final bool isBreak;

  TimetableSlot(this.time, this.subject, this.faculty, this.room,
      {this.isBreak = false});
}

