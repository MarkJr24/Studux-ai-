import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarksResultsScreen extends StatefulWidget {
  const MarksResultsScreen({super.key});

  @override
  State<MarksResultsScreen> createState() => _MarksResultsScreenState();
}

class _MarksResultsScreenState extends State<MarksResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Marks / Results',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF2196F3)),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2196F3),
          unselectedLabelColor: const Color(0xFF757575),
          indicatorColor: const Color(0xFF2196F3),
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'CIA MARKS'),
            Tab(text: 'SEMESTER RESULTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCIAMarksTab(),
          _buildSemesterResultsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Downloading marksheet...', style: GoogleFonts.inter()),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        },
        icon: const Icon(Icons.download),
        label: Text('Download', style: GoogleFonts.inter()),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  Widget _buildCIAMarksTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall CIA Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Overall CIA Performance',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '86%',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '430 / 500 marks',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'SUBJECT-WISE MARKS',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF757575),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        _buildCIACard('Data Structures', 45, 50, 90, 'CIA 2', true),
        _buildCIACard(
            'Database Management Systems', 48, 50, 96, 'CIA 2', true),
        _buildCIACard('Operating Systems', 42, 50, 84, 'CIA 2', true),
        _buildCIACard('Computer Networks', 40, 50, 80, 'CIA 2', true),
        _buildCIACard('AI & Machine Learning', 38, 50, 76, 'CIA 2', true),
      ],
    );
  }

  Widget _buildCIACard(String subject, int obtained, int total, int percentage,
      String ciaNumber, bool isPassed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPassed ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
          width: 2,
        ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ciaNumber,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF2196F3),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$obtained / $total',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  Text(
                    'Marks',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$percentage%',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isPassed
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFF44336),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPassed
                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                : const Color(0xFFF44336).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPassed ? 'Pass' : 'Fail',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isPassed
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFF44336),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isPassed
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPassed
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                  ),
                  strokeWidth: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterResultsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall SGPA/CGPA Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'SGPA',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '8.6',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Current Semester',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 60,
                color: Colors.white.withOpacity(0.3),
              ),
              Column(
                children: [
                  Text(
                    'CGPA',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '8.4',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Overall',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'SUBJECT-WISE RESULTS',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF757575),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),

        _buildSemesterCard('Data Structures', 'A+', 4, 9),
        _buildSemesterCard('Database Management Systems', 'O', 4, 10),
        _buildSemesterCard('Operating Systems', 'A', 4, 8),
        _buildSemesterCard('Computer Networks', 'A', 3, 8),
        _buildSemesterCard('AI & Machine Learning', 'A+', 4, 9),
      ],
    );
  }

  Widget _buildSemesterCard(
      String subject, String grade, int credits, int gradePoints) {
    Color gradeColor;
    Color gradeBackground;

    switch (grade) {
      case 'O':
        gradeColor = const Color(0xFF4CAF50);
        gradeBackground = const Color(0xFF4CAF50).withOpacity(0.1);
        break;
      case 'A+':
        gradeColor = const Color(0xFF2196F3);
        gradeBackground = const Color(0xFF2196F3).withOpacity(0.1);
        break;
      case 'A':
        gradeColor = const Color(0xFF00BCD4);
        gradeBackground = const Color(0xFF00BCD4).withOpacity(0.1);
        break;
      default:
        gradeColor = const Color(0xFF757575);
        gradeBackground = const Color(0xFF757575).withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: gradeBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.book, color: gradeColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              subject,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: gradeBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    grade,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Credits: $credits',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF757575),
                ),
              ),
              Text(
                'GP: $gradePoints',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

