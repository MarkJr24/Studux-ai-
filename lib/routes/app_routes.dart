class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Student Routes
  static const String studentDashboard = '/student/dashboard';
  static const String studentProfile = '/student/profile';
  static const String studentCourses = '/student/courses';
  static const String studentAttendance = '/student/attendance';
  static const String studentGrades = '/student/grades';
  
  // Teacher Routes
  static const String teacherDashboard = '/teacher/dashboard';
  static const String teacherProfile = '/teacher/profile';
  static const String teacherClasses = '/teacher/classes';
  static const String teacherStudents = '/teacher/students';
  
  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminReports = '/admin/reports';
}
