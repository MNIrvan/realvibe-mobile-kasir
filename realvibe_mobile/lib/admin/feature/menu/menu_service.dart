import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'menu_model.dart';

import 'package:flutter/foundation.dart';

class MenuService {
  static String get _baseUrl {
    final host = kIsWeb
        ? '127.0.0.1'
        : defaultTargetPlatform == TargetPlatform.android
            ? '10.0.2.2'
            : '127.0.0.1';
    return 'http://$host:8000/api';
  }

  /// Mengambil semua data menu dari server
  static Future<List<MenuItemInfo>> fetchMenus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/menu'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          final List<dynamic> data = body['data'];
          return data.map((json) => MenuItemInfo.fromJson(json)).toList();
        }
      }
      throw Exception('Gagal memuat data menu');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Mengambil semua data kategori menu dari server
  static Future<List<KategoriMenuInfo>> fetchKategoriMenu() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/kategori-menu'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          final List<dynamic> data = body['data'];
          return data.map((json) => KategoriMenuInfo.fromJson(json)).toList();
        }
      }
      throw Exception('Gagal memuat data kategori menu');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Menambahkan menu baru (dengan atau tanpa gambar)
  static Future<MenuItemInfo> createMenu({
    required String namaMenu,
    required int idKategoriMenu,
    required double harga,
    required String stok,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      if (imageBytes != null && imageFileName != null) {
        // Multipart request jika ada gambar
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/menu'),
        );
        request.headers['Accept'] = 'application/json';
        request.fields['nama_menu'] = namaMenu;
        request.fields['id_kategori_menu'] = idKategoriMenu.toString();
        request.fields['harga'] = harga.toString();
        request.fields['stok'] = stok;
        request.files.add(http.MultipartFile.fromBytes(
          'gambar',
          imageBytes,
          filename: imageFileName,
        ));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['status'] == 'success') {
            return MenuItemInfo.fromJson(body['data']);
          }
        }
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal menambahkan menu');
      } else {
        // JSON request tanpa gambar
        final response = await http.post(
          Uri.parse('$_baseUrl/menu'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'nama_menu': namaMenu,
            'id_kategori_menu': idKategoriMenu,
            'harga': harga,
            'stok': stok,
          }),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['status'] == 'success') {
            return MenuItemInfo.fromJson(body['data']);
          }
        }
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal menambahkan menu');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Memperbarui data menu (dengan atau tanpa gambar baru)
  static Future<MenuItemInfo> updateMenu({
    required int id,
    required String namaMenu,
    required int idKategoriMenu,
    required double harga,
    required String stok,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      if (imageBytes != null && imageFileName != null) {
        // Multipart request dengan gambar
        // Laravel tidak support PUT multipart langsung, gunakan POST + _method
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/menu/$id'),
        );
        request.headers['Accept'] = 'application/json';
        request.fields['_method'] = 'PUT';
        request.fields['nama_menu'] = namaMenu;
        request.fields['id_kategori_menu'] = idKategoriMenu.toString();
        request.fields['harga'] = harga.toString();
        request.fields['stok'] = stok;
        request.files.add(http.MultipartFile.fromBytes(
          'gambar',
          imageBytes,
          filename: imageFileName,
        ));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['status'] == 'success') {
            return MenuItemInfo.fromJson(body['data']);
          }
        }
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal memperbarui menu');
      } else {
        // Penggunaan multipart request dengan metode PUT untuk update tanpa gambar baru.
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/menu/$id'),
        );
        request.headers['Accept'] = 'application/json';
        request.fields['_method'] = 'PUT';
        request.fields['nama_menu'] = namaMenu;
        request.fields['id_kategori_menu'] = idKategoriMenu.toString();
        request.fields['harga'] = harga.toString();
        request.fields['stok'] = stok;

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['status'] == 'success') {
            return MenuItemInfo.fromJson(body['data']);
          }
        }
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal memperbarui menu');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Menghapus data menu
  static Future<void> deleteMenu(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/menu/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Gagal menghapus menu');
    } catch (e) {
      throw Exception('$e');
    }
  }
}
