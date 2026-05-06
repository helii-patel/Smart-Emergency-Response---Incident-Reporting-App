# Smart Emergency Response App - Setup Guide

## Prerequisites

Before setting up the project, ensure you have:
- **Flutter SDK** (version 3.0.0 or higher)
- **Dart SDK** (comes with Flutter)
- **Android SDK** (for Android development)
- **Xcode** (for iOS development on macOS)
- **Git** (for version control)
- **Android Studio** or **VS Code** with Flutter extensions

## System Requirements

### Minimum
- RAM: 4GB
- Disk Space: 5GB
- OS: Windows 10+, macOS 10.15+, Linux (Ubuntu 20.04+)

### Recommended
- RAM: 8GB+
- Disk Space: 10GB+
- Latest OS version

## Installation Steps

### 1. Install Flutter

**Windows**:
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to a folder (e.g., C:\flutter)
# Add Flutter to PATH:
# - Control Panel → System → Environment Variables
# - Add C:\flutter\bin to PATH

# Verify installation
flutter --version
dart --version
```

**macOS**:
```bash
# Using Homebrew
brew install flutter

# Or download from https://flutter.dev/docs/get-started/install/macos
# Add to ~/.zshrc or ~/.bash_profile:
export PATH="$PATH:/Users/username/development/flutter/bin"

# Verify
flutter --version
```

**Linux**:
```bash
# Download Flutter SDK
# Extract and add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/flutter/bin"

# Verify
flutter --version
```

### 2. Check Development Environment

```bash
flutter doctor
```

This command checks your environment and shows any missing components.

### 3. Clone the Repository

```bash
git clone https://github.com/helii-patel/Smart-Emergency-Response-Incident-Reporting-App.git
cd Smart-Emergency-Response-Incident-Reporting-App
```

### 4. Install Dependencies

```bash
flutter pub get
```

This installs all required packages from pubspec.yaml.

### 5. Generate Hive Adapters

```bash
flutter pub run build_runner build
```

This generates the required Hive adapter files for database operations.

### 6. Run the Application

#### On Android Emulator
```bash
# Start Android emulator
emulator -avd <emulator_name>

# Run the app
flutter run
```

#### On Android Device
```bash
# Connect your Android device via USB
# Enable USB debugging on device

# Run the app
flutter run
```

#### On iOS Simulator (macOS only)
```bash
# Start iOS simulator
open -a Simulator

# Run the app
flutter run
```

#### On iOS Device (macOS only)
```bash
# Run the app (prompts for iOS build)
flutter run
```

#### On Web
```bash
flutter run -d chrome
```

### 7. Build Release APK (Optional)

```bash
# Build release APK
flutter build apk --release

# The APK will be available at:
# build/app/outputs/flutter-apk/app-release.apk

# Alternatively, build App Bundle for Google Play
flutter build appbundle --release
```

## Project Structure Overview

```
.
├── lib/                           # Source code
│   ├── main.dart                  # App entry point
│   ├── models/                    # Data models
│   │   └── incident.dart
│   ├── providers/                 # State management
│   │   └── incident_provider.dart
│   ├── screens/                   # UI Screens
│   │   ├── home_screen.dart
│   │   ├── incident_reporting_screen.dart
│   │   ├── incident_details_screen.dart
│   │   └── search_filter_screen.dart
│   ├── services/                  # Business logic
│   │   └── local_storage_service.dart
│   └── utils/                     # Utilities
│       └── app_theme.dart
│
├── android/                       # Android platform code
├── ios/                           # iOS platform code
├── web/                           # Web platform code
│
├── pubspec.yaml                   # Dependencies
├── analysis_options.yaml          # Linting rules
├── .gitignore                     # Git configuration
│
└── Documentation/
    ├── README.md                  # Quick start
    ├── PROJECT_SUMMARY.md         # Project overview
    ├── IMPLEMENTATION_GUIDE.md    # Implementation details
    ├── ARCHITECTURE.md            # System architecture
    ├── FEATURES.md                # Feature breakdown
    └── FUTURE_SCOPE.md            # Future enhancements
```

## Configuration

### Database
- **Type**: Hive (Local key-value database)
- **Location**: Device storage (app-specific directory)
- **Box Name**: "incidents"
- **Auto-encryption**: Ready (future enhancement)

### Permissions (Android)

The app requests:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### Permissions (iOS)

Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to report incidents accurately.</string>
```

## Development Workflow

### Running with Hot Reload
```bash
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit
```

### Code Analysis
```bash
flutter analyze
```

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test test/integration_test/
```

### Formatting Code
```bash
dart format lib/
```

## Debugging

### Enable Verbose Logging
```bash
flutter run -v
```

### Debug on Device
```bash
flutter run -d <device_id> --verbose
```

### Flutter DevTools
```bash
# Start DevTools
flutter pub global run devtools

# Then run your app
flutter run
```

## Common Issues & Solutions

### Issue: "Flutter not found"
**Solution**: Add Flutter to PATH and restart terminal

### Issue: "Android SDK not found"
**Solution**: 
```bash
flutter config --android-sdk <path-to-sdk>
```

### Issue: "CocoaPods not installed" (iOS)
**Solution**:
```bash
sudo gem install cocoapods
```

### Issue: Gradle build fails
**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Permission denied on device
**Solution**: Enable USB debugging
- Go to Settings → Developer Options → USB Debugging (enable)

### Issue: Hive adapter not generated
**Solution**:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build
```

## Environment Variables

Create `.env` file in project root (future use):
```
API_URL=https://api.example.com
DATABASE_ENCRYPTION_KEY=your-key-here
```

## Git Commands

### Clone Repository
```bash
git clone https://github.com/helii-patel/Smart-Emergency-Response-Incident-Reporting-App.git
```

### View Commit History
```bash
git log --oneline
```

### Create New Branch
```bash
git checkout -b feature/new-feature
```

### Commit Changes
```bash
git add .
git commit -m "Description of changes"
```

### Push Changes
```bash
git push origin main
```

## Performance Tips

1. **Use Release Mode**: Always test in release mode
   ```bash
   flutter run --release
   ```

2. **Profile Your App**: Use DevTools to profile
   ```bash
   flutter run --profile
   ```

3. **Minimize Rebuilds**: Use `Consumer` widget efficiently

4. **Use ListView.builder**: For long lists

5. **Lazy Load Data**: Load data as needed

## Documentation Navigation

- **Getting Started**: See `README.md`
- **Feature Details**: See `FEATURES.md`
- **Architecture**: See `ARCHITECTURE.md`
- **Implementation**: See `IMPLEMENTATION_GUIDE.md`
- **Roadmap**: See `FUTURE_SCOPE.md`
- **Summary**: See `PROJECT_SUMMARY.md`

## Support & Resources

### Official Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Database](https://pub.dev/packages/hive)

### Community
- [Flutter Community](https://flutter.dev/community)
- [StackOverflow Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)
- [r/Flutter](https://reddit.com/r/Flutter)

### Troubleshooting
- [Flutter Issues](https://github.com/flutter/flutter/issues)
- [Package Issues](https://pub.dev/)

## Next Steps

1. **Setup Complete**: Your environment is ready!
2. **Run the App**: Execute `flutter run`
3. **Explore Code**: Check out `lib/` directory
4. **Read Docs**: Understand architecture and features
5. **Contribute**: Make improvements and submit PRs

## Contribution Guidelines

1. Fork the repository
2. Create feature branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Open Pull Request

## License

This project is for educational purposes.

## Contact

For questions or support:
- **Author**: Heli Patel
- **Email**: heli.patel@example.com
- **GitHub**: https://github.com/helii-patel

---

**Happy Coding! 🚀**

Need help? Check the [GitHub Issues](https://github.com/helii-patel/Smart-Emergency-Response-Incident-Reporting-App/issues) or create a new one.
