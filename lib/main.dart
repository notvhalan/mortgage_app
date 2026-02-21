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

  const MainNavigation({super.key, required this.onThemeChanged});

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
      backgroundColor: const Color(0xFFF7F8FA),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppTheme.borderLight.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.calculate_rounded,
                  label: 'Calculator',
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.assessment_rounded,
                  label: 'Breakdown',
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.compare_arrows_rounded,
                  label: 'Rent vs Buy',
                ),
                _buildNavItem(
                  context,
                  index: 3,
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected
                      ? AppTheme.fontWeightSemiBold
                      : AppTheme.fontWeightRegular,
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
