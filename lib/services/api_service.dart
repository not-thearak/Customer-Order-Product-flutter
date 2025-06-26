import 'dart:convert';
import 'package:costomerorderproduct_mo/models/app_models.dart';
import 'package:costomerorderproduct_mo/services/auth_service.dart';
import 'package:costomerorderproduct_mo/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService { // Changed to GetxService
  final String _baseUrl = AppConstants.baseUrl;
  final AuthService _authService = Get.find(); // Access AuthService for token

  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (includeAuth && _authService.isAuthenticated.value) {
      headers['Authorization'] = 'Bearer ${_authService.token.value}';
    }
    return headers;
  }

  // --- Product Endpoints ---
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'), headers: _getHeaders());

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode} ${response.body}');
    }
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'), headers: _getHeaders());

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product: ${response.statusCode} ${response.body}');
    }
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: _getHeaders(includeAuth: true),
      body: jsonEncode(productData),
    );

    if (response.statusCode == 201) { // 201 Created
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product: ${response.statusCode} ${response.body}');
    }
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/products/$id'),
      headers: _getHeaders(includeAuth: true),
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/products/$id'), headers: _getHeaders(includeAuth: true));

    if (response.statusCode != 204) { // 204 No Content
      throw Exception('Failed to delete product: ${response.statusCode} ${response.body}');
    }
  }

  // --- Customer Endpoints --- (assuming these might also be protected)
  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$_baseUrl/customers'), headers: _getHeaders(includeAuth: true));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((customer) => Customer.fromJson(customer)).toList();
    } else {
      throw Exception('Failed to load customers: ${response.statusCode} ${response.body}');
    }
  }

  Future<Customer> createCustomer(Map<String, dynamic> customerData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customers'),
      headers: _getHeaders(includeAuth: true),
      body: jsonEncode(customerData),
    );
    if (response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create customer: ${response.statusCode} ${response.body}');
    }
  }

  // --- Order Endpoints ---
  Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl/orders'), headers: _getHeaders(includeAuth: true));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.statusCode} ${response.body}');
    }
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/orders'),
      headers: _getHeaders(includeAuth: true),
      body: jsonEncode(orderData),
    );
    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.statusCode} ${response.body}');
    }
  }

  // You can add more specific methods for updating order status, adding/removing order items etc.
}