import 'package:costomerorderproduct_mo/models/app_models.dart';
import 'package:costomerorderproduct_mo/screens/cart_screen.dart';
import 'package:costomerorderproduct_mo/screens/login_screen.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget { // Changed to StatefulWidget
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false; // State to manage favorite status for this product
  final AuthService _authService = Get.find(); // Get instance of AuthService
  late final CartController _cartController; // Declare as late final

  @override
  void initState() {
    super.initState();
    _cartController = Get.find<CartController>(); // Initialize in initState
  }
  // You might initialize _isFavorite based on a check with your backend
  // or a local list of favorites when the screen loads.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text('DETAILS'),
        actions: [
          Obx(() => IconButton( // Observe authentication status
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : AppColors.textColor,
            ),
            onPressed: () {
              if (!_authService.isAuthenticated.value) {
                Get.to(() => const LoginScreen()); // Navigate to login
                Get.snackbar('Login Required', 'Please log in to add to favorites.', snackPosition: SnackPosition.BOTTOM);
                return;
              }
              setState(() {
                _isFavorite = !_isFavorite;
              });
              Get.snackbar(
                'Favorite',
                _isFavorite ? '${widget.product.name} added to favorites!' : '${widget.product.name} removed from favorites!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: _isFavorite ? Colors.redAccent : AppColors.secondaryColor,
                colorText: _isFavorite ? Colors.white : AppColors.textColor,
              );
              // TODO: Implement API call to save/remove from backend favorites
            },
          )),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  // This cart icon in the app bar also needs to check login
                  if (!_authService.isAuthenticated.value) {
                    Get.to(() => const LoginScreen());
                    Get.snackbar('Login Required', 'Please log in to view cart.', snackPosition: SnackPosition.BOTTOM);
                    return;
                  }
                  Get.to(() => const CartScreen()); // Navigate to cart screen
                },
              ),
              Obx(() => Positioned( // Observe cart item count
                right: 8,
                top: 8,
                child: _cartController.cartItems.isEmpty // Using _cartController here
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          _cartController.cartItems.length.toString(), // Display actual cart count
                          style: Get.textTheme.labelSmall?.copyWith(
                            color: AppColors.onAccentColor,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              )),
            ],
          ),
          const SizedBox(width: AppConstants.spacingSm),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryColor, // Light background for product image
              padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingLg),
              child: Center(
                child: Image.network(
                  widget.product.imageUrl ?? 'https://placehold.co/250x250/F1EFE9/1A1A1A?text=No+Image', // Fallback
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 150, color: AppColors.lightTextColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.category, // Using dummy category for now
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.lightTextColor),
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor, // White background for review
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: AppConstants.spacingXs),
                            Text(
                              '4.9', // Placeholder rating
                              style: Get.textTheme.bodySmall,
                            ),
                            const SizedBox(width: AppConstants.spacingXs),
                            Text(
                              '(Review)',
                              style: Get.textTheme.bodySmall?.copyWith(color: AppColors.lightTextColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Size: S M L', // Placeholder for size options
                    style: Get.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      'Description',
                      style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                        child: Text(
                          widget.product.description?.isNotEmpty == true ? widget.product.description! : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextColor),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      'Terms and conditions',
                      style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                        child: Text(
                          'By purchasing this item, you agree to our terms and conditions. Please read them carefully before completing your order.',
                          style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextColor),
                ),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.accentColor),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (!_authService.isAuthenticated.value) {
                  Get.to(() => const LoginScreen()); // Navigate to login
                  Get.snackbar('Login Required', 'Please log in to add to cart.', snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                _cartController.addToCart(widget.product); // Add to cart using controller
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor, // Use the accent color
                foregroundColor: AppColors.onAccentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_shopping_cart, size: 20),
                  const SizedBox(width: AppConstants.spacingSm),
                  Text('Add to cart'.toUpperCase()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}