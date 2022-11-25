import 'package:flutter/material.dart';
import 'package:touristy_frontend/config/config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const String routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor:
          brightness == Brightness.light ? Theme.of(context).cardColor : null,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //switch for dark mode
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                currentTheme.toggleTheme();
              },
            ),
            //switch for notifications
          ],
        ),
      ),
    );
  }
}
