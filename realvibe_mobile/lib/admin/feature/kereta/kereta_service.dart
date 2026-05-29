import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'kereta_model.dart';

import 'package:flutter/foundation.dart';

class KeretaService {
  static String get _baseUrl {
    final host = kIsWeb
        ? '127.0.0.1'
        : defaultTargetPlatform == TargetPlatform.android
            ? '10.0.2.2'
            : '127.0.0.1';
    return 'http://$host:8000/api';
  }

  static Future<KeretaInfo?> fetchFirstKereta() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/kereta'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data kereta');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Gagal memuat data kereta');
    }

    final List<dynamic> data = body['data'] as List<dynamic>;
    if (data.isEmpty) {
      return null;
    }

    return KeretaInfo.fromJson(data.first as Map<String, dynamic>);
  }

  static Future<KeretaInfo> createKeretaFoto({
    required Uint8List imageBytes,
    required String imageFileName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/kereta'),
    );
    request.headers['Accept'] = 'application/json';
    request.files.add(http.MultipartFile.fromBytes(
      'foto',
      imageBytes,
      filename: imageFileName,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal membuat data kereta');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return KeretaInfo.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<KeretaInfo> uploadKeretaFoto({
    required int id,
    required Uint8List imageBytes,
    required String imageFileName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/kereta/$id/upload-foto'),
    );
    request.headers['Accept'] = 'application/json';
    request.files.add(http.MultipartFile.fromBytes(
      'foto',
      imageBytes,
      filename: imageFileName,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengunggah foto kereta');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return KeretaInfo.fromJson(body['data'] as Map<String, dynamic>);
  }
}
