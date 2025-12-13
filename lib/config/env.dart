class Environment {
  static const String dev = 'development';
  static const String prod = 'production';
  
  static String current = dev; // Change to prod for production
  
  static bool get isDevelopment => current == dev;
  static bool get isProduction => current == prod;
}
