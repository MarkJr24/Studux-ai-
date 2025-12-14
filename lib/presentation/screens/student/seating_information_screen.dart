import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeatingInformationScreen extends StatefulWidget {
  const SeatingInformationScreen({super.key});

  @override
  State<SeatingInformationScreen> createState() =>
      _SeatingInformationScreenState();
}

class _SeatingInformationScreenState extends State<SeatingInformationScreen> {
  String _selectedFilter = 'Upcoming';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Upcoming', 'Past'];

  final List<SeatingInfo> _seatings = [
    SeatingInfo(
      subject: 'Data Structures',
      date: '15 Dec 2025',
      time: '10:00 AM - 01:00 PM',
      hall: 'Hall A',
      seatNumber: 'A-15',
      status: 'Confirmed',
      isUpcoming: true,
    ),
    SeatingInfo(
      subject: 'Database Management Systems',
      date: '18 Dec 2025',
      time: '10:00 AM - 01:00 PM',
      hall: 'Hall B',
      seatNumber: 'B-22',
      status: 'Confirmed',
      isUpcoming: true,
    ),
    SeatingInfo(
      subject: 'Operating Systems',
      date: '20 Dec 2025',
      time: '09:00 AM - 12:00 PM',
      hall: 'Hall C',
      seatNumber: 'C-08',
      status: 'Confirmed',
      isUpcoming: true,
    ),
    SeatingInfo(
      subject: 'AI & Machine Learning',
      date: '10 Dec 2025',
      time: '10:00 AM - 01:00 PM',
      hall: 'Hall B',
      seatNumber: 'B-18',
      status: 'Confirmed',
      isUpcoming: false,
    ),
  ];

  List<SeatingInfo> get _filteredSeatings {
    final filtered = _seatings.where((s) =>
        _selectedFilter == 'Upcoming' ? s.isUpcoming : !s.isUpcoming).toList();

    if (_searchController.text.isEmpty) {
      return filtered;
    }

    return filtered
        .where((s) =>
            s.subject
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            s.date.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Seating Information',
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
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by subject or date...',
                hintStyle: GoogleFonts.inter(color: const Color(0xFFBDBDBD)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF757575)),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.inter(),
            ),
          ),

          // Filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
                            ? const Color(0xFF2196F3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2196F3)
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

          // Seating list
          Expanded(
            child: _filteredSeatings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredSeatings.length,
                    itemBuilder: (context, index) {
                      return _buildSeatingCard(_filteredSeatings[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatingCard(SeatingInfo seating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: seating.isUpcoming
            ? Border.all(color: const Color(0xFF2196F3), width: 2)
            : null,
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
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.book,
                    color: Color(0xFF2196F3), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  seating.subject,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 14, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 4),
                    Text(
                      seating.status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
                seating.date,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF757575)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Color(0xFF757575)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  seating.time,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF757575)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: Color(0xFF757575)),
              const SizedBox(width: 4),
              Text(
                seating.hall,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF757575)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Seat Number - Prominent Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_seat,
                    color: Color(0xFF2196F3), size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR SEAT',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF757575),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      seating.seatNumber,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2196F3),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_seat_outlined,
            size: 80,
            color: const Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 16),
          Text(
            'No seating information available',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seating details will appear once published',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

class SeatingInfo {
  final String subject;
  final String date;
  final String time;
  final String hall;
  final String seatNumber;
  final String status;
  final bool isUpcoming;

  SeatingInfo({
    required this.subject,
    required this.date,
    required this.time,
    required this.hall,
    required this.seatNumber,
    required this.status,
    required this.isUpcoming,
  });
}

