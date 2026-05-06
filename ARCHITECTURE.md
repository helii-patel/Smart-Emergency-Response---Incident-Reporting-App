# Emergency Response App - Architecture Document

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐   │
│  │   Home      │  │  Incident    │  │   Incident      │   │
│  │   Screen    │  │  Reporting   │  │   Details       │   │
│  │             │  │   Screen     │  │   Screen        │   │
│  └─────────────┘  └──────────────┘  └─────────────────┘   │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Search & Filter Screen                       │   │
│  │  - Search Bar | Status Filters | Priority Filters   │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
└────────────────────────────────────┬────────────────────────┘
                                     │
┌────────────────────────────────────v────────────────────────┐
│                  STATE MANAGEMENT LAYER                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  IncidentProvider (ChangeNotifier)                   │   │
│  │  - incidents: List<Incident>                         │   │
│  │  - filteredIncidents: List<Incident>               │   │
│  │  - statusFilter: IncidentStatus?                    │   │
│  │  - priorityFilter: IncidentPriority?                │   │
│  │  - categoryFilter: IncidentCategory?                │   │
│  │  - searchQuery: String                              │   │
│  │                                                       │   │
│  │  Methods:                                            │   │
│  │  - addIncident(incident)                           │   │
│  │  - updateIncident(incident)                        │   │
│  │  - deleteIncident(id)                              │   │
│  │  - setStatusFilter(status)                         │   │
│  │  - setPriorityFilter(priority)                     │   │
│  │  - setCategoryFilter(category)                     │   │
│  │  - setSearchQuery(query)                           │   │
│  │  - clearFilters()                                  │   │
│  │  - getPriorityDistribution()                       │   │
│  │  - _sortAndFilter() [Private]                      │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
└────────────────────────────────────┬────────────────────────┘
                                     │
┌────────────────────────────────────v────────────────────────┐
│                   BUSINESS LOGIC LAYER                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Priority Handling Algorithm                        │    │
│  │  1. Sort by Priority (Critical → High → Med → Low)  │    │
│  │  2. Secondary sort by Time (Latest first)           │    │
│  │  3. Apply filters (AND logic)                       │    │
│  │  4. Update UI                                       │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Filtering Logic                                    │    │
│  │  - Multi-field AND filtering                        │    │
│  │  - Case-insensitive search                          │    │
│  │  - Real-time results                                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Status Management                                  │    │
│  │  - Reported → In Progress → Resolved                │    │
│  │  - Timestamp tracking                               │    │
│  │  - Admin assignment                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
└────────────────────────────────────┬────────────────────────┘
                                     │
┌────────────────────────────────────v────────────────────────┐
│                    DATA ACCESS LAYER                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  LocalStorageService                                │   │
│  │  - initialize()                                      │   │
│  │  - addIncident(incident)                           │   │
│  │  - updateIncident(incident)                        │   │
│  │  - deleteIncident(id)                              │   │
│  │  - getAllIncidents()                               │   │
│  │  - getIncidentById(id)                             │   │
│  │  - getUnsyncedIncidents()                          │   │
│  │  - markAsSynced(id)                                │   │
│  │  - clearAllIncidents()                             │   │
│  │  - close()                                          │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
└────────────────────────────────────┬────────────────────────┘
                                     │
┌────────────────────────────────────v────────────────────────┐
│                     PERSISTENCE LAYER                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Hive Database                                       │   │
│  │  - Box: "incidents"                                 │   │
│  │  - Key: Incident ID (UUID)                          │   │
│  │  - Type: Incident (Hive Object)                     │   │
│  │  - Persistence: Device storage                      │   │
│  │  - Sync Status: Tracked per incident                │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Local File System                                   │   │
│  │  - Hive data files                                   │   │
│  │  - Lock files                                        │   │
│  │  - Backup/Restore capability                        │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

### Create Incident Flow
```
┌─────────────────┐
│   User Input    │
│  (Form Fields)  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Form Validation                │
│  - Required fields check        │
│  - Location validation          │
│  - Length validation            │
└────────┬────────────────────────┘
         │ Valid
         ▼
┌─────────────────────────────────┐
│  Create Incident Object         │
│  - Generate UUID                │
│  - Set timestamp                │
│  - Set default values           │
│  - Mark as unsynced             │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ IncidentProvider.addIncident()  │
│  - Add to memory list           │
│  - Call sort and filter         │
│  - Notify listeners             │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ LocalStorageService.addIncident │
│  - Save to Hive database        │
│  - Persist to disk              │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  UI Update                      │
│  - Incident appears in list     │
│  - Dashboard updates            │
│  - Success message shown        │
└─────────────────────────────────┘
```

### Filter Incidents Flow
```
┌────────────────────┐
│  User Input:       │
│  - Search query    │
│  - Status filter   │
│  - Priority filter │
│  - Category filter │
└────────┬───────────┘
         │
         ▼
┌──────────────────────────────────┐
│ Update Filter in Provider        │
│  - setSearchQuery()              │
│  - setStatusFilter()             │
│  - setPriorityFilter()           │
│  - setCategoryFilter()           │
└────────┬─────────────────────────┘
         │
         ▼
┌──────────────────────────────────┐
│ _sortAndFilter() Execution       │
│  1. Where clause (AND logic):    │
│     - matchesStatus              │
│     - matchesPriority            │
│     - matchesCategory            │
│     - matchesSearch              │
│  2. Sort by priority (desc)      │
│  3. Sort by time (desc)          │
│  4. Update _filteredIncidents    │
└────────┬─────────────────────────┘
         │
         ▼
┌──────────────────────────────────┐
│ notifyListeners()                │
│ - Alert UI of changes            │
│ - Rebuild affected widgets       │
└────────┬─────────────────────────┘
         │
         ▼
┌──────────────────────────────────┐
│ Display Filtered Results         │
│  - Show matching incidents       │
│  - Update result count           │
│  - Empty state if no results     │
└──────────────────────────────────┘
```

## Component Structure

### Models (lib/models/)
```
incident.dart
├── Incident class (HiveObject)
│   ├── id: String
│   ├── title: String
│   ├── description: String
│   ├── category: int (enum index)
│   ├── priority: int (enum index)
│   ├── status: int (enum index)
│   ├── latitude: double
│   ├── longitude: double
│   ├── location: String
│   ├── reportedTime: DateTime
│   ├── resolvedTime: DateTime?
│   ├── assignedResponder: String?
│   ├── isSynced: bool
│   └── Methods:
│       ├── categoryEnum (getter)
│       ├── priorityEnum (getter)
│       ├── statusEnum (getter)
│       └── copyWith()
└── Enums:
    ├── IncidentCategory
    ├── IncidentPriority
    └── IncidentStatus
```

### Services (lib/services/)
```
local_storage_service.dart
├── Static class LocalStorageService
│   ├── _incidentsBox: Box<Incident>
│   ├── initialize(): Future<void>
│   ├── addIncident(incident): Future<void>
│   ├── updateIncident(incident): Future<void>
│   ├── deleteIncident(id): Future<void>
│   ├── getAllIncidents(): List<Incident>
│   ├── getIncidentById(id): Incident?
│   ├── getUnsyncedIncidents(): List<Incident>
│   ├── markAsSynced(id): Future<void>
│   └── clearAllIncidents(): Future<void>
```

### Providers (lib/providers/)
```
incident_provider.dart
├── class IncidentProvider extends ChangeNotifier
│   ├── Properties:
│   │   ├── _incidents: List<Incident>
│   │   ├── _filteredIncidents: List<Incident>
│   │   ├── _statusFilter: IncidentStatus?
│   │   ├── _priorityFilter: IncidentPriority?
│   │   ├── _categoryFilter: IncidentCategory?
│   │   └── _searchQuery: String
│   │
│   ├── Getters:
│   │   ├── incidents
│   │   ├── allIncidents
│   │   ├── totalIncidents
│   │   ├── activeIncidents
│   │   └── resolvedIncidents
│   │
│   ├── Methods:
│   │   ├── addIncident()
│   │   ├── updateIncident()
│   │   ├── deleteIncident()
│   │   ├── setStatusFilter()
│   │   ├── setPriorityFilter()
│   │   ├── setCategoryFilter()
│   │   ├── setSearchQuery()
│   │   ├── clearFilters()
│   │   ├── getPriorityDistribution()
│   │   ├── getUnsyncedIncidents()
│   │   ├── markAsSynced()
│   │   └── _sortAndFilter() [Private]
└   └── _loadIncidents() [Private]
```

### UI Screens (lib/screens/)
```
home_screen.dart
├── HomeScreen (StatefulWidget)
│   ├── _buildIncidentsTab()
│   │   └── ListView of incidents
│   ├── _buildDashboardTab()
│   │   ├── Statistics cards
│   │   ├── Priority chart
│   │   └── Sync status
│   └── Tab bar switching

incident_reporting_screen.dart
├── IncidentReportingScreen (StatefulWidget)
│   ├── Form fields
│   ├── Category chips
│   ├── Priority chips
│   ├── Location input (GPS/Simulate)
│   ├── Validation logic
│   └── Submission handler

incident_details_screen.dart
├── IncidentDetailsScreen (StatefulWidget)
│   ├── Header (title + priority)
│   ├── Status section
│   ├── Details section
│   ├── Timeline section
│   ├── Admin controls
│   │   ├── Responder assignment
│   │   └── Status update buttons
│   └── Delete functionality

search_filter_screen.dart
└── SearchFilterScreen (StatefulWidget)
    ├── Search bar
    ├── Status filters
    ├── Priority filters
    ├── Category filters
    ├── Results list
    └── Clear filters button
```

### Utilities (lib/utils/)
```
app_theme.dart
├── class AppTheme
│   ├── Colors (constants)
│   │   ├── Priority colors
│   │   ├── Status colors
│   │   └── Theme colors
│   │
│   ├── Theme builder
│   │   └── getThemeData(): ThemeData
│   │
│   └── Utility functions
│       ├── getPriorityColor()
│       ├── getStatusColor()
│       ├── getPriorityLabel()
│       ├── getStatusLabel()
│       ├── getCategoryLabel()
│       └── getCategoryIcon()
```

## Database Schema (Hive)

```
Box: "incidents"
├── Key: <UUID>
└── Value: Incident
    ├── @HiveField(0) id: String
    ├── @HiveField(1) title: String
    ├── @HiveField(2) description: String
    ├── @HiveField(3) category: int (0-4)
    ├── @HiveField(4) priority: int (0-3)
    ├── @HiveField(5) status: int (0-3)
    ├── @HiveField(6) latitude: double
    ├── @HiveField(7) longitude: double
    ├── @HiveField(8) location: String
    ├── @HiveField(9) reportedTime: DateTime
    ├── @HiveField(10) assignedResponder: String?
    ├── @HiveField(11) isSynced: bool
    └── @HiveField(12) resolvedTime: DateTime?
```

## State Management Flow

```
┌──────────────────────────────────────────┐
│  Event: User Action (Input)              │
└────────────────┬─────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────┐
│  Business Logic Processing               │
│  - Validation                            │
│  - Calculation                           │
│  - Transformation                        │
└────────────────┬─────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────┐
│  State Update (Provider)                 │
│  - Modify state variables                │
│  - Call notifyListeners()                │
└────────────────┬─────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────┐
│  Data Persistence                        │
│  - Save to Hive                          │
│  - Track sync status                     │
└────────────────┬─────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────┐
│  UI Rebuild (Consumer/Listener)          │
│  - Rebuild affected widgets              │
│  - Update display                        │
│  - Show feedback                         │
└──────────────────────────────────────────┘
```

## Dependency Injection

```dart
// main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => IncidentProvider(),
    ),
  ],
  child: MaterialApp(...),
)

// In widgets: context.read<IncidentProvider>()
//             context.watch<IncidentProvider>()
```

## Error Handling Strategy

```
┌─────────────────────────────┐
│  Try Block (Operation)      │
└────────────┬────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
   Success      Exception
      │             │
      ├─────┬───────┤
      │     │       │
   Update  Log    Handle
   State   Error  Error
      │     │       │
      └──┬──┴───┬──┘
         │      │
      Show    Show
    Success   Error
    Message   Message
```

## Performance Considerations

1. **List Rendering**
   - ListView.builder for lazy loading
   - Only visible items rendered
   - SliverAppBar for smooth scrolling

2. **State Management**
   - Consumer for targeted rebuilds
   - Separate providers for independent state
   - Computed properties for derived data

3. **Database Operations**
   - Async/await for non-blocking
   - Batch operations where possible
   - Connection pooling (future)

4. **Memory Management**
   - Dispose controllers properly
   - Cancel subscriptions
   - Weak references where needed

## Scalability Considerations

### Current Limitations
- Single device storage
- No backend sync
- Limited to app capacity

### Future Improvements
- Cloud backend integration
- Database replication
- Caching strategies
- Pagination for large datasets

## Testing Strategy

### Unit Tests
- Model tests (Incident)
- Provider tests (filtering, sorting)
- Service tests (CRUD operations)

### Widget Tests
- Screen rendering
- User interactions
- Navigation

### Integration Tests
- End-to-end workflows
- Data persistence
- Multi-screen flows

---

This architecture provides a solid, scalable foundation for the emergency response app with clear separation of concerns and room for future expansion.
