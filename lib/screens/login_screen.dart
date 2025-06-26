import 'package:costomerorderproduct_mo/screens/main_navigation_screen.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = Get.find(); // Get instance of AuthService
  bool _isLoading = false;
  bool _isLogin = true; // To toggle between Login and Register
  final TextEditingController _nameController = TextEditingController(); // For registration
  final TextEditingController _passwordConfirmationController = TextEditingController(); // For registration


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _authenticateUser() async {
    setState(() {
      _isLoading = true;
    });

    bool success;
    if (_isLogin) {
      success = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      success = await _authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _passwordConfirmationController.text,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigate to the main application screen after successful login/registration
      Get.offAll(() => const MainNavigationScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLogin ? 'Welcome Back!' : 'Create an Account',
              style: Get.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              _isLogin ? 'Sign in to continue to your account.' : 'Join us to explore amazing products!',
              style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingXl),

            if (!_isLogin) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: AppConstants.spacingMd),
            ],
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            if (!_isLogin) ...[
              TextField(
                controller: _passwordConfirmationController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
            ],
            
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.snackbar('Forgot Password', 'This feature is not yet implemented.', snackPosition: SnackPosition.BOTTOM);
                },
                child: Text(
                  _isLogin ? 'Forgot Password?' : '',
                  style: Get.textTheme.bodySmall?.copyWith(color: AppColors.accentColor),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            ElevatedButton(
              onPressed: _isLoading ? null : _authenticateUser,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: AppColors.onAccentColor)
                  : Text(_isLogin ? 'LOGIN' : 'REGISTER'),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin ? 'Don\'t have an account?' : 'Already have an account?',
                  style: Get.textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      // Clear fields when toggling
                      _emailController.clear();
                      _passwordController.clear();
                      _nameController.clear();
                      _passwordConfirmationController.clear();
                    });
                  },
                  child: Text(
                    _isLogin ? 'Register Now' : 'Login Now',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}