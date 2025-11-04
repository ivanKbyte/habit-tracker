# HabitTracker iOS Application

A professional habit tracking application built with SwiftUI, SwiftData, and Firebase Authentication. Features production-quality UI/UX with smooth animations, haptic feedback, and comprehensive data persistence.

## Technical Stack

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Local data persistence
- **Firebase Authentication** - User authentication and management
- **Firebase Firestore** - Cloud database for user profiles
- **Swift Charts** - Native data visualization

## Core Features

### Habit Management
- Create, edit, and delete habits with custom icons and colors
- Daily completion tracking with streak calculations
- Persistent local storage using SwiftData

### Analytics
- Weekly activity heatmaps
- Completion rate statistics
- Current and best streak tracking
- Comprehensive habit breakdown

### Authentication
- Email/password registration and login
- Password reset via email
- User profile management
- Secure Firebase backend integration

### UI/UX Polish
- Spring-based animations throughout
- Haptic feedback on interactions
- Confetti celebration on goal completion
- Full dark mode support
- Responsive layouts for all iPhone sizes

## Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Swift 5.9+
- Firebase account (free tier sufficient)

## Installation

### 1. Firebase Setup

Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com):

1. Create new project
2. Add iOS app with your bundle identifier
3. Download `GoogleService-Info.plist`
4. Enable Authentication → Email/Password
5. Create Firestore database in test mode

### 2. Xcode Configuration

1. Add `GoogleService-Info.plist` to project root (ensure target membership is checked)
2. Install Firebase SDK via Swift Package Manager:
   - URL: `https://github.com/firebase/firebase-ios-sdk`
   - Products: `FirebaseAuth`, `FirebaseFirestore`
3. Update bundle identifier to match Firebase configuration

### 3. Project Structure

```
HabitTracker/
├── HabitTrackerApp.swift
├── ContentView.swift
├── GoogleService-Info.plist
├── Models/
│   └── Habit.swift
├── Views/
│   ├── TodayView.swift
│   ├── AddHabitView.swift
│   ├── StatisticsView.swift
│   ├── HabitsListView.swift
│   ├── HabitDetailView.swift
│   ├── LoginView.swift
│   ├── SignUpView.swift
│   ├── ForgotPasswordView.swift
│   ├── ProfileView.swift
│   └── ConfettiView.swift
├── Managers/
│   └── AuthenticationManager.swift
└── SharedComponents.swift
```

## Building and Running

1. Open project in Xcode
2. Select target device or simulator
3. Build: `Cmd + B`
4. Run: `Cmd + R`

## Testing Authentication

1. Launch application
2. Create account via Sign Up screen
3. Verify user appears in Firebase Console → Authentication
4. Test sign out and sign in flows
5. Verify password reset functionality

## Key Implementation Details

### Data Persistence
- Local habits stored with SwiftData
- User profiles synced to Firestore
- Automatic state management

### Animation System
- Spring physics for natural motion
- Coordinated haptic feedback
- Smooth state transitions

### Security
- Firebase handles password hashing and secure storage
- Test mode Firestore rules (update for production deployment)
- Proper error handling throughout

## Production Considerations

For production deployment:

1. Update Firestore security rules
2. Implement proper data validation
3. Add rate limiting
4. Consider analytics integration
5. Add crash reporting

## Architecture

- **MVVM pattern** with SwiftUI
- **Reactive state management** via `@Published` and `@State`
- **Separation of concerns** between UI and business logic
- **Reusable components** for consistent design

## Performance

- Optimized SwiftData queries
- Lazy loading for large lists
- Efficient view updates via SwiftUI
- Minimal memory footprint

## License

This is a demonstration project for portfolio purposes.

---

**Development Time:** Approximately 3 days for full implementation
**Lines of Code:** ~2,500
**Supported Devices:** iPhone (iOS 17.0+)
