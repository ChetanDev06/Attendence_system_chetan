import 'package:flutter/material.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _autoBackup = false;

  bool get _darkMode => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildCard(Icons.dark_mode, "Dark Mode", Switch(value: _darkMode, onChanged: (val) => setState(() => themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light))),
              const SizedBox(height: 16),
              _buildCard(Icons.notifications, "Notifications", Switch(value: _notifications, onChanged: (val) => setState(() => _notifications = val))),
              const SizedBox(height: 16),
              _buildCard(Icons.backup, "Auto Backup", Switch(value: _autoBackup, onChanged: (val) => setState(() => _autoBackup = val))),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("App Version"),
                  subtitle: Text("1.0.0"),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: const Text("Contact Support"),
                  onTap: () {
                    // TODO: Implement email/support link
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Widget trailing) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(leading: Icon(icon), title: Text(title), trailing: trailing),
    );
  }
}
