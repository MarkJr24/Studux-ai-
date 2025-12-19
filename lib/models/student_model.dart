/// Student Data Model
/// Represents a student with all necessary information for the admin dashboard
library;

class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String department;
  final String year;
  final String semester;
  final AcademicStatus academicStatus;
  final HallTicketStatus hallTicketStatus;
  final SeatAllocationStatus seatAllocationStatus;
  final EligibilityStatus eligibilityStatus;
  final String? blockReason;
  final bool clubParticipation;
  final int eventsRegistered;

  const Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.department,
    required this.year,
    required this.semester,
    required this.academicStatus,
    required this.hallTicketStatus,
    required this.seatAllocationStatus,
    required this.eligibilityStatus,
    this.blockReason,
    required this.clubParticipation,
    required this.eventsRegistered,
  });

  // Check if student is blocked
  bool get isBlocked => eligibilityStatus == EligibilityStatus.blocked;

  // Get display text for academic status
  String get academicStatusText {
    switch (academicStatus) {
      case AcademicStatus.active:
        return 'Active';
      case AcademicStatus.creditShortage:
        return 'Credit Shortage';
      case AcademicStatus.detained:
        return 'Detained';
    }
  }

  // Get display text for hall ticket status
  String get hallTicketStatusText {
    switch (hallTicketStatus) {
      case HallTicketStatus.uploaded:
        return 'Uploaded';
      case HallTicketStatus.notUploaded:
        return 'Not Uploaded';
    }
  }

  // Get display text for seat allocation status
  String get seatAllocationStatusText {
    switch (seatAllocationStatus) {
      case SeatAllocationStatus.assigned:
        return 'Assigned';
      case SeatAllocationStatus.notAssigned:
        return 'Not Assigned';
    }
  }

  // Get display text for eligibility status
  String get eligibilityStatusText {
    switch (eligibilityStatus) {
      case EligibilityStatus.eligible:
        return 'Eligible';
      case EligibilityStatus.blocked:
        return 'Blocked';
    }
  }

  // Sample data for testing
  static List<Student> getSampleStudents() {
    return [
      Student(
        id: '1',
        name: 'Rajesh Kumar',
        rollNumber: '21CS101',
        department: 'Computer Science',
        year: 'III Year',
        semester: 'VI Semester',
        academicStatus: AcademicStatus.active,
        hallTicketStatus: HallTicketStatus.uploaded,
        seatAllocationStatus: SeatAllocationStatus.assigned,
        eligibilityStatus: EligibilityStatus.eligible,
        clubParticipation: true,
        eventsRegistered: 5,
      ),
      Student(
        id: '2',
        name: 'Priya Sharma',
        rollNumber: '21AI052',
        department: 'AI & Data Science',
        year: 'III Year',
        semester: 'VI Semester',
        academicStatus: AcademicStatus.creditShortage,
        hallTicketStatus: HallTicketStatus.uploaded,
        seatAllocationStatus: SeatAllocationStatus.assigned,
        eligibilityStatus: EligibilityStatus.eligible,
        clubParticipation: true,
        eventsRegistered: 3,
      ),
      Student(
        id: '3',
        name: 'Amit Patel',
        rollNumber: '21IT078',
        department: 'Information Technology',
        year: 'III Year',
        semester: 'VI Semester',
        academicStatus: AcademicStatus.detained,
        hallTicketStatus: HallTicketStatus.notUploaded,
        seatAllocationStatus: SeatAllocationStatus.notAssigned,
        eligibilityStatus: EligibilityStatus.blocked,
        blockReason: 'Blocked due to academic status.',
        clubParticipation: false,
        eventsRegistered: 0,
      ),
      Student(
        id: '4',
        name: 'Sneha Reddy',
        rollNumber: '21CS089',
        department: 'Computer Science',
        year: 'II Year',
        semester: 'IV Semester',
        academicStatus: AcademicStatus.active,
        hallTicketStatus: HallTicketStatus.uploaded,
        seatAllocationStatus: SeatAllocationStatus.assigned,
        eligibilityStatus: EligibilityStatus.eligible,
        clubParticipation: true,
        eventsRegistered: 8,
      ),
      Student(
        id: '5',
        name: 'Vikram Singh',
        rollNumber: '21AI034',
        department: 'AI & Data Science',
        year: 'II Year',
        semester: 'IV Semester',
        academicStatus: AcademicStatus.active,
        hallTicketStatus: HallTicketStatus.notUploaded,
        seatAllocationStatus: SeatAllocationStatus.notAssigned,
        eligibilityStatus: EligibilityStatus.eligible,
        clubParticipation: false,
        eventsRegistered: 2,
      ),
    ];
  }
}

/// Academic Status Enum
enum AcademicStatus {
  active,
  creditShortage,
  detained,
}

/// Hall Ticket Status Enum
enum HallTicketStatus {
  uploaded,
  notUploaded,
}

/// Seat Allocation Status Enum
enum SeatAllocationStatus {
  assigned,
  notAssigned,
}

/// Eligibility Status Enum
enum EligibilityStatus {
  eligible,
  blocked,
}
