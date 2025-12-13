class StringHelper {
  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  // Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  // Get initials from name (e.g., "John Doe" -> "JD")
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }
  
  // Remove extra spaces
  static String removeExtraSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  // Check if string is email
  static bool isEmail(String text) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(text);
  }
  
  // Check if string is phone number
  static bool isPhoneNumber(String text) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(text);
  }
  
  // Format phone number (e.g., 1234567890 -> (123) 456-7890)
  static String formatPhoneNumber(String phone) {
    if (phone.length != 10) return phone;
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }
  
  // Convert to snake_case
  static String toSnakeCase(String text) {
    return text
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}')
        .toLowerCase()
        .replaceAll(RegExp(r'^_'), '');
  }
  
  // Convert to camelCase
  static String toCamelCase(String text) {
    final words = text.split('_');
    if (words.isEmpty) return text;
    
    return words[0] + 
           words.skip(1).map((word) => capitalize(word)).join('');
  }
  
  // Mask email (e.g., john@example.com -> j***@example.com)
  static String maskEmail(String email) {
    if (!isEmail(email)) return email;
    
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) return email;
    
    return '${username[0]}${'*' * (username.length - 1)}@$domain';
  }
  
  // Mask phone number (e.g., 1234567890 -> ******7890)
  static String maskPhoneNumber(String phone) {
    if (phone.length < 4) return phone;
    return '${'*' * (phone.length - 4)}${phone.substring(phone.length - 4)}';
  }
}
