import 'package:flutter/material.dart';
import '../models/incident.dart';

class AppTheme {
  // Priority Colors
  static const Color criticalColor = Color(0xFFD32F2F); // Red
  static const Color highColor = Color(0xFFFF6F00); // Orange
  static const Color mediumColor = Color(0xFFFBC02D); // Yellow
  static const Color lowColor = Color(0xFF388E3C); // Green

  // Status Colors
  static const Color reportedColor = Color(0xFF1976D2); // Blue
  static const Color inProgressColor = Color(0xFF0097A7); // Cyan
  static const Color resolvedColor = Color(0xFF388E3C); // Green

  // Primary colors
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF00BCD4);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);

  // Text colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textHintColor = Color(0xFFBDBDBD);

  static ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Get priority color
  static Color getPriorityColor(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return criticalColor;
      case IncidentPriority.high:
        return highColor;
      case IncidentPriority.medium:
        return mediumColor;
      case IncidentPriority.low:
        return lowColor;
    }
  }

  // Get status color
  static Color getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.reported:
        return reportedColor;
      case IncidentStatus.inProgress:
        return inProgressColor;
      case IncidentStatus.resolved:
        return resolvedColor;
      case IncidentStatus.archived:
        return Colors.grey;
    }
  }

  // Get priority label
  static String getPriorityLabel(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return 'Critical';
      case IncidentPriority.high:
        return 'High';
      case IncidentPriority.medium:
        return 'Medium';
      case IncidentPriority.low:
        return 'Low';
    }
  }

  // Get status label
  static String getStatusLabel(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.reported:
        return 'Reported';
      case IncidentStatus.inProgress:
        return 'In Progress';
      case IncidentStatus.resolved:
        return 'Resolved';
      case IncidentStatus.archived:
        return 'Archived';
    }
  }

  // Get category label
  static String getCategoryLabel(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.medical:
        return 'Medical';
      case IncidentCategory.fire:
        return 'Fire';
      case IncidentCategory.security:
        return 'Security';
      case IncidentCategory.accident:
        return 'Accident';
      case IncidentCategory.other:
        return 'Other';
    }
  }

  // Get category icon
  static IconData getCategoryIcon(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.medical:
        return Icons.local_hospital;
      case IncidentCategory.fire:
        return Icons.fire_extinguisher;
      case IncidentCategory.security:
        return Icons.security;
      case IncidentCategory.accident:
        return Icons.car_crash;
      case IncidentCategory.other:
        return Icons.info;
    }
  }
}
