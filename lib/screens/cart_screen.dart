import 'package:costomerorderproduct_mo/models/app_models.dart';
import 'package:costomerorderproduct_mo/screens/login_screen.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// Define a simple CartItem model for demonstration
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

// A simple GetX controller to manage cart state
class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  double get totalAmount => cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

  void addToCart(Product product) {
    var existingItem = cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      existingItem.quantity++;
      cartItems.refresh(); // Notify listeners of change
    } else {
      cartItems.add(CartItem(product: product));
    }
    Get.snackbar(
      'Cart',
      '${product.name} added to cart!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.accentColor,
      colorText: AppColors.onAccentColor,
    );
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    Get.snackbar(
      'Cart',
      '${product.name} removed from cart!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    } else {
      removeFromCart(item.product);
    }
  }
}


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find(); // Use Get.find() here
    final AuthService authService = Get.find(); // Get AuthService instance

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Obx(() { // Observe authentication state
        if (!authService.isAuthenticated.value) {
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
                  'Please log in to view your cart.',
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
        } else if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: AppColors.lightTextColor,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Text(
                  'Your cart is empty.',
                  style: Get.textTheme.titleMedium?.copyWith(color: AppColors.lightTextColor),
                ),
                const SizedBox(height: AppConstants.spacingMd),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Go back to Home Screen
                  },
                  child: const Text('Start Shopping'),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingSm),
                        child: Row(
                          children: [
                            Image.network(
                              item.product.imageUrl ?? 'https://placehold.co/80x80/F1EFE9/1A1A1A?text=No+Image',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, size: 60, color: AppColors.lightTextColor),
                            ),
                            const SizedBox(width: AppConstants.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: Get.textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: AppConstants.spacingXs),
                                  Text(
                                    '\$${item.product.price.toStringAsFixed(2)}',
                                    style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: AppConstants.spacingSm),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () => cartController.decrementQuantity(item),
                                      ),
                                      Text(item.quantity.toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () => cartController.incrementQuantity(item),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => cartController.removeFromCart(item.product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Cart Summary and Checkout Button
              Container(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: Get.textTheme.titleLarge),
                        Obx(() => Text(
                          '\$${cartController.totalAmount.toStringAsFixed(2)}',
                          style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.accentColor),
                        )),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar('Checkout', 'Proceeding to checkout!', snackPosition: SnackPosition.BOTTOM);
                        // TODO: Implement checkout logic (e.g., API call to create order)
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50), // Full width button
                      ),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}