# Invigilation Schedule - Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### Files Created
```
lib/
├── presentation/
│   ├── widgets/
│   │   └── invigilation_widgets.dart          ✓ NEW
│   └── screens/
│       └── teacher/
│           ├── today_exam_duty_screen.dart    ✓ NEW
│           ├── reporting_details_screen.dart  ✓ NEW
│           ├── upcoming_invigilation_screen.dart ✓ NEW
│           ├── past_invigilation_screen.dart  ✓ NEW
│           └── duty_exam_management_screen.dart ✓ UPDATED
```

## 📦 Dependencies Already Installed

These packages are already in your `pubspec.yaml`:
- ✓ `google_fonts: ^6.1.0`
- ✓ `intl: ^0.19.0`
- ✓ `table_calendar: ^3.0.9`

No additional packages needed!

## 🎯 How to Test

### Step 1: Navigate to Teacher Section
1. Run your app: `flutter run`
2. Login as a teacher/faculty member
3. Navigate to the main teacher dashboard

### Step 2: Open Invigilation Schedule
1. From the teacher home screen, tap on **"Invigilation Schedule"** or similar menu item
2. You'll see the main menu with 4 options

### Step 3: Test Each Screen

#### 🟣 Screen 1: Today's Exam Duty
**Path:** Tap "View Today's Exam Duty & Halls"

**What to See:**
- Purple-themed duty card with exam details
- Hall information with facilities
- Co-invigilator cards with call buttons
- Important instructions
- "Mark Attendance" and "Report Issue" buttons

**Test Actions:**
1. Pull down to refresh
2. Tap "Mark Attendance" → See confirmation dialog
3. Tap "Report Issue" → Enter issue details
4. Tap "View on Map" / "Hall Photo" buttons
5. Tap phone icon on co-invigilator card

**Toggle No Duty State:**
Edit `today_exam_duty_screen.dart` line 19:
```dart
bool _hasDutyToday = false; // Change to false
```
You'll see: 🎉 "No Exam Duty Today" message

---

#### 🟣 Screen 2: Reporting Time & Subject Details
**Path:** Tap "Reporting Time & Subject Details"

**What to See:**
- Visual timeline (5 events)
- Complete subject information card
- Hall details with facilities
- Co-invigilators section
- Expandable invigilation guidelines

**Test Actions:**
1. Pull down to refresh
2. Tap guidelines section to expand/collapse
3. Tap "Download Instructions PDF"
4. Tap "Contact Exam Cell" → See contact dialog
5. Scroll through all sections

---

#### 🔵 Screen 3: Upcoming Invigilation Schedule
**Path:** Tap "Upcoming Invigilation Schedule"

**What to See:**
- Quick stats card (total, this month, next 7 days)
- Filter chips (All, This Week, Next Week, This Month)
- List of upcoming duties with status badges
- View toggle icon (top-right)

**Test Actions:**
1. Tap different filter chips → List updates
2. Tap view toggle icon (top-right) → Switch to calendar view
3. In calendar:
   - See event dots on dates
   - Tap a date with duties → See duties below
   - Tap empty date → See "no duties" message
4. Pull to refresh
5. Tap "View Details" on any duty card

**Mock Data Dates:**
- Dec 23, 2025 - Data Structures
- Dec 27, 2025 - Operating Systems
- Dec 30, 2025 - Computer Networks
- Jan 3, 2026 - Software Engineering

---

#### 🟢 Screen 4: Past Invigilation History
**Path:** Tap "Past Invigilation History"

**What to See:**
- Summary card with statistics
- Filter chips (All, This Semester, Last Semester, Academic Year)
- List of completed duties
- Search icon (top-right)

**Test Actions:**
1. Tap search icon → Enter search query
2. Search for "DBMS", "DS", "CN" → See filtered results
3. Tap different filter chips
4. Tap "View Report" on any duty → See detailed modal
5. In modal:
   - Scroll through all sections
   - Tap "Download PDF"
   - Tap "Email Copy"
6. Tap "Download" button on any card
7. Scroll to bottom → Tap "Export All Reports"
8. Tap "Email Report"

**Mock Data:**
- Dec 9, 2025 - DBMS (118/120 students, 0 malpractice)
- Nov 29, 2025 - Data Structures (58/60 students, 1 malpractice)
- Nov 15, 2025 - Computer Networks (98/100 students, 0 malpractice)

---

## 🎨 UI Elements to Look For

### Color-Coded Status Badges
- 🟢 **Confirmed** - Green background, green dot
- 🟡 **Tentative** - Yellow/orange background, orange dot
- 🔴 **Cancelled** - Red background, red dot
- ⚪ **Completed** - Gray background, gray dot

### Interactive Elements
- ✓ Pull-to-refresh on all screens
- ✓ Tap animations on cards
- ✓ Bottom sheets for detailed views
- ✓ Dialogs for confirmations
- ✓ Expandable sections
- ✓ Calendar date selection
- ✓ Filter chip selection

### Empty States
To see empty states:
1. **Today's Duty:** Set `_hasDutyToday = false`
2. **Upcoming:** Clear `_upcomingDuties` list
3. **History:** Clear `_pastDuties` list

## 🔧 Common Customizations

### Change Mock Data
Edit the screen files and modify the data maps:

**Today's Duty:**
```dart
// lib/presentation/screens/teacher/today_exam_duty_screen.dart
final Map<String, dynamic> _dutyData = {
  'subject': 'Your Subject',
  'time': 'Your Time',
  // ... modify as needed
};
```

**Upcoming Duties:**
```dart
// lib/presentation/screens/teacher/upcoming_invigilation_screen.dart
final List<Map<String, dynamic>> _upcomingDuties = [
  {
    'date': DateTime(2025, 12, 23), // Change date
    'subject': 'Your Subject',
    // ... add your data
  },
];
```

### Add More Timeline Events
```dart
// lib/presentation/screens/teacher/reporting_details_screen.dart
final List<TimelineItem> _timeline = [
  TimelineItem(time: '1:30 PM', description: 'Your event'),
  // Add more events
];
```

### Change Colors
```dart
// lib/presentation/screens/teacher/teacher_design_system.dart
class TeacherColors {
  static const Color invigilationColor = Color(0xFF9C27B0); // Change here
}
```

## 📱 Testing on Different Devices

### Responsive Testing
Test on multiple screen sizes:
```bash
# iPhone SE (small)
flutter run -d <device-id>

# iPad (tablet)
flutter run -d <device-id>

# Android phone
flutter run -d <device-id>
```

### Hot Reload
While testing, use hot reload for quick changes:
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

## 🐛 Troubleshooting

### Issue: Screens not appearing
**Solution:** Make sure you're navigating from the teacher section, not student or admin.

### Issue: Calendar not showing
**Solution:** Check that `table_calendar` package is installed:
```bash
flutter pub get
```

### Issue: Dates not displaying correctly
**Solution:** Check device timezone settings.

### Issue: Colors look different
**Solution:** Ensure you're using the teacher design system colors from `teacher_design_system.dart`.

### Issue: Smooth scrolling issues
**Solution:** Test on physical device, not just simulator.

## ✅ Complete Feature Checklist

### Screen 1: Today's Exam Duty ✓
- [x] Header with date
- [x] Duty card with all details
- [x] Status badge
- [x] Hall details with facilities
- [x] Co-invigilators with contact
- [x] Instructions card
- [x] Action buttons
- [x] Empty state
- [x] Pull-to-refresh

### Screen 2: Reporting Details ✓
- [x] Timeline visualization
- [x] Subject information
- [x] Hall details
- [x] Co-invigilators
- [x] Expandable guidelines
- [x] Action buttons
- [x] Pull-to-refresh

### Screen 3: Upcoming Schedule ✓
- [x] Stats card
- [x] Filter chips
- [x] List view with cards
- [x] Calendar view with events
- [x] View toggle
- [x] Status badges
- [x] Empty state
- [x] Pull-to-refresh

### Screen 4: Past History ✓
- [x] Summary statistics
- [x] Filter chips
- [x] Search functionality
- [x] History cards
- [x] Detailed report modal
- [x] Export options
- [x] Empty state
- [x] Pull-to-refresh

## 🎯 Next Steps

### 1. API Integration (High Priority)
Replace mock data with real API calls:
```dart
// Example using http package
Future<Map<String, dynamic>> fetchTodayDuty() async {
  final response = await http.get(
    Uri.parse('https://your-api.com/api/faculty/invigilation/today'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load duty');
  }
}
```

### 2. Add Error Handling
```dart
try {
  final data = await fetchTodayDuty();
  setState(() {
    _dutyData = data;
    _isLoading = false;
  });
} catch (e) {
  setState(() {
    _hasError = true;
    _isLoading = false;
  });
}
```

### 3. Implement Features
- [ ] PDF generation (use `pdf` package)
- [ ] Map integration (use `google_maps_flutter`)
- [ ] Phone dialing (use `url_launcher`)
- [ ] Push notifications (use `firebase_messaging`)
- [ ] Local storage (use `hive` or `sqflite`)

### 4. Performance Optimization
- [ ] Add pagination for long lists
- [ ] Implement image caching
- [ ] Add debouncing to search
- [ ] Lazy load calendar events

## 📞 Need Help?

Check these resources:
- **Flutter Docs:** https://docs.flutter.dev/
- **Package Docs:** https://pub.dev/
- **Design System:** See `teacher_design_system.dart`
- **Full Documentation:** See `INVIGILATION_SCHEDULE_DOCUMENTATION.md`

---

## 🎉 You're All Set!

The invigilation schedule screens are fully functional with mock data. Now you can:
1. Test all screens and features
2. Customize colors and content
3. Integrate with your backend API
4. Deploy to production

**Happy Coding! 🚀**

