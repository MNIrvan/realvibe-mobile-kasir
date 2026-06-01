import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cashier_models.dart';

class CashierService {
  static String get _host {
    if (kIsWeb) return '127.0.0.1';
    return defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : '127.0.0.1';
  }

  static String get _baseUrl => 'http://$_host:8000/api';

  static Future<CashierSession?> getActiveSession({
    required int userId,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cashier-sessions/active?user_id=$userId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat sesi kasir aktif');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] != 'success') {
      throw Exception(body['message'] ?? 'Gagal memuat sesi kasir aktif');
    }

    final data = body['data'];
    if (data == null) return null;
    return CashierSession.fromJson(data as Map<String, dynamic>);
  }

  static Future<CashierSession> openSession({
    required int userId,
    required double openingBalance,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cashier-sessions/open'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'opening_balance': openingBalance,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201 || body['status'] != 'success') {
      throw Exception(body['message'] ?? 'Gagal membuka kasir');
    }
    return CashierSession.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<CashierSessionEntry> addEntry({
    required int sessionId,
    required String entryType,
    required String title,
    required double amount,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cashier-sessions/$sessionId/entries'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'entry_type': entryType,
        'title': title,
        'amount': amount,
        'notes': notes,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201 || body['status'] != 'success') {
      throw Exception(body['message'] ?? 'Gagal menambah entry kas');
    }
    return CashierSessionEntry.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<CashierSessionEntry> updateEntry({
    required int sessionId,
    required int entryId,
    required String title,
    required double amount,
    String? notes,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/cashier-sessions/$sessionId/entries/$entryId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'amount': amount,
        'notes': notes,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['status'] != 'success') {
      throw Exception(body['message'] ?? 'Gagal memperbarui entry kas');
    }
    return CashierSessionEntry.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<void> deleteEntry({
    required int sessionId,
    required int entryId,
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/cashier-sessions/$sessionId/entries/$entryId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Gagal menghapus entry kas');
    }
  }

  static Future<CashierSession> closeSession({
    required int sessionId,
    required double totalCashPayment,
    required double totalNonCashPayment,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cashier-sessions/$sessionId/close'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'total_cash_payment': totalCashPayment,
        'total_non_cash_payment': totalNonCashPayment,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['status'] != 'success') {
      throw Exception(body['message'] ?? 'Gagal menutup kasir');
    }
    return CashierSession.fromJson(body['data'] as Map<String, dynamic>);
  }
}
