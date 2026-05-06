import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../services/local_storage_service.dart';

class IncidentProvider extends ChangeNotifier {
  List<Incident> _incidents = [];
  List<Incident> _filteredIncidents = [];
  IncidentStatus? _statusFilter;
  IncidentPriority? _priorityFilter;
  IncidentCategory? _categoryFilter;
  String _searchQuery = '';

  IncidentProvider() {
    _loadIncidents();
  }

  // Getters
  List<Incident> get incidents => _filteredIncidents;
  List<Incident> get allIncidents => _incidents;
  int get totalIncidents => _incidents.length;
  int get activeIncidents =>
      _incidents.where((i) => i.statusEnum != IncidentStatus.resolved).length;
  int get resolvedIncidents =>
      _incidents.where((i) => i.statusEnum == IncidentStatus.resolved).length;

  // Load incidents from local storage
  void _loadIncidents() {
    _incidents = LocalStorageService.getAllIncidents();
    _sortAndFilter();
    notifyListeners();
  }

  // Add new incident
  Future<void> addIncident(Incident incident) async {
    await LocalStorageService.addIncident(incident);
    _loadIncidents();
  }

  // Update incident
  Future<void> updateIncident(Incident incident) async {
    await LocalStorageService.updateIncident(incident);
    _loadIncidents();
  }

  // Delete incident
  Future<void> deleteIncident(String id) async {
    await LocalStorageService.deleteIncident(id);
    _loadIncidents();
  }

  // Apply filters
  void setStatusFilter(IncidentStatus? status) {
    _statusFilter = status;
    _sortAndFilter();
    notifyListeners();
  }

  void setPriorityFilter(IncidentPriority? priority) {
    _priorityFilter = priority;
    _sortAndFilter();
    notifyListeners();
  }

  void setCategoryFilter(IncidentCategory? category) {
    _categoryFilter = category;
    _sortAndFilter();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _sortAndFilter();
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _categoryFilter = null;
    _searchQuery = '';
    _sortAndFilter();
    notifyListeners();
  }

  // Sort and filter incidents
  void _sortAndFilter() {
    _filteredIncidents = _incidents.where((incident) {
      bool matchesStatus =
          _statusFilter == null || incident.statusEnum == _statusFilter;
      bool matchesPriority =
          _priorityFilter == null || incident.priorityEnum == _priorityFilter;
      bool matchesCategory =
          _categoryFilter == null || incident.categoryEnum == _categoryFilter;
      bool matchesSearch = _searchQuery.isEmpty ||
          incident.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          incident.title.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesPriority && matchesCategory && matchesSearch;
    }).toList();

    // Sort by priority (critical first) and then by time (latest first)
    _filteredIncidents.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.reportedTime.compareTo(a.reportedTime);
    });
  }

  // Get incident statistics
  Map<String, int> getPriorityDistribution() {
    return {
      'critical':
          _incidents.where((i) => i.priorityEnum == IncidentPriority.critical).length,
      'high': _incidents.where((i) => i.priorityEnum == IncidentPriority.high).length,
      'medium': _incidents.where((i) => i.priorityEnum == IncidentPriority.medium).length,
      'low': _incidents.where((i) => i.priorityEnum == IncidentPriority.low).length,
    };
  }

  // Get unsynced incidents
  List<Incident> getUnsyncedIncidents() {
    return LocalStorageService.getUnsyncedIncidents();
  }

  // Mark incident as synced
  Future<void> markAsSynced(String id) async {
    await LocalStorageService.markAsSynced(id);
    _loadIncidents();
  }
}
