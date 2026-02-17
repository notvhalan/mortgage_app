import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'domain/services/settings_service.dart';
import 'domain/services/mortgage_scenario.dart';
import 'presentation/screens/calculator_tab.dart';
import 'presentation/screens/breakdown_tab.dart';
import 'presentation/screens/rent_vs_buy_tab.dart';
import 'presentation/screens/settings_screen.dart';

void main() {
  runApp(const MortgageApp());
}

class MortgageApp extends StatefulWidget {
  const MortgageApp({super.key});
  
  @override
  State<MortgageApp> createState() => _MortgageAppState();
}

class _MortgageAppState extends State<MortgageApp> {
  final SettingsService _settingsService = SettingsService();
  bool _isDarkMode = false;
  
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    final darkMode = await _settingsService.getDarkMode();
    setState(() => _isDarkMode = darkMode);
  }
  
  void _toggleTheme(bool isDark) {
    setState(() => _isDarkMode = isDark);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UK Mortgage Calculator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainNavigation(onThemeChanged: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  
  const MainNavigation({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final MortgageScenario _scenario;
  late final List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    _scenario = MortgageScenario();
    _screens = [
      CalculatorTab(
        scenario: _scenario,
        onViewBreakdown: () => setState(() => _currentIndex = 1),
      ),
      BreakdownTab(scenario: _scenario),
      RentVsBuyTab(scenario: _scenario),
      SettingsScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }
  
  @override
  void dispose() {
    _scenario.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Breakdown',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows_outlined),
            selectedIcon: Icon(Icons.compare_arrows),
            label: 'Rent vs Buy',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
