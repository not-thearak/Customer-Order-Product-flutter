import 'package:costomerorderproduct_mo/screens/cart_screen.dart';
import 'package:costomerorderproduct_mo/screens/splash_screen.dart';
import 'package:costomerorderproduct_mo/services/api_service.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AuthService().init()); // Initialize AuthService
  Get.put(CartController()); // Initialize CartController globally
  Get.put(ApiService()); // Initialize ApiService globally
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Customer Order App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        // Define a color scheme based on the image's light theme
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColor,
          onPrimary: AppColors.onPrimaryColor, // For text/icons on primary
          secondary: AppColors.secondaryColor, // For accents
          onSecondary: AppColors.onSecondaryColor, // For text/icons on secondary
          background: AppColors.backgroundColor,
          onBackground: AppColors.textColor,
          surface: AppColors.cardColor,
          onSurface: AppColors.textColor,
          error: Colors.red,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: AppConstants.fontFamily, // Set global font family
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.textColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textColor),
          displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.textColor),
          displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textColor),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textColor),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textColor),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textColor),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textColor),
          titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textColor),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textColor),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textColor),
          bodySmall: TextStyle(fontSize: 12, color: AppColors.lightTextColor),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onPrimaryColor),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.lightTextColor),
          labelSmall: TextStyle(fontSize: 11, color: AppColors.lightTextColor),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          buttonColor: AppColors.accentColor,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor, // Button background color
            foregroundColor: AppColors.onAccentColor, // Button text color
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: AppConstants.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            textStyle: const TextStyle(
              fontFamily: AppConstants.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: AppConstants.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.fieldFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          hintStyle: TextStyle(color: AppColors.lightTextColor),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}