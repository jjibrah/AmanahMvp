import 'package:flutter/material.dart';
import 'profile.dart';
import 'deliveries.dart';
import 'home_dashboard.dart';
// Removed earnings and notifications pages

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;
  static const Color emerald = Color.fromARGB(255, 87, 208, 192);
  static const Color textSecondary = Color(0xFF8F9BB3);

  // Recompute pages each build to avoid stale state after hot reload
  List<Widget> get _pages => const [
        HomeDashboardPage(),
        DeliveriesPage(),
        ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    // Clamp index in case list size changed (e.g., tabs removed)
    final int clampedIndex = _currentIndex.clamp(0, _pages.length - 1);
    return Scaffold(
      body: IndexedStack(
        index: clampedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: clampedIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: emerald,
        unselectedItemColor: textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 