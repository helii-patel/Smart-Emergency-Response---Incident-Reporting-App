import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import 'search_filter_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Dashboard'),
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
        ],
      ),
      body: Consumer<IncidentProvider>(
        builder: (context, provider, child) {
          final stats = provider.getPriorityDistribution();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildStatCard(context, 'Total Incidents', provider.totalIncidents.toString(), Colors.blue, Icons.report),
                    _buildStatCard(context, 'Active Cases', provider.activeIncidents.toString(), Colors.orange, Icons.hourglass_top),
                    _buildStatCard(context, 'Resolved', provider.resolvedIncidents.toString(), Colors.green, Icons.check_circle),
                    _buildStatCard(context, 'Critical', stats['critical'].toString(), Colors.red, Icons.warning),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Priority Distribution', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                _buildPriorityChart(stats),
                const SizedBox(height: 24),
                if (provider.getUnsyncedIncidents().isNotEmpty)
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
                            '${provider.getUnsyncedIncidents().length} incident(s) pending sync',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChart(Map<String, int> stats) {
    return Column(
      children: [
        _buildPriorityBar('Critical', stats['critical'] ?? 0, Colors.red),
        _buildPriorityBar('High', stats['high'] ?? 0, Colors.orange),
        _buildPriorityBar('Medium', stats['medium'] ?? 0, Colors.amber),
        _buildPriorityBar('Low', stats['low'] ?? 0, Colors.green),
      ],
    );
  }

  Widget _buildPriorityBar(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(count.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count > 0 ? count / 10.0 : 0,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}