import 'package:costomerorderproduct_mo/screens/main_navigation_screen.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the initial route based on authentication status
    Future.delayed(const Duration(seconds: 3), () {
      final AuthService authService = Get.find();
      if (authService.isAuthenticated.value) {
        Get.off(() => const MainNavigationScreen());
      } else {
        // Option 1: Go directly to MainNavigationScreen, actions will prompt login
        Get.off(() => const MainNavigationScreen());
        // Option 2: Go directly to LoginScreen
        // Get.off(() => const LoginScreen());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.textColor, // Dark background from the image
      body: Stack(
        children: [
          // Background image or illustration (conceptual, replace with actual asset)
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/headphone_splash.png', // Replace with your actual image asset
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.primaryColor,
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: const Icon(Icons.headphones, size: 100, color: Colors.white),
              ),
            ),
          ),
          // Content at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              decoration: const BoxDecoration(
                color: AppColors.textColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Touch Your new Dream.',
                    style: Get.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32, // Adjusted for responsiveness
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  ElevatedButton(
                    onPressed: () {
                      final AuthService authService = Get.find();
                      if (authService.isAuthenticated.value) {
                        Get.off(() => const MainNavigationScreen());
                      } else {
                        Get.off(() => const MainNavigationScreen()); // Still go to main screen, let actions prompt login
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor, // Light button color
                      foregroundColor: AppColors.textColor, // Dark text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Touch Dream'),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  // Pagination dots (conceptual)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == 0 ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}