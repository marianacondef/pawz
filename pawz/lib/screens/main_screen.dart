import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pets_screen.dart';
import 'calendar_screen.dart';
import 'nearby_vets_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // começa no tab Pets (centro)

  final List<Widget> _screens = const [
    NearbyVetsScreen(),
    PetsScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFFFFF),
        indicatorColor: const Color(0xB9EFC7).withOpacity(0.5),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined, color: CupertinoColors.systemGrey), label: ''),
          NavigationDestination(icon: Icon(Icons.pets, color: CupertinoColors.systemGrey), label: ''),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined, color: CupertinoColors.systemGrey), label: ''),
        ],
      ),
    );
  }
}