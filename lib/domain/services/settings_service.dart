import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _defaultRegionKey = 'default_region';
  static const String _defaultTermKey = 'default_term';
  static const String _darkModeKey = 'dark_mode';

  Future<String> getDefaultRegion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultRegionKey) ?? 'England/NI';
  }

  Future<void> setDefaultRegion(String region) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultRegionKey, region);
  }

  Future<int> getDefaultTerm() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_defaultTermKey) ?? 25;
  }

  Future<void> setDefaultTerm(int term) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultTermKey, term);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, enabled);
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
