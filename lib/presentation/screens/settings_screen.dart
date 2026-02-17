import 'package:flutter/material.dart';
import '../../domain/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<bool>? onThemeChanged;
  
  const SettingsScreen({
    super.key,
    this.onThemeChanged,
  });
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  
  String _defaultRegion = 'England/NI';
  int _defaultTerm = 25;
  bool _darkMode = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final region = await _settingsService.getDefaultRegion();
    final term = await _settingsService.getDefaultTerm();
    final darkMode = await _settingsService.getDarkMode();
    
    setState(() {
      _defaultRegion = region;
      _defaultTerm = term;
      _darkMode = darkMode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          
          // Default Region
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: const Text('Default Region'),
              subtitle: Text(_defaultRegion),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showRegionPicker(),
            ),
          ),
          
          // Default Term
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: const Text('Default Term'),
              subtitle: Text('$_defaultTerm years'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermPicker(),
            ),
          ),
          
          // Dark Mode
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              value: _darkMode,
              onChanged: (value) async {
                setState(() => _darkMode = value);
                await _settingsService.setDarkMode(value);
                widget.onThemeChanged?.call(value);
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Reset Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reset to Defaults'),
              onPressed: () => _showResetDialog(),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Disclaimer
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disclaimer',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This calculator provides estimates only. '
                    'Actual mortgage terms, rates, and stamp duty may vary. '
                    'Always consult with a qualified mortgage advisor or financial professional '
                    'before making property purchase decisions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          // Version
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showRegionPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Default Region'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('England/NI'),
              value: 'England/NI',
              groupValue: _defaultRegion,
              onChanged: (value) async {
                if (value != null) {
                  await _settingsService.setDefaultRegion(value);
                  if (context.mounted) {
                    setState(() => _defaultRegion = value);
                    Navigator.pop(context);
                  }
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Scotland'),
              value: 'Scotland',
              groupValue: _defaultRegion,
              onChanged: (value) async {
                if (value != null) {
                  await _settingsService.setDefaultRegion(value);
                  if (context.mounted) {
                    setState(() => _defaultRegion = value);
                    Navigator.pop(context);
                  }
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Wales'),
              value: 'Wales',
              groupValue: _defaultRegion,
              onChanged: (value) async {
                if (value != null) {
                  await _settingsService.setDefaultRegion(value);
                  if (context.mounted) {
                    setState(() => _defaultRegion = value);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showTermPicker() {
    int selectedTerm = _defaultTerm;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Default Term'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$selectedTerm years'),
              Slider(
                value: selectedTerm.toDouble(),
                min: 5,
                max: 40,
                divisions: 35,
                label: '$selectedTerm years',
                onChanged: (value) {
                  setDialogState(() => selectedTerm = value.toInt());
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _settingsService.setDefaultTerm(selectedTerm);
              if (context.mounted) {
                setState(() => _defaultTerm = selectedTerm);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _settingsService.resetToDefaults();
              await _loadSettings();
              widget.onThemeChanged?.call(false);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings reset to defaults')),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
