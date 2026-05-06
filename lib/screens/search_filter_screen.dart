import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';
import 'incident_details_screen.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
      ),
      body: Consumer<IncidentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                    provider.setSearchQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by ID or title...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Status'),
                      onSelected: (selected) {
                        if (selected) provider.setStatusFilter(null);
                      },
                      selected: provider.statusFilter == null,
                    ),
                    const SizedBox(width: 8),
                    ...IncidentStatus.values.map((status) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(AppTheme.getStatusLabel(status)),
                          backgroundColor:
                              AppTheme.getStatusColor(status).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: AppTheme.getStatusColor(status),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              provider.setStatusFilter(status);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // Priority Filter
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Priorities'),
                      onSelected: (selected) {
                        if (selected) provider.setPriorityFilter(null);
                      },
                      selected: provider.priorityFilter == null,
                    ),
                    const SizedBox(width: 8),
                    ...IncidentPriority.values.map((priority) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(AppTheme.getPriorityLabel(priority)),
                          backgroundColor:
                              AppTheme.getPriorityColor(priority).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: AppTheme.getPriorityColor(priority),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              provider.setPriorityFilter(priority);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // Category Filter
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Categories'),
                      onSelected: (selected) {
                        if (selected) provider.setCategoryFilter(null);
                      },
                      selected: provider.categoryFilter == null,
                    ),
                    const SizedBox(width: 8),
                    ...IncidentCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(AppTheme.getCategoryLabel(category)),
                          onSelected: (selected) {
                            if (selected) {
                              provider.setCategoryFilter(category);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // Results
              Expanded(
                child: provider.incidents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No incidents found',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.incidents.length,
                        itemBuilder: (context, index) {
                          final incident = provider.incidents[index];
                          return _buildIncidentCard(context, incident);
                        },
                      ),
              ),

              // Clear Filters Button
              if (provider.incidents.length !=
                  provider.allIncidents.length)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      provider.clearFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Clear All Filters'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, Incident incident) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final formattedTime = dateFormat.format(incident.reportedTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                IncidentDetailsScreen(incidentId: incident.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: AppTheme.getPriorityColor(incident.priorityEnum),
                width: 5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            incident.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${incident.id.substring(0, 8).toUpperCase()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.getPriorityColor(incident.priorityEnum),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppTheme.getPriorityLabel(incident.priorityEnum),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
                        Icon(
                          AppTheme.getCategoryIcon(incident.categoryEnum),
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppTheme.getCategoryLabel(incident.categoryEnum),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.getStatusColor(incident.statusEnum),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppTheme.getStatusLabel(incident.statusEnum),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
