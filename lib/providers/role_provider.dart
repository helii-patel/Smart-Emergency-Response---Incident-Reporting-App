import 'package:flutter/material.dart';

class RoleProvider extends ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void toggleRole() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }

  void setAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }
}
