import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static const _base = 'https://sidlab-assignment.vercel.app/api';

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
        'password': password
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
        'password': password
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

  /// LOGOUT
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  /// GET TOKEN
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  /// GET STORED USER
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