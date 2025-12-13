class ApiConstants {
  // Base
  static const String baseUrl = 'https://api.studentportal.com/api/v1';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // Student Endpoints
  static const String studentProfile = '/student/profile';
  static const String studentCourses = '/student/courses';
  static const String studentAttendance = '/student/attendance';
  static const String studentGrades = '/student/grades';
  
  // Teacher Endpoints
  static const String teacherProfile = '/teacher/profile';
  static const String teacherClasses = '/teacher/classes';
  static const String teacherStudents = '/teacher/students';
  
  // Admin Endpoints
  static const String adminUsers = '/admin/users';
  static const String adminReports = '/admin/reports';
}
