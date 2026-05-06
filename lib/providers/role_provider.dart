import 'package:flutter/material.dart';

class RoleProvider extends ChangeNotifier {
  static const String adminAccessCode = 'ADMIN1234';

  bool _isAuthenticated = false;
  bool _isAdmin = false;
  String _displayName = 'User';

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  String get displayName => _displayName;

  void loginAsUser({String name = 'User'}) {
    _isAuthenticated = true;
    _isAdmin = false;
    _displayName = name.isEmpty ? 'User' : name;
    notifyListeners();
  }

  void loginAsAdmin({String name = 'Admin'}) {
    _isAuthenticated = true;
    _isAdmin = true;
    _displayName = name.isEmpty ? 'Admin' : name;
    notifyListeners();
  }

  bool isValidAdminCode(String code) => code.trim() == adminAccessCode;

  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;
    _displayName = 'User';
    notifyListeners();
  }

  void toggleRole() {
    if (_isAdmin) {
      loginAsUser();
    } else {
      loginAsAdmin();
    }
    notifyListeners();
  }

  void setAdmin(bool value) {
    _isAdmin = value;
    _isAuthenticated = true;
    notifyListeners();
  }
}
