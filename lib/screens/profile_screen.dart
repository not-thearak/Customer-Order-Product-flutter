import 'package:costomerorderproduct_mo/screens/login_screen.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
                  'Please log in to view your profile.',
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
        }
        
        // If authenticated, display profile content
        return Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.person, size: 60, color: AppColors.textColor),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      authService.currentUser.value?.name ?? 'Guest User', // Display authenticated user's name
                      style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      authService.currentUser.value?.email ?? 'guest@example.com', // Display authenticated user's email
                      style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextColor),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.shopping_bag_outlined, color: AppColors.accentColor),
                        title: Text('My Orders', style: Get.textTheme.titleMedium),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.snackbar('Feature', 'My Orders screen will be implemented.');
                        },
                      ),
                      Divider(color: AppColors.secondaryColor),
                      ListTile(
                        leading: Icon(Icons.location_on_outlined, color: AppColors.accentColor),
                        title: Text('Shipping Address', style: Get.textTheme.titleMedium),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.snackbar('Feature', 'Shipping Address management will be implemented.');
                        },
                      ),
                      Divider(color: AppColors.secondaryColor),
                      ListTile(
                        leading: Icon(Icons.settings_outlined, color: AppColors.accentColor),
                        title: Text('Settings', style: Get.textTheme.titleMedium),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.snackbar('Feature', 'Settings screen will be implemented.');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    authService.logout(); // Call logout from AuthService
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // A distinct color for logout
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}