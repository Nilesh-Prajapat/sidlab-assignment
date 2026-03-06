import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TaskService {
  static const _base = 'https://sidlab-assignment.vercel.app/api';
  final _storage = const FlutterSecureStorage();

  // ─── Safe JSON decode ────────────────────────────────────────────────────────
  // Returns null when the body is HTML, plain-text, or empty.
  static dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  // Extracts the best human-readable error message from a response.
  static String _errorMessage(http.Response res, String fallback) {
    final data = _tryDecode(res.body);
    if (data is Map) {
      final msg = data['message'] ?? data['error'] ?? data['msg'];
      if (msg != null) return msg.toString();
    }
    if (res.statusCode >= 500) return 'Server error (${res.statusCode}). Please try again later.';
    if (res.statusCode == 404) return 'Resource not found (${res.statusCode}).';
    if (res.statusCode == 403) return 'Access denied (${res.statusCode}).';
    return '$fallback (HTTP ${res.statusCode})';
  }

  // ─── Auth headers ────────────────────────────────────────────────────────────
  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── 401 guard ───────────────────────────────────────────────────────────────
  void _handleAuth(http.Response res) {
    if (res.statusCode == 401) throw Exception('SESSION_EXPIRED');
  }

  // ─── GET TASKS ───────────────────────────────────────────────────────────────
  Future<List<dynamic>> getTasks() async {
    final http.Response res;
    try {
      res = await http
          .get(Uri.parse('$_base/tasks'), headers: await _headers())
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while fetching tasks: $e');
    }

    _handleAuth(res);
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Failed to fetch tasks'));
    }

    final body = _tryDecode(res.body);
    if (body == null) throw Exception('Unexpected response format from server.');
    if (body is! List)  throw Exception('Expected a list of tasks but got something else.');

    return body;
  }

  // ─── CREATE TASK ─────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    String? dueDate,
    String priority = 'MEDIUM',
  }) async {
    final http.Response res;
    try {
      res = await http
          .post(
        Uri.parse('$_base/tasks'),
        headers: await _headers(),
        body: jsonEncode({
          'title': title,
          'description': description,
          'dueDate': dueDate,
          'priority': priority,
        }),
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while creating task: $e');
    }

    _handleAuth(res);
    if (res.statusCode != 201) {
      throw Exception(_errorMessage(res, 'Failed to create task'));
    }

    final body = _tryDecode(res.body);
    if (body == null || body is! Map<String, dynamic>) {
      throw Exception('Unexpected response format after task creation.');
    }

    return body;
  }

  // ─── UPDATE TASK ─────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> updateTask({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final http.Response res;
    try {
      res = await http
          .put(
        Uri.parse('$_base/tasks/$id'),
        headers: await _headers(),
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while updating task: $e');
    }

    _handleAuth(res);
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Failed to update task'));
    }

    final body = _tryDecode(res.body);
    if (body == null || body is! Map<String, dynamic>) {
      throw Exception('Unexpected response format after task update.');
    }

    return body;
  }

  // ─── DELETE TASK ─────────────────────────────────────────────────────────────
  Future<void> deleteTask(String id) async {
    final http.Response res;
    try {
      res = await http
          .delete(Uri.parse('$_base/tasks/$id'), headers: await _headers())
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while deleting task: $e');
    }

    _handleAuth(res);
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Failed to delete task'));
    }
  }

  // ─── TOGGLE COMPLETE ─────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> toggleComplete(String id) async {
    final http.Response res;
    try {
      res = await http
          .patch(Uri.parse('$_base/tasks/$id/complete'), headers: await _headers())
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('Network error while toggling task: $e');
    }

    _handleAuth(res);
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res, 'Failed to toggle task completion'));
    }

    final body = _tryDecode(res.body);
    if (body == null || body is! Map<String, dynamic>) {
      throw Exception('Unexpected response format after toggle.');
    }

    return body;
  }
}