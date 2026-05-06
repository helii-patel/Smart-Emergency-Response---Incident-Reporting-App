import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../providers/theme_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _adminNameController.dispose();
    _adminCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF101828), Color(0xFF1D4ED8), Color(0xFF0F766E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(Icons.emergency, color: Theme.of(context).colorScheme.primary, size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Emergency Response',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Choose the user side or sign in to the admin side.',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
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
                        const SizedBox(height: 24),
                        _buildUserPanel(context),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildAdminPanel(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Continue as User', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _userNameController,
          decoration: const InputDecoration(
            labelText: 'Display name (optional)',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<RoleProvider>().loginAsUser(
                    name: _userNameController.text.trim().isEmpty
                        ? 'User'
                        : _userNameController.text.trim(),
                  );
            },
            icon: const Icon(Icons.login),
            label: const Text('Enter User App'),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Admin Access', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Only authorized admins can view the admin dashboard and update case status.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _adminNameController,
          decoration: const InputDecoration(
            labelText: 'Admin name',
            prefixIcon: Icon(Icons.badge),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _adminCodeController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Admin access code',
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              final role = context.read<RoleProvider>();
              if (!role.isValidAdminCode(_adminCodeController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid admin access code'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              role.loginAsAdmin(
                name: _adminNameController.text.trim().isEmpty
                    ? 'Admin'
                    : _adminNameController.text.trim(),
              );
            },
            icon: const Icon(Icons.admin_panel_settings),
            label: const Text('Enter Admin App'),
          ),
        ),
      ],
    );
  }
}