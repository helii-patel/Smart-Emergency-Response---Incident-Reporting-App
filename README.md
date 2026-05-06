# Emergency Response App - Development Guide

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── incident.dart        # Incident model with Hive annotations
├── providers/
│   └── incident_provider.dart # State management using Provider
├── services/
│   └── local_storage_service.dart # Hive database operations
├── screens/
│   ├── home_screen.dart     # Main dashboard and incident list
│   ├── incident_reporting_screen.dart # Report new incident
│   ├── incident_details_screen.dart   # View & manage incident details
│   └── search_filter_screen.dart      # Search and filter incidents
└── utils/
    └── app_theme.dart       # Theme, colors, and utilities
```

## Architecture

The app follows a clean, modular architecture:

1. **Models**: Hive-based persistent data models
2. **Services**: Database and local storage operations
3. **Providers**: State management using Provider package
4. **Screens**: UI layers
5. **Utils**: Theme and helper functions

## Key Features

### 1. Incident Reporting
- Users can quickly report incidents with:
  - Title and description
  - Category selection (Medical, Fire, Security, Accident, Other)
  - Priority level (Low, Medium, High, Critical)
  - Location (GPS or simulated)
  - Automatic Incident ID generation (UUID)

### 2. Priority Handling Logic
- Incidents are automatically sorted by:
  1. Priority level (Critical → High → Medium → Low)
  2. Report time (Latest first)
- Critical incidents are visually highlighted with red color
- Color-coded priority indicators:
  - Red: Critical
  - Orange: High
  - Yellow: Medium
  - Green: Low

### 3. Incident Tracking
- Status tracking: Reported → In Progress → Resolved
- Automatic timestamps for each state
- Admin can assign responders
- Real-time status updates

### 4. Admin Dashboard
- Statistics:
  - Total incidents
  - Active cases
  - Resolved cases
  - Priority-wise distribution
- Visual charts and indicators
- Priority distribution overview

### 5. Search & Filter Module
- Search by:
  - Incident ID
  - Title/keywords
- Filter by:
  - Status (Reported, In Progress, Resolved)
  - Priority (Critical, High, Medium, Low)
  - Category (Medical, Fire, Security, Accident, Other)
- Real-time filtering with results count

### 6. Offline Functionality
- All incidents stored locally using Hive
- Automatic sync tracking
- Unsynced incidents clearly marked
- Data persists across app restarts
- Future: Backend sync capability

## State Management

The app uses **Provider pattern** for state management:

```dart
IncidentProvider
├── incidents (filtered list)
├── allIncidents (all incidents)
├── addIncident()
├── updateIncident()
├── deleteIncident()
├── setStatusFilter()
├── setPriorityFilter()
├── setCategoryFilter()
├── setSearchQuery()
└── clearFilters()
```

## Local Storage (Hive)

Incidents are stored in Hive with:
- Persistent storage
- Fast access
- Type-safe queries
- Offline support
- Sync status tracking

## User Flow

### Reporting an Incident:
1. Tap "+" button on home screen
2. Fill incident details
3. Select category and priority
4. Get location (GPS or simulated)
5. Submit report
6. Incident appears in list immediately

### Managing Incidents (Admin):
1. View incident details
2. Assign responder
3. Update status (In Progress → Resolved)
4. Track resolution time

### Searching Incidents:
1. Navigate to Search tab
2. Enter search query (ID or title)
3. Apply filters (status, priority, category)
4. View filtered results

## Technical Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider 6.0
- **Local Storage**: Hive 2.2
- **Location**: Geolocator 9.0
- **UUID**: UUID 4.0
- **Date/Time**: intl 0.19

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/helii-patel/Smart-Emergency-Response-Incident-Reporting-App.git
cd emergency_response_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Hive Adapters
```bash
flutter pub run build_runner build
```

### 4. Run the App
```bash
flutter run
```

## Building APK

```bash
flutter build apk --release
```

## Testing

### Test Scenarios:
1. **Report Incident**: Create incidents with different priorities
2. **Filter & Search**: Test all filter combinations
3. **Status Updates**: Change incident status and verify
4. **Offline**: Disable internet and report incidents
5. **Priority Sorting**: Verify critical incidents appear first

## Future Enhancements

1. **Backend Integration**: Firebase/REST API sync
2. **Real-time Maps**: Google Maps integration for location visualization
3. **Notifications**: Push notifications for critical incidents
4. **Analytics**: Incident statistics and trends
5. **Multi-language Support**: Localization
6. **Voice Reporting**: Voice-to-text incident reporting
7. **Export Reports**: PDF/Excel export functionality
8. **User Roles**: Different access levels (User, Responder, Admin)
9. **Incident History**: Archive and historical analytics
10. **Real GPS Integration**: Actual device location with map

## Security Considerations

- Input validation on all forms
- Error handling for network/location issues
- Local data encryption (future enhancement)
- Secure authentication (future enhancement)

## Performance Optimizations

- Efficient list rendering with ListView.builder
- Provider for state management (minimal rebuilds)
- Hive for O(1) database access
- Async/await for non-blocking operations

## License

Educational Project for Smart Campus Emergency Response System

## Author

Heli Patel - B.Tech Student
