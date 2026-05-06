import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'incident.g.dart';

enum IncidentCategory { medical, fire, security, accident, other }
enum IncidentStatus { reported, inProgress, resolved, archived }
enum IncidentPriority { low, medium, high, critical }

@HiveType(typeId: 0)
class Incident extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int category; // Stored as int for Hive compatibility

  @HiveField(4)
  final int priority; // Stored as int for Hive compatibility

  @HiveField(5)
  final int status; // Stored as int for Hive compatibility

  @HiveField(6)
  final double latitude;

  @HiveField(7)
  final double longitude;

  @HiveField(8)
  final String location;

  @HiveField(9)
  final DateTime reportedTime;

  @HiveField(10)
  final String? assignedResponder;

  @HiveField(11)
  final bool isSynced;

  @HiveField(12)
  final DateTime? resolvedTime;

  Incident({
    String? id,
    required this.title,
    required this.description,
    required int categoryIndex,
    required int priorityIndex,
    int? statusIndex,
    required this.latitude,
    required this.longitude,
    required this.location,
    DateTime? reportedTime,
    this.assignedResponder,
    bool? isSynced,
    this.resolvedTime,
  })  : id = id ?? const Uuid().v4(),
        category = categoryIndex,
        priority = priorityIndex,
        status = statusIndex ?? 0,
        reportedTime = reportedTime ?? DateTime.now(),
        isSynced = isSynced ?? false;

  IncidentCategory get categoryEnum =>
      IncidentCategory.values[category % IncidentCategory.values.length];

  IncidentPriority get priorityEnum =>
      IncidentPriority.values[priority % IncidentPriority.values.length];

  IncidentStatus get statusEnum =>
      IncidentStatus.values[status % IncidentStatus.values.length];

  // Copy method for creating updated instances
  Incident copyWith({
    String? title,
    String? description,
    int? categoryIndex,
    int? priorityIndex,
    int? statusIndex,
    double? latitude,
    double? longitude,
    String? location,
    DateTime? reportedTime,
    String? assignedResponder,
    bool? isSynced,
    DateTime? resolvedTime,
  }) {
    return Incident(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryIndex: categoryIndex ?? this.category,
      priorityIndex: priorityIndex ?? this.priority,
      statusIndex: statusIndex ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      reportedTime: reportedTime ?? this.reportedTime,
      assignedResponder: assignedResponder ?? this.assignedResponder,
      isSynced: isSynced ?? this.isSynced,
      resolvedTime: resolvedTime ?? this.resolvedTime,
    );
  }
}
