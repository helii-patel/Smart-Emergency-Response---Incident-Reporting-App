import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'incident_reporting_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({Key? key}) : super(key: key);

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = const [
    HomeScreen(),
    IncidentReportingScreen(),
    DashboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined),
            selectedIcon: Icon(Icons.track_changes),
            label: 'Tracking',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_alert_outlined),
            selectedIcon: Icon(Icons.add_alert),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}