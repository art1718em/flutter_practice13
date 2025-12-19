import 'package:flutter/material.dart';
import 'package:flutter_practice13/features/car_expenses/screens/car_expenses_screen.dart';
import 'package:flutter_practice13/features/favorite_places/screens/favorite_places_screen.dart';
import 'package:flutter_practice13/features/profile/screens/profile_screen.dart';
import 'package:flutter_practice13/features/tips/screens/tips_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    CarExpensesScreen(),
    TipsScreen(),
    FavoritePlacesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Расходы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Советы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Места',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}


