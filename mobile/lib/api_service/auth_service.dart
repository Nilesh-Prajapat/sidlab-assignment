import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static const _base =
      'https://sidlab-assignment.vercel.app/api';

  final _storage = const FlutterSecureStorage();


  /// REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {

    final res = await http.post(
      Uri.parse('$_base/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    final data = jsonDecode(res.body);

    await _storage.write(key: 'token', value: data['token']);

    await _storage.write(
      key: 'user',
      value: jsonEncode(data['user']),
    );

    return data['user'];
  }


  /// LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {

    final res = await http.post(
      Uri.parse('$_base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    final data = jsonDecode(res.body);

    await _storage.write(key: 'token', value: data['token']);

    await _storage.write(
      key: 'user',
      value: jsonEncode(data['user']),
    );

    return data['user'];
  }


  /// FORGOT PASSWORD
  Future<void> forgotPassword({
    required String email,
    required String petName,
    required String newPassword,
  }) async {

    final res = await http.post(
      Uri.parse('$_base/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'petName': petName,
        'newPassword': newPassword,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }
  }


  /// CHANGE PASSWORD
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {

    final token = await getToken();

    final res = await http.put(
      Uri.parse('$_base/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }
  }


  /// DELETE ACCOUNT
  Future<void> deleteAccount() async {

    final token = await getToken();

    final res = await http.delete(
      Uri.parse('$_base/auth/delete-account'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    await logout();
  }


  /// LOGOUT
  Future<void> logout() async {
    await _storage.deleteAll();
  }


  /// GET TOKEN
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }


  /// GET USER
  Future<Map<String, dynamic>?> getUser() async {

    final raw = await _storage.read(key: 'user');

    if (raw == null) return null;

    return jsonDecode(raw);
  }


  /// LOGIN STATUS
  Future<bool> isLoggedIn() async {
    return (await getToken()) != null;
  }
}