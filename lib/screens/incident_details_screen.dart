import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';

class IncidentDetailsScreen extends StatefulWidget {
  final String incidentId;

  const IncidentDetailsScreen({
    Key? key,
    required this.incidentId,
  }) : super(key: key);

  @override
  State<IncidentDetailsScreen> createState() => _IncidentDetailsScreenState();
}

class _IncidentDetailsScreenState extends State<IncidentDetailsScreen> {
  late TextEditingController _responderController;

  @override
  void initState() {
    super.initState();
    _responderController = TextEditingController();
  }

  @override
  void dispose() {
    _responderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentProvider>(
      builder: (context, provider, child) {
        final incident = provider.allIncidents
            .firstWhere((i) => i.id == widget.incidentId, orElse: () => null as dynamic);

        if (incident == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Incident Details')),
            body: const Center(child: Text('Incident not found')),
          );
        }

        _responderController.text = incident.assignedResponder ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Incident Details'),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () => _showDeleteConfirmation(context, provider, incident),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with ID and Priority
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.getPriorityColor(incident.priorityEnum),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incident.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID: ${incident.id.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Chip(
                            label: Text(
                              AppTheme.getPriorityLabel(incident.priorityEnum),
                            ),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color:
                                  AppTheme.getPriorityColor(incident.priorityEnum),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Status Section
                _buildSection(
                  context,
                  'Status',
                  [
                    _buildStatusRow(context, incident),
                  ],
                ),
                const SizedBox(height: 24),

                // Category and Priority
                Row(
                  children: [
                    Expanded(
                      child: _buildSection(
                        context,
                        'Category',
                        [
                          Row(
                            children: [
                              Icon(
                                AppTheme.getCategoryIcon(incident.categoryEnum),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppTheme.getCategoryLabel(incident.categoryEnum),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSection(
                        context,
                        'Priority',
                        [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.getPriorityColor(incident.priorityEnum),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppTheme.getPriorityLabel(incident.priorityEnum),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                _buildSection(
                  context,
                  'Description',
                  [
                    Text(
                      incident.description,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Location
                _buildSection(
                  context,
                  'Location',
                  [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            incident.location,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Coordinates: ${incident.latitude.toStringAsFixed(4)}, ${incident.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Time Information
                _buildSection(
                  context,
                  'Timeline',
                  [
                    _buildTimelineItem(
                      'Reported',
                      DateFormat('MMM d, y, h:mm a').format(incident.reportedTime),
                      Colors.blue,
                    ),
                    if (incident.resolvedTime != null) ...[
                      const SizedBox(height: 12),
                      _buildTimelineItem(
                        'Resolved',
                        DateFormat('MMM d, y, h:mm a').format(incident.resolvedTime!),
                        Colors.green,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Admin Controls (for editing)
                _buildSection(
                  context,
                  'Admin Controls',
                  [
                    TextField(
                      controller: _responderController,
                      decoration: InputDecoration(
                        labelText: 'Assigned Responder',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateResponder(context, provider, incident),
                            child: const Text('Assign Responder'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._buildStatusUpdateButtons(context, provider, incident),
                  ],
                ),
                const SizedBox(height: 24),

                // Sync Status
                if (!incident.isSynced)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sync_disabled, color: Colors.orange[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This incident is stored locally and pending sync.',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, Incident incident) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.getStatusColor(incident.statusEnum),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppTheme.getStatusLabel(incident.statusEnum),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStatusUpdateButtons(
    BuildContext context,
    IncidentProvider provider,
    Incident incident,
  ) {
    final buttons = <Widget>[];

    if (incident.statusEnum != IncidentStatus.inProgress) {
      buttons.add(
        ElevatedButton(
          onPressed: () => _updateStatus(context, provider, incident, IncidentStatus.inProgress),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Mark as In Progress'),
        ),
      );
      buttons.add(const SizedBox(height: 12));
    }

    if (incident.statusEnum != IncidentStatus.resolved) {
      buttons.add(
        ElevatedButton(
          onPressed: () => _updateStatus(context, provider, incident, IncidentStatus.resolved),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Mark as Resolved'),
        ),
      );
      buttons.add(const SizedBox(height: 12));
    }

    return buttons;
  }

  void _updateStatus(
    BuildContext context,
    IncidentProvider provider,
    Incident incident,
    IncidentStatus status,
  ) {
    final updated = incident.copyWith(
      statusIndex: status.index,
      resolvedTime: status == IncidentStatus.resolved ? DateTime.now() : incident.resolvedTime,
    );
    provider.updateIncident(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to ${AppTheme.getStatusLabel(status)}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateResponder(
    BuildContext context,
    IncidentProvider provider,
    Incident incident,
  ) {
    if (_responderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter responder name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updated = incident.copyWith(
      assignedResponder: _responderController.text,
    );
    provider.updateIncident(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Responder assigned: ${_responderController.text}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    IncidentProvider provider,
    Incident incident,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Incident?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteIncident(incident.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Incident deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
