import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../providers/role_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import 'admin_panel_screen.dart';
import 'incident_details_screen.dart';
import 'incident_reporting_screen.dart';
import 'search_filter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Tracking'),
        actions: [
          IconButton(
            tooltip: 'Search & Filter',
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchFilterScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, theme, child) {
              return IconButton(
                tooltip: theme.isDark ? 'Switch to light' : 'Switch to dark',
                icon: Icon(theme.isDark ? Icons.wb_sunny : Icons.nights_stay),
                onPressed: theme.toggle,
              );
            },
          ),
          Consumer<RoleProvider>(
            builder: (context, role, child) {
              if (!role.isAdmin) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: 'Open Admin Dashboard',
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IncidentReportingScreen()),
          );
        },
        icon: const Icon(Icons.add_alert),
        label: const Text('Report Incident'),
      ),
      body: Consumer<IncidentProvider>(
        builder: (context, provider, child) {
          if (provider.incidents.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 72, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No incidents reported yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use the report button to submit an incident with location and priority.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const IncidentReportingScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_alert),
                      label: const Text('Report First Incident'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.incidents.length,
            itemBuilder: (context, index) {
              return _buildIncidentCard(context, provider.incidents[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, Incident incident) {
    final formattedTime = DateFormat('MMM d, h:mm a').format(incident.reportedTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => IncidentDetailsScreen(incidentId: incident.id)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border(
              left: BorderSide(
                color: AppTheme.getPriorityColor(incident.priorityEnum),
                width: 6,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incident.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Incident ID: ${incident.id.toUpperCase()}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: incident.id));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Incident ID copied')),
                                  );
                                },
                                child: Icon(Icons.copy, size: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.getPriorityColor(incident.priorityEnum),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppTheme.getPriorityLabel(incident.priorityEnum),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(AppTheme.getCategoryIcon(incident.categoryEnum), size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          AppTheme.getCategoryLabel(incident.categoryEnum),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.getStatusColor(incident.statusEnum),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppTheme.getStatusLabel(incident.statusEnum),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(formattedTime, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                if (incident.location.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          incident.location,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}