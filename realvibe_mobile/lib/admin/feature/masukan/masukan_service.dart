import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'masukan_model.dart';

class MasukanService {
  static String get _baseUrl {
    final host = kIsWeb
        ? '127.0.0.1'
        : defaultTargetPlatform == TargetPlatform.android
            ? '10.0.2.2'
            : '127.0.0.1';
    return 'http://$host:8000/api/admin/masukan';
  }

  Future<List<MasukanModel>> getMasukan() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MasukanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load masukan');
      }
    } catch (e) {
      throw Exception('Failed to load masukan: $e');
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final response = await http.put(Uri.parse('$_baseUrl/$id/read'));
      if (response.statusCode != 200) {
        throw Exception('Failed to mark as read');
      }
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }
}
