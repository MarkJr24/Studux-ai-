import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyMaterialsScreen extends StatefulWidget {
  const StudyMaterialsScreen({super.key});

  @override
  State<StudyMaterialsScreen> createState() => _StudyMaterialsScreenState();
}

class _StudyMaterialsScreenState extends State<StudyMaterialsScreen> {
  String _selectedSubject = 'All Subjects';

  final List<String> _subjects = [
    'All Subjects',
    'Data Structures',
    'DBMS',
    'Operating Systems',
    'Computer Networks',
    'AI & ML',
  ];

  final List<StudyMaterial> _materials = [
    StudyMaterial(
      title: 'Data Structures - Unit 3 Notes',
      subject: 'Data Structures',
      type: 'PDF',
      size: '2.4 MB',
      uploadedBy: 'Dr. Kumar',
      uploadDate: '10 Dec 2025',
    ),
    StudyMaterial(
      title: 'DBMS Complete Notes',
      subject: 'DBMS',
      type: 'PDF',
      size: '5.1 MB',
      uploadedBy: 'Dr. Sharma',
      uploadDate: '8 Dec 2025',
    ),
    StudyMaterial(
      title: 'OS Process Management Video',
      subject: 'Operating Systems',
      type: 'Video',
      size: '45 MB',
      uploadedBy: 'Dr. Patel',
      uploadDate: '5 Dec 2025',
    ),
    StudyMaterial(
      title: 'CN Routing Algorithms PPT',
      subject: 'Computer Networks',
      type: 'PPT',
      size: '3.2 MB',
      uploadedBy: 'Dr. Singh',
      uploadDate: '3 Dec 2025',
    ),
    StudyMaterial(
      title: 'AI & ML Previous Year Questions',
      subject: 'AI & ML',
      type: 'PDF',
      size: '1.8 MB',
      uploadedBy: 'Dr. Reddy',
      uploadDate: '1 Dec 2025',
    ),
  ];

  List<StudyMaterial> get _filteredMaterials {
    if (_selectedSubject == 'All Subjects') {
      return _materials;
    }
    return _materials.where((m) => m.subject == _selectedSubject).toList();
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
          'Study Materials',
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
            icon: const Icon(Icons.search, color: Color(0xFF212121)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Subject filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _subjects.map((subject) {
                  final isSelected = subject == _selectedSubject;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSubject = subject),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4A90E2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4A90E2)
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Text(
                          subject,
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

          // Materials list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _filteredMaterials.map((material) {
                return _buildMaterialCard(material);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialCard(StudyMaterial material) {
    IconData typeIcon;
    Color typeColor;

    switch (material.type) {
      case 'PDF':
        typeIcon = Icons.picture_as_pdf;
        typeColor = const Color(0xFFEF5350);
        break;
      case 'Video':
        typeIcon = Icons.video_library;
        typeColor = const Color(0xFF42A5F5);
        break;
      case 'PPT':
        typeIcon = Icons.slideshow;
        typeColor = const Color(0xFFFF9800);
        break;
      default:
        typeIcon = Icons.insert_drive_file;
        typeColor = const Color(0xFF9E9E9E);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(typeIcon, color: typeColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            material.subject,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF4A90E2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          material.size,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Color(0xFF757575)),
              const SizedBox(width: 4),
              Text(
                material.uploadedBy,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF757575)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Color(0xFF757575)),
              const SizedBox(width: 4),
              Text(
                material.uploadDate,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF757575)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening ${material.title}...',
                            style: GoogleFonts.inter()),
                        backgroundColor: const Color(0xFF4A90E2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: Text('View', style: GoogleFonts.inter()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4A90E2),
                    side: const BorderSide(color: Color(0xFF4A90E2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading ${material.title}...',
                            style: GoogleFonts.inter()),
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: Text('Download', style: GoogleFonts.inter()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StudyMaterial {
  final String title;
  final String subject;
  final String type;
  final String size;
  final String uploadedBy;
  final String uploadDate;

  StudyMaterial({
    required this.title,
    required this.subject,
    required this.type,
    required this.size,
    required this.uploadedBy,
    required this.uploadDate,
  });
}

