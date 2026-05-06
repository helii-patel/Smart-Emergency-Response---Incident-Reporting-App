import 'package:hive_flutter/hive_flutter.dart';
import '../models/incident.dart';

class LocalStorageService {
  static const String incidentsBoxName = 'incidents';
  static late Box<Incident> _incidentsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(IncidentAdapter());
    _incidentsBox = await Hive.openBox<Incident>(incidentsBoxName);
  }

  static Box<Incident> get incidentsBox => _incidentsBox;

  // Add a new incident
  static Future<void> addIncident(Incident incident) async {
    await _incidentsBox.put(incident.id, incident);
  }

  // Get all incidents
  static List<Incident> getAllIncidents() {
    return _incidentsBox.values.toList();
  }

  // Get incident by ID
  static Incident? getIncidentById(String id) {
    return _incidentsBox.get(id);
  }

  // Update incident
  static Future<void> updateIncident(Incident incident) async {
    await _incidentsBox.put(incident.id, incident);
  }

  // Delete incident
  static Future<void> deleteIncident(String id) async {
    await _incidentsBox.delete(id);
  }

  // Get unsynced incidents
  static List<Incident> getUnsyncedIncidents() {
    final incidents = _incidentsBox.values.toList();
    return incidents.where((incident) => !incident.isSynced).toList();
  }

  // Mark incident as synced
  static Future<void> markAsSynced(String id) async {
    final incident = _incidentsBox.get(id);
    if (incident != null) {
      final updated = incident.copyWith(isSynced: true);
      await _incidentsBox.put(id, updated);
    }
  }

  // Clear all incidents
  static Future<void> clearAllIncidents() async {
    await _incidentsBox.clear();
  }

  // Close database
  static Future<void> close() async {
    await Hive.close();
  }
}