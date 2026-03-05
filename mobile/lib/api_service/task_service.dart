import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TaskService {
  static const _base = 'https://sidlab-assignment.vercel.app/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void _handleAuth(http.Response res) {
    if (res.statusCode == 401) {
      throw Exception("SESSION_EXPIRED");
    }
  }

  Future<List<dynamic>> getTasks() async {
    final res = await http.get(
      Uri.parse('$_base/tasks'),
      headers: await _headers(),
    );

    _handleAuth(res);

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    return jsonDecode(res.body) as List;
  }

  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    String? dueDate,
    String priority = "MEDIUM",
  }) async {

    final res = await http.post(
      Uri.parse('$_base/tasks'),
      headers: await _headers(),
      body: jsonEncode({
        "title": title,
        "description": description,
        "dueDate": dueDate,
        "priority": priority
      }),
    );

    _handleAuth(res);

    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateTask({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    final res = await http.put(
      Uri.parse('$_base/tasks/$id'),
      headers: await _headers(),
      body: jsonEncode(data),
    );

    _handleAuth(res);

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    return jsonDecode(res.body);
  }

  Future<void> deleteTask(String id) async {

    final res = await http.delete(
      Uri.parse('$_base/tasks/$id'),
      headers: await _headers(),
    );

    _handleAuth(res);

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }
  }

  Future<Map<String, dynamic>> toggleComplete(String id) async {

    final res = await http.patch(
      Uri.parse('$_base/tasks/$id/complete'),
      headers: await _headers(),
    );

    _handleAuth(res);

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    return jsonDecode(res.body);
  }
}