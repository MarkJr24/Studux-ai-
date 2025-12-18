import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleAccessVisibilityScreen extends StatefulWidget {
  const RoleAccessVisibilityScreen({super.key});

  @override
  State<RoleAccessVisibilityScreen> createState() => _RoleAccessVisibilityScreenState();
}

class _RoleAccessVisibilityScreenState extends State<RoleAccessVisibilityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _contentAnimationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _contentAnimationController.forward();
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _contentAnimationController.reset();
        _contentAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1F3A),
              const Color(0xFF0F1729),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAdminContent(),
                    _buildFacultyContent(),
                    _buildStudentContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF7B2FFF).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF7B2FFF).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF7B2FFF),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF7B2FFF), Color(0xFFEC407A)],
                  ).createShader(bounds),
                  child: Text(
                    'Role & Access Visibility',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'View what actions and modules are visible to each system role',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B2FFF), Color(0xFFEC407A)],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B2FFF).withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Admin'),
          Tab(text: 'Faculty'),
          Tab(text: 'Student'),
        ],
      ),
    );
  }

  Widget _buildAdminContent() {
    return FadeTransition(
      opacity: _contentAnimationController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccessBadge('🔓 Full Access', 'Admin Only', const Color(0xFF00FF87)),
            const SizedBox(height: 20),
            
            _buildSection(
              'Dashboard',
              [
                'System status + actions',
                'All modules overview',
                'Quick actions panel',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Modules',
              [
                'Exam Management',
                'Seating Allocation',
                'Attendance Audit',
                'Alerts & Notifications',
                'Event Approval',
                'Admin Profile',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Actions',
              [
                'Create Exam',
                'Allocate Seating',
                'Release Hall Ticket',
                'Generate Audit',
                'Approve Events',
                'Modify Settings',
              ],
              true,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFacultyContent() {
    return FadeTransition(
      opacity: _contentAnimationController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccessBadge('🔒 Restricted Access', 'Faculty View', const Color(0xFFFFB800)),
            const SizedBox(height: 20),
            
            _buildSection(
              'Dashboard',
              [
                'Assigned Exams',
                'Seating View',
                'Attendance Status',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Visible Modules',
              [
                'Attendance',
                'Invigilation',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Hidden Modules',
              [
                'Exam Management',
                'Seating Allocation',
                'Audit',
                'Settings',
              ],
              false,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Allowed Actions',
              [
                'Mark Attendance',
                'View Seating',
                'View Exam Details',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Restricted Actions',
              [
                'Generate Audit',
                'Seating Allocation',
                'Hall Ticket Release',
              ],
              false,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentContent() {
    return FadeTransition(
      opacity: _contentAnimationController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccessBadge('🔒 Minimal Access', 'Student View', const Color(0xFF00D9FF)),
            const SizedBox(height: 20),
            
            _buildSection(
              'Dashboard',
              [
                'Exam Schedule',
                'Hall Ticket Status',
                'Seating Details',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Visible Modules',
              [
                'Hall Ticket',
                'Seating View',
              ],
              true,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Hidden Modules',
              [
                'Attendance',
                'Audit',
                'Settings',
                'Event Approval',
              ],
              false,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Allowed Actions',
              [
                'View Hall Ticket',
                'Download Hall Ticket',
                'View Seating',
              ],
              true,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessBadge(String icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, bool isVisible) {
    final color = isVisible ? const Color(0xFF00FF87) : const Color(0xFFFF3366);
    final icon = isVisible ? Icons.check_circle : Icons.cancel;
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
