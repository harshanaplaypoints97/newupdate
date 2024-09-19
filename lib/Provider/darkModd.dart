import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> setDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isDarkMode == false) {
      _isDarkMode = true;
      await prefs.setBool('darkmood', _isDarkMode);
      notifyListeners();
    } else {
      _isDarkMode = false;
      await prefs.setBool('darkmood', _isDarkMode);
      notifyListeners();
    }
  }

  Future<void> loadDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkmood') ?? false;
    notifyListeners();
  }

  Future<void> DarkmoodEnabaled() async {
    _isDarkMode = true;
    notifyListeners();
  }

  Future<void> DarkMoodDisable() async {
    _isDarkMode = false;
    notifyListeners();
  }
}
