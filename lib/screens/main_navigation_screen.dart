import 'package:costomerorderproduct_mo/screens/cart_screen.dart';
import 'package:costomerorderproduct_mo/screens/favorites_screen.dart';
import 'package:costomerorderproduct_mo/screens/home_screen.dart';
import 'package:costomerorderproduct_mo/screens/profile_screen.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = Get.find(); // Get instance of AuthService

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Listen to authentication changes and update UI (e.g., if user logs out from Profile)
  @override
  void initState() {
    super.initState();
    ever(_authService.isAuthenticated, (bool isAuthenticated) {
      if (!isAuthenticated) {
        // If user logs out, reset to home screen to avoid protected content
        setState(() {
          _selectedIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardColor,
        selectedItemColor: AppColors.accentColor,
        unselectedItemColor: AppColors.lightTextColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}