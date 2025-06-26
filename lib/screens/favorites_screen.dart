import 'package:costomerorderproduct_mo/models/app_models.dart';
import 'package:costomerorderproduct_mo/screens/home_screen.dart';
import 'package:costomerorderproduct_mo/screens/login_screen.dart';
import 'package:costomerorderproduct_mo/services/api_service.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // This list would ideally be fetched from a backend API or a local storage solution
  // For now, it's a dummy list that you can populate based on user interaction.
  List<Product> _favoriteProducts = [];
  final AuthService _authService = Get.find(); // Get AuthService instance

  @override
  void initState() {
    super.initState();
    // Load favorites only if authenticated
    if (_authService.isAuthenticated.value) {
      _loadDummyFavorites();
    }
    // Listen for authentication changes to reload favorites
    ever(_authService.isAuthenticated, (bool isAuthenticated) {
      if (isAuthenticated) {
        _loadDummyFavorites();
      } else {
        setState(() {
          _favoriteProducts = []; // Clear favorites if logged out
        });
      }
    });
  }

  void _loadDummyFavorites() async {
    // Check if authenticated before attempting to load
    if (!_authService.isAuthenticated.value) {
      Get.snackbar('Login Required', 'Please log in to view favorites.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final apiService = Get.find<ApiService>(); // Use Get.find() here as well
    try {
      final allProducts = await apiService.getProducts();
      setState(() {
        // Dummy logic: assume product IDs 1 and 4 are favorites
        _favoriteProducts = allProducts.where((p) => p.id == 1 || p.id == 4).toList();
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load favorites: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: Obx(() { // Observe authentication state
        if (!_authService.isAuthenticated.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline, // Changed icon for login required
                  size: 80,
                  color: AppColors.lightTextColor,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Text(
                  'Please log in to view your favorites.',
                  style: Get.textTheme.titleMedium?.copyWith(color: AppColors.lightTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: const Text('Login Now'),
                ),
              ],
            ),
          );
        } else if (_favoriteProducts.isEmpty) {
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppColors.lightTextColor,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'No favorite products yet.',
                    style: Get.textTheme.titleMedium?.copyWith(color: AppColors.lightTextColor),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Go back to Home Screen
                    },
                    child: const Text('Browse Products'),
                  ),
                ],
              ),
            );
        } else {
          return GridView.builder(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.spacingMd,
                mainAxisSpacing: AppConstants.spacingMd,
                childAspectRatio: 0.75,
              ),
              itemCount: _favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = _favoriteProducts[index];
                return ProductCard(product: product); // Re-use ProductCard
              },
            );
        }
      }),
    );
  }
}