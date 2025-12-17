# Quick Integration Guide - Attendance Screens

## 🚀 5-Minute Setup

### Step 1: Update Your Main Attendance Screen
In your `mark_attendance_screen.dart` or main attendance hub, replace the old navigation buttons:

```dart
// ✅ KEEP - QR Scanner (already exists at top)

// ❌ REMOVE - Duplicate QR buttons from Attendance Methods

// ✅ ADD - Manual Attendance Entry
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualAttendanceEntryScreen(
          className: widget.className,
          classCode: widget.classCode,
        ),
      ),
    );
  },
  child: _buildManualAttendanceCard(context),
)

// ✅ MOVE TO SUBMISSION SECTION - Submit QR Scanned Attendance
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitQRAttendanceScreen(
          className: widget.className,
          classCode: widget.classCode,
        ),
      ),
    );
  },
  child: Text('Submit Attendance'),
)

// ✅ MOVE TO SUBMISSION SECTION - Submit as Batch
OutlinedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchAttendanceScreen(),
      ),
    );
  },
  child: Text('Submit as Batch'),
)

// ✅ MOVE TO ADDITIONAL SECTION - Booklet Entry
_buildOptionalCard(
  context,
  'Booklet Number Entry',
  'Enter physical booklet numbers',
  Icons.numbers,
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookletEntryScreen(),
      ),
    );
  },
)

// ✅ MOVE TO ADDITIONAL SECTION - Upload Signature
_buildOptionalCard(
  context,
  'Upload Signature Image',
  'Upload your digital signature',
  Icons.upload_file,
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadSignatureScreen(),
      ),
    );
  },
)
```

### Step 2: Import All New Screens
At the top of your file:

```dart
import 'package:your_app/presentation/screens/teacher/manual_attendance_entry_screen.dart';
import 'package:your_app/presentation/screens/teacher/submit_qr_attendance_screen.dart';
import 'package:your_app/presentation/screens/teacher/batch_attendance_screen.dart';
import 'package:your_app/presentation/screens/teacher/booklet_entry_screen.dart';
import 'package:your_app/presentation/screens/teacher/upload_signature_screen.dart';
```

### Step 3: Test Navigation
Run the app and verify:
- ✅ QR Scanner card remains at top (untouched)
- ✅ Manual Attendance Entry opens the new screen
- ✅ Submit buttons work under SUBMISSION section
- ✅ Booklet & Signature options work under ADDITIONAL section
- ❌ No duplicate QR Scanner buttons exist

---

## 🎯 What Each Screen Does

| Screen | Purpose | When to Use |
|--------|---------|-------------|
| **Manual Attendance Entry** | Mark students present/absent with toggles | When QR not available or preferred |
| **Submit QR Attendance** | Review scanned QR data before submitting | After QR scanning session complete |
| **Batch Submission** | Submit multiple classes at once | During exams or consolidated marking |
| **Booklet Entry** | Record exam answer sheet booklet numbers | During semester exams for tracking |
| **Upload Signature** | Store faculty digital signature | One-time setup for document signing |

---

## 📱 Screen Flow Examples

### Flow 1: Manual Attendance
```
Main Attendance Screen
    → Manual Attendance Entry
        → Mark students (toggles)
        → Submit
        → Success ✅
    ← Back to Main
```

### Flow 2: QR Attendance
```
Main Attendance Screen
    → QR Scanner (already exists)
        → Scan students
    → Submit QR Attendance
        → Review scanned list
        → Mark missing students
        → Submit & Lock
        → Success ✅
    ← Back to Main
```

### Flow 3: Batch Submission
```
Main Attendance Screen
    → Batch Submission
        → Select multiple classes
        → Review each class
        → Submit All
        → Progress screen
        → Success ✅
    ← Back to Main
```

---

## 🔧 Customization Points

### Change Colors
All screens use these color constants:
```dart
Color(0xFF3B82F6) // Primary Blue
Color(0xFF10B981) // Success Green
Color(0xFFF59E0B) // Warning Orange
Color(0xFFEF4444) // Error Red
Color(0xFF8B5CF6) // Purple Accent
```

**To customize**: Search and replace these hex codes across all 5 screen files.

### Change Typography
All screens use Google Fonts Inter:
```dart
GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)
```

**To customize**: Change `inter` to your preferred font family.

### Change Mock Data
Each screen has mock data at the top of the State class:
```dart
final List<Student> _students = [
  Student('21CS001', 'Arun Kumar', 92, true),
  // Add more or replace with API call
];
```

**To integrate API**: Replace with `FutureBuilder` or `StreamBuilder` fetching from your backend.

---

## 🛠️ API Integration Template

### Example: Fetch Students for Manual Attendance
```dart
class _ManualAttendanceEntryScreenState extends State<ManualAttendanceEntryScreen> {
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/classes/${widget.classCode}/students'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _students = data.map((json) => Student.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load students');
    }
  }

  // ... rest of code
}
```

### Example: Submit Attendance
```dart
Future<void> _submitAttendance() async {
  try {
    final attendanceData = _students.map((s) => {
      'roll_no': s.rollNo,
      'status': s.isPresent ? 'present' : 'absent',
    }).toList();

    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/submit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'class_code': widget.classCode,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'period': _selectedPeriod,
        'attendance': attendanceData,
      }),
    );

    if (response.statusCode == 200) {
      _showSuccessScreen();
    } else {
      _showError('Submission failed');
    }
  } catch (e) {
    _showError('Network error: ${e.toString()}');
  }
}
```

---

## 🎨 UI Customization Quick Reference

### Change Card Style
```dart
// Current
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
)

// To change: Update borderRadius, add gradient, etc.
```

### Change Button Style
```dart
// Current
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF3B82F6),
    padding: const EdgeInsets.symmetric(vertical: 16),
  ),
)

// To change: Update backgroundColor, padding, shape
```

### Change Spacing
```dart
// Current spacing values
EdgeInsets.all(16)        // Standard padding
EdgeInsets.all(12)        // Compact padding
const SizedBox(height: 8) // Small gap
const SizedBox(height: 16) // Medium gap

// To change: Search and replace across files
```

---

## 🐛 Troubleshooting

### Issue: Screens not navigating
**Solution**: Ensure all 5 screen files are in `lib/presentation/screens/teacher/` and imports are correct.

### Issue: "Student not defined" error
**Solution**: Each screen has its own model classes at the bottom. They're self-contained.

### Issue: Colors look different
**Solution**: Check if `TeacherColors` constants exist. Screens use inline hex codes by default.

### Issue: Fonts not loading
**Solution**: Ensure `google_fonts` package is in `pubspec.yaml` and run `flutter pub get`.

### Issue: Date picker not working
**Solution**: Ensure `intl` package is installed for date formatting.

---

## ✅ Final Checklist

Before deploying to production:

- [ ] All 5 screens imported correctly
- [ ] Navigation works from main attendance screen
- [ ] Mock data replaced with API calls
- [ ] Error handling added for network failures
- [ ] Loading states implemented
- [ ] Success/error messages shown to users
- [ ] Attendance lock mechanism enforced
- [ ] QR scanner integrated (if using QR flow)
- [ ] Signature upload connected to server
- [ ] Tested on both Android and iOS
- [ ] Tested with slow network conditions
- [ ] Tested with empty data states
- [ ] Accessibility tested (screen readers)
- [ ] Performance tested with 100+ students

---

## 📚 Additional Resources

- **Full Documentation**: See `ATTENDANCE_SCREENS_DOCUMENTATION.md`
- **Design System**: Check `lib/presentation/screens/teacher/teacher_design_system.dart`
- **Existing Patterns**: Reference other teacher screens in the same directory

---

## 🆘 Need Help?

1. Check the full documentation: `ATTENDANCE_SCREENS_DOCUMENTATION.md`
2. Review existing screen patterns in `lib/presentation/screens/teacher/`
3. Check mock data structures at bottom of each screen file
4. Verify imports and file paths

---

**Last Updated**: December 17, 2025  
**Quick Setup Time**: ~5 minutes  
**Full Integration**: ~2 hours (including API)

