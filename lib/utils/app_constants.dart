import 'package:flutter/material.dart';

class AppColors {
  // Colors derived from the provided image
  static const Color primaryColor = Color(0xFFF1EFE9); // Light beige/gold
  static const Color onPrimaryColor = Color(0xFF1A1A1A); // Dark text on primary backgrounds
  static const Color secondaryColor = Color(0xFFE0E0E0); // Lighter grey for some backgrounds/dividers
  static const Color onSecondaryColor = Color(0xFF1A1A1A); // Dark text on secondary backgrounds
  static const Color accentColor = Color(0xFFFF8C00); // Vibrant orange/gold for CTA
  static const Color onAccentColor = Colors.white; // Text on accent buttons

  static const Color backgroundColor = Color(0xFFF8F8F8); // Very light grey/off-white background
  static const Color cardColor = Colors.white; // White for cards/containers

  static const Color textColor = Color(0xFF1A1A1A); // Dark grey/black for main text
  static const Color lightTextColor = Color(0xFF757575); // Lighter grey for secondary text/hints
  static const Color fieldFillColor = Color(0xFFEFEFEF); // Light grey for input fields
}

class AppConstants {
  static const String fontFamily = 'Inter'; // Modern sans-serif font
  static const String appName = 'Customer Order App';

  // Base URL for your Laravel API - FIXED: Removed markdown formatting
  static const String baseUrl = '[http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)'; // *** IMPORTANT: Change this to your Laravel API URL ***

  // Spacing constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Border radius constants
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 16.0;
  static const double borderRadiusLg = 24.0;
}