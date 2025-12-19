import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // prefs not needed right now but kept if other features use it later, or remove if unused.
  await SharedPreferences.getInstance();
  
  runApp(const MyApp());
}
