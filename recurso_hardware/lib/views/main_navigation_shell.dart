import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/time_clock_provider.dart';
import '../theme/app_theme.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'workplace_settings_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    WorkplaceSettingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final clock = context.watch<TimeClockProvider>();
    final unsyncedCount = clock.records.where((r) => !r.syncedToFirebase).length;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 3,
        indicatorColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.alarm_rounded),
            selectedIcon: Icon(Icons.alarm_rounded, color: AppTheme.primaryBlue),
            label: 'Ponto',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unsyncedCount > 0,
              label: Text('$unsyncedCount'),
              backgroundColor: AppTheme.accentWarning,
              child: const Icon(Icons.history_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: unsyncedCount > 0,
              label: Text('$unsyncedCount'),
              backgroundColor: AppTheme.accentWarning,
              child: const Icon(Icons.history_rounded, color: AppTheme.primaryBlue),
            ),
            label: 'Histórico',
          ),
          const NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on_rounded, color: AppTheme.primaryBlue),
            label: 'Sede & Raio',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryBlue),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
