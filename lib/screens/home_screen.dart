import 'package:costomerorderproduct_mo/models/app_models.dart';
import 'package:costomerorderproduct_mo/screens/cart_screen.dart';
import 'package:costomerorderproduct_mo/screens/login_screen.dart';
import 'package:costomerorderproduct_mo/screens/product_detail_screen.dart';
import 'package:costomerorderproduct_mo/services/api_service.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  final ApiService _apiService = Get.find(); // Use Get.find() here as well
  final AuthService _authService = Get.find(); // Get instance of AuthService
  final CartController _cartController = Get.find<CartController>(); // Get instance of CartController

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getProducts();
    // Re-fetch products if authentication status changes (e.g., after login/logout)
    ever(_authService.isAuthenticated, (_) {
      setState(() {
        _productsFuture = _apiService.getProducts();
      });
    });
  }

  final List<Category> categories = const [
    Category(name: 'Laptop', icon: Icons.laptop_mac),
    Category(name: 'Mobile', icon: Icons.phone_android),
    Category(name: 'Headphone', icon: Icons.headphones),
    Category(name: 'Watch', icon: Icons.watch),
    Category(name: 'Tablet', icon: Icons.tablet),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle drawer open
            },
          ),
        ),
        title: Obx(() => Column( // Observe current user
              children: [
                Text('GOOD EVENING', style: Get.textTheme.bodySmall),
                Text(
                  _authService.currentUser.value?.name ?? 'Guest',
                  style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Specials Deal',
                style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              // Categories Section
              SizedBox(
                height: 100, // Height for the horizontal category list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(category: category);
                  },
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Hot Sale Section (now fetched from API or filtered from all products)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hot Sale',
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                    ),
                    child: Text(
                      'Closing in 09 : 30 : 10',
                      style: Get.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              // Use FutureBuilder to display products from the API
              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found. Please add some via the Laravel API.'));
                  } else {
                    // Filter for hot sale (dummy logic, adapt if API provides this)
                    final hotSaleProducts = snapshot.data!
                        .where((p) => p.originalPrice > p.price && p.originalPrice > 0)
                        .toList();
                    if (hotSaleProducts.isEmpty) {
                      return const Center(child: Text('No hot sale products available.'));
                    }
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotSaleProducts.length,
                        itemBuilder: (context, index) {
                          final product = hotSaleProducts[index];
                          return ProductCard(product: product, isHotSale: true);
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Popular Sale Section (all products for now, or filtered)
              Text(
                'Popular sale',
                style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found. Please add some via the Laravel API.'));
                  } else {
                    // Display all fetched products as popular sale for now
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppConstants.spacingMd,
                        mainAxisSpacing: AppConstants.spacingMd,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return ProductCard(product: product);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      // Bottom navigation is now handled by MainNavigationScreen
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle category tap
        Get.snackbar('Category', 'Tapped on ${category.name}');
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: AppConstants.spacingMd),
        padding: const EdgeInsets.all(AppConstants.spacingSm),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 30, color: AppColors.textColor),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              category.name,
              style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget { // Changed to StatefulWidget
  final Product product;
  final bool isHotSale;

  const ProductCard({super.key, required this.product, this.isHotSale = false});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false; // State to manage favorite status
  final AuthService _authService = Get.find(); // Get instance of AuthService
  final CartController _cartController = Get.find<CartController>(); // Get instance of CartController

  @override
  Widget build(BuildContext context) {
    final double discountPercentage = widget.isHotSale && widget.product.originalPrice > widget.product.price && widget.product.originalPrice > 0
        ? ((widget.product.originalPrice - widget.product.price) / widget.product.originalPrice * 100)
        : 0;

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(product: widget.product));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( // Wrap hot sale and favorite icon in a row
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.isHotSale && discountPercentage > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                      ),
                      child: Text(
                        '${discountPercentage.toStringAsFixed(0)}% Off',
                        style: Get.textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                    )
                  else
                    const SizedBox.shrink(), // Empty space if not hot sale

                  // Favorite Icon
                  Obx(() => IconButton( // Observe authentication status
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : AppColors.lightTextColor,
                      size: 20,
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
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.network(
                    widget.product.imageUrl ?? '[https://placehold.co/150x150/F1EFE9/1A1A1A?text=No+Image](https://placehold.co/150x150/F1EFE9/1A1A1A?text=No+Image)', // Fallback
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, size: 80, color: AppColors.lightTextColor),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                widget.product.name,
                style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.spacingXs),
              Row(
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentColor,
                    ),
                  ),
                  if (widget.isHotSale && widget.product.originalPrice > widget.product.price) ...[
                    const SizedBox(width: AppConstants.spacingXs),
                    Text(
                      '\$${widget.product.originalPrice.toStringAsFixed(2)}',
                      style: Get.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}