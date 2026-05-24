import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'informasi_model.dart';

class InformasiService {
  static String get _baseUrl {
    final host = kIsWeb
        ? '127.0.0.1'
        : defaultTargetPlatform == TargetPlatform.android
            ? '10.0.2.2'
            : '127.0.0.1';
    return 'http://$host:8000/api/admin/informasi';
  }

  Future<List<InformasiModel>> getInformasi() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => InformasiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load informasi');
      }
    } catch (e) {
      throw Exception('Failed to load informasi: $e');
    }
  }

  Future<void> toggleStatus(int id) async {
    try {
      final response = await http.put(Uri.parse('$_baseUrl/$id/toggle'));
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle status');
      }
    } catch (e) {
      throw Exception('Failed to toggle status: $e');
    }
  }
}
