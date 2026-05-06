import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import '../providers/role_provider.dart';
import '../providers/theme_provider.dart';
import 'admin_panel_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>();
    final incidents = context.watch<IncidentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, theme, child) {
              return IconButton(
                tooltip: theme.isDark ? 'Switch to light' : 'Switch to dark',
                icon: Icon(theme.isDark ? Icons.wb_sunny : Icons.nights_stay),
                onPressed: theme.toggle,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Text(
                      role.displayName.isNotEmpty ? role.displayName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(role.displayName, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(role.isAdmin ? 'Admin access enabled' : 'User access mode'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App Summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildInfoRow('Total incidents', incidents.totalIncidents.toString()),
                  _buildInfoRow('Active cases', incidents.activeIncidents.toString()),
                  _buildInfoRow('Resolved cases', incidents.resolvedIncidents.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (role.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Open Admin Dashboard'),
                subtitle: const Text('Manage priorities, responders, and case status'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                  );
                },
              ),
            )
          else
            const Card(
              child: ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Admin dashboard locked'),
                subtitle: Text('Switch to admin through the authentication screen to access management tools.'),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<RoleProvider>().logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}