import 'package:flutter/material.dart';
import 'package:time_since/screens/item_status_screen.dart';
import 'package:time_since/screens/item_management_screen.dart';
import 'package:time_since/screens/settings_screen.dart';
import 'package:time_since/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  AppLocalizations? l10n;

  static const List<Widget> _widgetOptions = <Widget>[
    ItemStatusScreen(),
    ItemManagementScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -5), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.check_circle_outline),
                label: l10n!.statusLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list_alt),
                label: l10n!.manageLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: l10n!.settingsTitle,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            elevation: 0, // Elevation is handled by the Container's boxShadow
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

