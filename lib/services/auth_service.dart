import 'dart:convert';
import 'package:costomerorderproduct_mo/models/app_models.dart';
import 'package:costomerorderproduct_mo/screens/main_navigation_screen.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  late SharedPreferences _prefs;
  final String _baseUrl = AppConstants.baseUrl;

  // RxBool to reactively update UI based on authentication status
  final RxBool isAuthenticated = false.obs;
  final RxString token = ''.obs;
  final Rxn<User> currentUser = Rxn<User>(); // Rxn is for nullable reactive types

  // This method will be called by Get.putAsync in main.dart
  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadUserFromPrefs();
    return this;
  }

  void _loadUserFromPrefs() {
    final storedToken = _prefs.getString('authToken');
    final storedUserJson = _prefs.getString('currentUser');

    if (storedToken != null && storedUserJson != null) {
      token.value = storedToken;
      currentUser.value = User.fromJson(json.decode(storedUserJson));
      isAuthenticated.value = true;
      Get.log('User already logged in: ${currentUser.value?.name}');
    } else {
      isAuthenticated.value = false;
      token.value = '';
      currentUser.value = null;
      Get.log('No user logged in.');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String receivedToken = responseBody['token'];
        final User user = User.fromJson(responseBody['user']);

        await _prefs.setString('authToken', receivedToken);
        await _prefs.setString('currentUser', json.encode(user.toJson()));

        token.value = receivedToken;
        currentUser.value = user;
        isAuthenticated.value = true;

        Get.snackbar(
          'Success',
          'Logged in as ${user.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        String errorMessage = errorBody['message'] ?? 'Login failed.';
        if (errorBody['errors'] != null && errorBody['errors']['email'] != null) {
          errorMessage = errorBody['errors']['email'][0];
        }
        Get.snackbar('Login Failed', errorMessage, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String receivedToken = responseBody['token'];
        final User user = User.fromJson(responseBody['user']);

        await _prefs.setString('authToken', receivedToken);
        await _prefs.setString('currentUser', json.encode(user.toJson()));

        token.value = receivedToken;
        currentUser.value = user;
        isAuthenticated.value = true;

        Get.snackbar(
          'Success',
          'Registered and logged in as ${user.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        String errorMessage = errorBody['message'] ?? 'Registration failed.';
        if (errorBody['errors'] != null) {
          errorBody['errors'].forEach((key, value) {
            errorMessage += '\n${value[0]}';
          });
        }
        Get.snackbar('Registration Failed', errorMessage, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during registration: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Optional: Call backend logout API to invalidate server-side token
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: _getHeaders(includeAuth: true),
      );
    } catch (e) {
      Get.log('Error during backend logout (might be token already invalid or network issue): $e');
    }

    await _prefs.remove('authToken');
    await _prefs.remove('currentUser');
    isAuthenticated.value = false;
    token.value = '';
    currentUser.value = null;

    Get.snackbar(
      'Logged Out',
      'You have been logged out.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.textColor,
    );
    Get.offAll(() => const MainNavigationScreen()); // Redirect to main screen after logout
  }

  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (includeAuth && token.value.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.value}';
    }
    return headers;
  }
}