import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/commonHelpers/bottom_nav_bar.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/home_page.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/user_account_page.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/hotel_search_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(), // index 0
    HotelSearchPage(), // index 1

    AccountPage(), // index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
