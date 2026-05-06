import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../providers/role_provider.dart';
import '../utils/app_theme.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<RoleProvider>().isAdmin;

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Admin access required. Use the authentication screen to sign in as an admin.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Consumer<IncidentProvider>(builder: (context, provider, child) {
        final incidents = provider.allIncidents;
        if (incidents.isEmpty) {
          return Center(child: Text('No incidents available'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: incidents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final inc = incidents[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(inc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Text(inc.id.substring(0,8).toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(inc.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: inc.statusEnum == IncidentStatus.inProgress
                              ? null
                              : () => provider.updateIncident(inc.copyWith(statusIndex: IncidentStatus.inProgress.index)),
                          child: const Text('Mark In Progress'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.inProgressColor),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: inc.statusEnum == IncidentStatus.resolved
                              ? null
                              : () => provider.updateIncident(inc.copyWith(statusIndex: IncidentStatus.resolved.index, resolvedTime: DateTime.now())),
                          child: const Text('Resolve'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _assignResponderDialog(context, provider, inc),
                          child: const Text('Assign Responder'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _assignResponderDialog(BuildContext context, IncidentProvider provider, Incident inc) {
    final controller = TextEditingController(text: inc.assignedResponder ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Responder'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Responder name or ID')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final updated = inc.copyWith(assignedResponder: controller.text);
              await provider.updateIncident(updated);
              Navigator.pop(context);
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
