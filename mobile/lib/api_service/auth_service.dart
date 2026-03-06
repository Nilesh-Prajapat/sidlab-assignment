import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _base = 'https://sidlab-assignment.vercel.app/api';
  final _storage = const FlutterSecureStorage();

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  String _errorMessage(http.Response res, String fallback) {
    final data = _tryDecode(res.body);
    if (data != null) {
      final msg = data['message'] ?? data['error'] ?? data['msg'];
      if (msg != null) return msg.toString();
    }
    if (res.statusCode >= 500) return 'Server error (${res.statusCode}). Please try again later.';
    if (res.statusCode == 404) return 'Endpoint not found (${res.statusCode}).';
    if (res.statusCode == 401) return 'Unauthorised. Please log in again.';
    if (res.statusCode == 403) return 'Access denied (${res.statusCode}).';
    return '$fallback (HTTP ${res.statusCode})';
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String petName,
  }) async {
    final http.Response res;
    try {
      res = await http
          .post(
        Uri.parse('$_base/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'petName': petName,
        }),
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error during registration: $e');
    }

    if (res.statusCode != 201) {
      throw Exception(_errorMessage(res, 'Registration failed'));
    }

    final data = _tryDecode(res.body);
    if (data == null) throw Exception('Unexpected response format from server.');

    final token = data['token']?.toString();
    final user  = data['user'];
    if (token == null || user == null) {
      throw Exception('Incomplete registration response from server.');
    }

    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'user',  value: jsonEncode(user));

    return Map<String, dynamic>.from(user as Map);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final http.Response res;
    try {
      res = await http
          .post(
        Uri.parse('$_base/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error during login: $e');
    }

    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Login failed'));
    }

    final data = _tryDecode(res.body);
    if (data == null) throw Exception('Unexpected response format from server.');

    final token = data['token']?.toString();
    final user  = data['user'];
    if (token == null || user == null) {
      throw Exception('Incomplete login response from server.');
    }

    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'user',  value: jsonEncode(user));

    return Map<String, dynamic>.from(user as Map);
  }

  Future<void> forgotPassword({
    required String email,
    required String petName,
    required String newPassword,
  }) async {
    final http.Response res;
    try {
      res = await http
          .post(
        Uri.parse('$_base/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'petName': petName,
          'newPassword': newPassword,
        }),
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error during password reset: $e');
    }

    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Password reset failed'));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('Not logged in.');

    final http.Response res;
    try {
      res = await http
          .put(
        Uri.parse('$_base/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while changing password: $e');
    }

    if (res.statusCode == 401) throw Exception('SESSION_EXPIRED');
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Change password failed'));
    }
  }

  Future<void> deleteAccount() async {
    final token = await getToken();
    if (token == null) throw Exception('Not logged in.');

    final http.Response res;
    try {
      res = await http
          .delete(
        Uri.parse('$_base/auth/delete-account'),
        headers: {'Authorization': 'Bearer $token'},
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while deleting account: $e');
    }

    if (res.statusCode == 401) throw Exception('SESSION_EXPIRED');
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Delete account failed'));
    }

    await logout();
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async => _storage.read(key: 'token');

  Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: 'user');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async => (await getToken()) != null;
}