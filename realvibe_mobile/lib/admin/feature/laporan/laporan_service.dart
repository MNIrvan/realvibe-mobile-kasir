import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'laporan_model.dart';

class LaporanService {
  static String get _baseUrl {
    final host = kIsWeb
        ? '127.0.0.1'
        : defaultTargetPlatform == TargetPlatform.android
            ? '10.0.2.2'
            : '127.0.0.1';
    return 'http://$host:8000/api/admin/laporan';
  }

  Future<List<LaporanModel>> getLaporan() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LaporanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load laporan');
      }
    } catch (e) {
      throw Exception('Failed to load laporan: $e');
    }
  }

  Future<void> exportLaporan() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/export'));
      if (response.statusCode == 200) {
        // Normally we'd handle the download URL here
        debugPrint('Export success: ${response.body}');
      } else {
        throw Exception('Failed to export laporan');
      }
    } catch (e) {
      throw Exception('Failed to export laporan: $e');
    }
  }
}
