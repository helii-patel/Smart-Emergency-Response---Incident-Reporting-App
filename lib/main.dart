import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/app_shell_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/incident_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/role_provider.dart';
import 'services/local_storage_service.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IncidentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, theme, child) {
        return MaterialApp(
          title: 'Emergency Response App',
          theme: AppTheme.getThemeData(),
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: theme.mode,
          home: const AppEntryPoint(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleProvider>(
      builder: (context, role, child) {
        if (!role.isAuthenticated) {
          return const AuthScreen();
        }

        return const AppShellScreen();
      },
    );
  }
}
