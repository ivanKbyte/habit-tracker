# Firebase Authentication Setup

## Overview

This guide covers Firebase integration for the HabitTracker application. Firebase provides user authentication, secure data storage, and password reset functionality.

**Estimated Setup Time:** 30 minutes

## Step 1: Firebase Console Configuration

### Create Project

1. Navigate to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name (e.g., "HabitTracker")
4. Disable Google Analytics (optional for demo)
5. Click "Create project"

### Register iOS App

1. Select iOS platform
2. Enter bundle identifier (must match Xcode: e.g., `com.yourname.habittracker`)
3. Download `GoogleService-Info.plist`
4. Complete registration

### Enable Authentication

1. Navigate to Build → Authentication
2. Click "Get started"
3. Enable "Email/Password" sign-in method

### Create Firestore Database

1. Navigate to Build → Firestore Database
2. Click "Create database"
3. Select "Start in test mode"
4. Choose closest location
5. Click "Enable"

## Step 2: Xcode Integration

### Add Configuration File

1. Drag `GoogleService-Info.plist` into Xcode project
2. Ensure "Copy items if needed" is checked
3. Verify target membership

### Install Firebase SDK

1. File → Add Package Dependencies
2. URL: `https://github.com/firebase/firebase-ios-sdk`
3. Version: 10.0.0 (Up to Next Major)
4. Select products:
   - FirebaseAuth
   - FirebaseFirestore

### Add Source Files

Create these Swift files with provided code:

1. `AuthenticationManager.swift`
2. `LoginView.swift`
3. `SignUpView.swift`
4. `ForgotPasswordView.swift`
5. `ProfileView.swift`

Update existing files:

1. `HabitTrackerApp.swift` - Firebase initialization
2. `ContentView.swift` - Authentication handling

### Verify Bundle Identifier

Ensure Xcode bundle identifier matches Firebase configuration:

1. Select project → Target
2. Signing & Capabilities tab
3. Verify Bundle Identifier

## Step 3: Testing

### Build Application

```bash
# Clean build
Cmd + Shift + K

# Build
Cmd + B

# Run
Cmd + R
```

### Test Authentication Flow

1. Launch application (opens to login screen)
2. Click "Sign Up"
3. Enter test credentials
4. Verify account creation
5. Test sign out
6. Test sign in with created credentials
7. Verify password reset email delivery

### Verify Firebase Integration

1. Open Firebase Console
2. Navigate to Authentication → Users
3. Confirm test user appears
4. Check Firestore → users collection for profile data

## Architecture

### Authentication Manager

Handles all authentication operations:
- User sign up with profile creation
- Sign in with email/password
- Password reset via email
- Sign out
- Authentication state management

### Data Flow

1. User enters credentials
2. AuthenticationManager communicates with Firebase
3. Success: User redirected to main app
4. Failure: Error displayed with haptic feedback

### Security

- Passwords hashed by Firebase
- Secure HTTPS communication
- Test mode Firestore rules (update for production)

## Troubleshooting

### Common Issues

**Package Resolution Failure**
- Check internet connection
- File → Packages → Reset Package Caches
- Restart Xcode

**GoogleService-Info.plist Not Found**
- Verify file location (project root)
- Check target membership in File Inspector

**Authentication Errors**
- Confirm Email/Password enabled in Firebase Console
- Verify bundle identifier matches
- Check console logs for detailed error messages

**Build Errors**
- Ensure correct Firebase packages installed
- Clean build folder
- File → Packages → Update to Latest Package Versions

## Production Deployment

Before production release:

1. Update Firestore security rules
2. Implement data validation
3. Add rate limiting
4. Enable App Check
5. Set up monitoring and alerts

## File Structure

```
HabitTracker/
├── GoogleService-Info.plist (NEW)
├── HabitTrackerApp.swift (UPDATED)
├── ContentView.swift (UPDATED)
├── Managers/
│   └── AuthenticationManager.swift (NEW)
└── Views/
    ├── LoginView.swift (NEW)
    ├── SignUpView.swift (NEW)
    ├── ForgotPasswordView.swift (NEW)
    └── ProfileView.swift (NEW)
```

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [Firebase Authentication Guide](https://firebase.google.com/docs/auth)

---

**Note:** Test mode Firestore rules allow unrestricted access. Implement proper security rules before production deployment.
