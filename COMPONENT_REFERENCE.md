# Invigilation Schedule - Component Reference Guide

## 🧩 Reusable Widget Library

All components are in: `lib/presentation/widgets/invigilation_widgets.dart`

---

## 1. StatusBadge

**Purpose:** Display color-coded status indicators

**Visual:**
```
┌──────────────┐
│ 🟢 Confirmed │
└──────────────┘
```

**Usage:**
```dart
StatusBadge(
  text: 'Confirmed',
  type: StatusType.confirmed,
)
```

**Status Types:**
- `StatusType.confirmed` → 🟢 Green (exam is confirmed)
- `StatusType.tentative` → 🟡 Yellow/Orange (exam may change)
- `StatusType.cancelled` → 🔴 Red (exam cancelled)
- `StatusType.completed` → ⚪ Gray (exam finished)

**Colors:**
- **Confirmed:** Green bg `#E8F5E9`, Green dot/text `#43A047`
- **Tentative:** Orange bg `#FFF3E0`, Orange dot/text `#EF6C00`
- **Cancelled:** Red bg `#FFEBEE`, Red dot/text `#E53935`
- **Completed:** Gray bg `#F5F5F5`, Gray dot/text `#616161`

---

## 2. TimelineWidget

**Purpose:** Display chronological events in a vertical timeline

**Visual:**
```
📅 Exam Timeline
    ●─── 1:30 PM
    │    Reporting Time
    ●─── 1:45 PM
    │    Briefing Session
    ●─── 2:00 PM
    │    Exam Starts
    ●─── 5:00 PM
         Exam Ends
```

**Usage:**
```dart
TimelineWidget(
  items: [
    TimelineItem(
      time: '1:30 PM',
      description: 'Reporting Time',
    ),
    TimelineItem(
      time: '2:00 PM',
      description: 'Exam Starts',
    ),
  ],
)
```

**Features:**
- Purple dots for each event
- Connecting lines between events
- Time + description for each item
- Last item has no line below it

---

## 3. CoInvigilatorCard

**Purpose:** Display co-invigilator information with contact option

**Visual:**
```
┌─────────────────────────────────┐
│  👤  Dr. Priya Kumar           📞│
│      Dept: CSE                   │
│      📞 +91 98765 43210          │
└─────────────────────────────────┘
```

**Usage:**
```dart
CoInvigilatorCard(
  name: 'Dr. Priya Kumar',
  department: 'CSE',
  phone: '+91 98765 43210',
)
```

**Features:**
- Profile icon with blue background
- Name in bold
- Department and phone details
- Call button on the right
- Tap call button to initiate phone call (placeholder)

---

## 4. InfoRow

**Purpose:** Display labeled information in a consistent format

**Visual:**
```
📅  Date
    16 Dec 2025
```

**Usage:**
```dart
InfoRow(
  icon: Icons.calendar_today,
  label: 'Date',
  value: '16 Dec 2025',
  iconColor: TeacherColors.invigilationColor,
)
```

**Features:**
- Icon on the left
- Label in smaller gray text
- Value in bold black text
- Custom icon color option

---

## 5. EmptyStateWidget

**Purpose:** Show when no data is available

**Visual:**
```
┌─────────────────────────┐
│          🎉            │
│   No Exam Duty Today   │
│   Enjoy your free time!│
│                        │
│  [View Upcoming →]     │
└─────────────────────────┘
```

**Usage:**
```dart
EmptyStateWidget(
  emoji: '🎉',
  title: 'No Exam Duty Today',
  subtitle: 'Enjoy your free time!',
  buttonText: 'View Upcoming Duties',
  onButtonPressed: () {
    // Navigate somewhere
  },
)
```

**Features:**
- Large emoji (64px)
- Title in bold
- Subtitle in gray
- Optional action button
- Centered layout
- White card with shadow

---

## 6. LoadingStateWidget

**Purpose:** Display while data is loading

**Visual:**
```
    ⏳ [Spinner]
    
 Loading Duty Details...
```

**Usage:**
```dart
LoadingStateWidget(
  message: 'Loading Duty Details...',
)
```

**Features:**
- Purple circular progress indicator
- Custom message below
- Centered in parent
- Default message: "Loading Duty Details..."

---

## 7. ErrorStateWidget

**Purpose:** Show error with retry option

**Visual:**
```
┌─────────────────────────┐
│         ⚠️             │
│ Failed to Load Details │
│  Unable to connect     │
│                        │
│  [🔄 Retry]  [Go Back] │
└─────────────────────────┘
```

**Usage:**
```dart
ErrorStateWidget(
  message: 'Unable to connect to server',
  onRetry: () {
    // Retry loading data
  },
  onGoBack: () {
    // Navigate back
  },
)
```

**Features:**
- Error icon (64px)
- Error title
- Custom error message
- Retry button (blue)
- Optional go back button
- White card with shadow

---

## 8. ExpandableSection

**Purpose:** Collapsible content section

**Visual (Collapsed):**
```
┌─────────────────────────┐
│ ⚠️ Guidelines        ▼  │
└─────────────────────────┘
```

**Visual (Expanded):**
```
┌─────────────────────────┐
│ ⚠️ Guidelines        ▲  │
│                         │
│ • Before Exam           │
│ • Collect papers        │
│ • Verify students       │
└─────────────────────────┘
```

**Usage:**
```dart
ExpandableSection(
  title: 'Invigilation Guidelines',
  icon: Icons.warning,
  initiallyExpanded: true,
  child: Column(
    children: [
      Text('• Collect sealed question papers'),
      Text('• Verify student list'),
    ],
  ),
)
```

**Features:**
- Tap title to expand/collapse
- Animated expansion
- Custom icon and title
- Optional initial state
- White card with shadow
- Arrow indicator (up/down)

---

## 🎨 Design Patterns Used

### 1. Card Pattern
All major components use white cards with:
- 16px border radius
- 1px gray border
- Subtle shadow
- 20px internal padding

```dart
decoration: TeacherDecorations.whiteCard
```

### 2. Tinted Card Pattern
Special cards with colored backgrounds:
- Invigilation: Light purple `#F3E5F5`
- Info: Light blue `#E3F2FD`
- Success: Light green `#E8F5E9`
- Warning: Light orange `#FFF3E0`

```dart
decoration: TeacherDecorations.tintedCard(
  backgroundColor: TeacherColors.invigilationBg,
  borderColor: TeacherColors.invigilationBorder,
)
```

### 3. Icon Container Pattern
Icons in colored circles:
```dart
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: TeacherColors.invigilationBg,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(
    Icons.school,
    color: TeacherColors.invigilationColor,
    size: 24,
  ),
)
```

---

## 🔧 Customization Examples

### Example 1: Custom Status Badge Colors
```dart
// Edit invigilation_widgets.dart
Map<String, Color> _getColors(StatusType type) {
  switch (type) {
    case StatusType.confirmed:
      return {
        'bg': Color(0xFFYOURBG),      // Your background
        'dot': Color(0xFFYOURDOT),     // Your dot color
        'text': Color(0xFFYOURTEXT),   // Your text color
      };
    // ... other cases
  }
}
```

### Example 2: Custom Timeline Colors
```dart
// Change timeline colors
Container(
  width: 12,
  height: 12,
  decoration: BoxDecoration(
    color: Colors.blue, // Change color here
    shape: BoxShape.circle,
  ),
)
```

### Example 3: Custom Empty State
```dart
EmptyStateWidget(
  emoji: '📚', // Change emoji
  title: 'Your Custom Title',
  subtitle: 'Your custom message here',
  buttonText: 'Custom Button',
  onButtonPressed: () {
    // Your action
  },
)
```

---

## 📐 Layout Guidelines

### Spacing Scale
- **Extra Small:** 4px
- **Small:** 8px
- **Medium:** 12px
- **Large:** 16px
- **Extra Large:** 20px
- **XXL:** 24px

### Icon Sizes
- **Small:** 16px (inline icons)
- **Medium:** 20px (card titles)
- **Large:** 24px (feature icons)
- **XL:** 48px (large circular containers)

### Font Sizes
- **Caption:** 12px
- **Body:** 14px
- **Subtitle:** 15px
- **Card Title:** 18px
- **Page Title:** 24px
- **Large Number:** 32px

---

## 🎯 Accessibility Features

All components include:
- ✓ Proper contrast ratios (WCAG AA)
- ✓ Touch targets ≥ 44x44px
- ✓ Semantic colors (green = success, red = error)
- ✓ Clear labels and descriptions
- ✓ Screen reader friendly structure

---

## 🧪 Testing Components

### Test Each Widget Individually
Create a test screen:

```dart
class WidgetTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Test StatusBadge
              StatusBadge(
                text: 'Confirmed',
                type: StatusType.confirmed,
              ),
              SizedBox(height: 20),
              
              // Test InfoRow
              InfoRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: '16 Dec 2025',
              ),
              SizedBox(height: 20),
              
              // Test other widgets...
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🔄 State Management Integration

### Example with Provider
```dart
class InvigilationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Future<void> loadTodayDuty() async {
    _isLoading = true;
    notifyListeners();
    
    // Load data
    
    _isLoading = false;
    notifyListeners();
  }
}

// In widget
Consumer<InvigilationProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return LoadingStateWidget();
    }
    // ... show data
  },
)
```

---

## 📦 Import Statement

To use these components in your screens:

```dart
import '../../widgets/invigilation_widgets.dart';
```

---

## 🎨 Color Reference Quick Guide

```dart
// Invigilation Theme
TeacherColors.invigilationColor    // #9C27B0 (Purple)
TeacherColors.invigilationBg       // #F3E5F5 (Light Purple)

// Status Colors
TeacherColors.successDark          // #43A047 (Green)
TeacherColors.successBg            // #E8F5E9 (Light Green)

TeacherColors.infoDark             // #1E88E5 (Blue)
TeacherColors.infoBg               // #E3F2FD (Light Blue)

TeacherColors.warningDark          // #EF6C00 (Orange)
TeacherColors.warningBg            // #FFF3E0 (Light Orange)

TeacherColors.errorDark            // #E53935 (Red)
TeacherColors.errorBg              // #FFEBEE (Light Red)

// Text Colors
TeacherColors.primaryText          // #212121 (Black)
TeacherColors.secondaryText        // #757575 (Gray)
TeacherColors.labelText            // #9E9E9E (Light Gray)

// Backgrounds
TeacherColors.background           // #FFFFFF (White)
TeacherColors.secondaryBackground  // #F8F9FA (Light Gray)

// Borders & Dividers
TeacherColors.cardBorder           // #E0E0E0 (Border Gray)
TeacherColors.divider              // #E0E0E0 (Divider Gray)
```

---

## 🚀 Performance Tips

1. **Use const constructors** where possible:
   ```dart
   const StatusBadge(text: 'Confirmed', type: StatusType.confirmed)
   ```

2. **Avoid rebuilding** with proper widget keys:
   ```dart
   StatusBadge(
     key: ValueKey('status-${duty.id}'),
     text: duty.status,
     type: StatusType.confirmed,
   )
   ```

3. **Lazy load images** in co-invigilator cards
4. **Cache network data** to reduce API calls
5. **Use ListView.builder** instead of ListView for long lists

---

This component library provides a consistent, reusable, and accessible set of widgets for the invigilation schedule feature. All components follow Flutter best practices and the existing design system.

**Happy Building! 🎨**

