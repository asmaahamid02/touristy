import 'package:flutter/material.dart';
import 'package:touristy_frontend/config/config.dart';

class MyTheme with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  MyTheme() {
    if (prefs!.containsKey('currentTheme')) {
      _isDark = prefs!.getBool('currentTheme')!;
    } else {
      prefs!.setBool('currentTheme', _isDark);
    }
  }
  ThemeMode get currentTheme => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    prefs!.setBool('currentTheme', _isDark);
    notifyListeners();
  }
}
