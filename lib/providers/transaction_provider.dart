import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionProvider extends ChangeNotifier {
  final String baseUrl = "http://192.168.1.131/api_pos";

  List<Map<String, dynamic>> _riwayat = [];
  bool _loading = false;

  List<Map<String, dynamic>> get riwayat => _riwayat;
  bool get isLoading => _loading;

  // ================= SIMPAN TRANSAKSI =================
  Future<void> simpanTransaksi(
    List<Map<String, dynamic>> items,
    int total,
  ) async {
    await http.post(
      Uri.parse("$baseUrl/transaksi_add.php"),
      body: {'items': jsonEncode(items), 'total': total.toString()},
    );

    await fetchRiwayat();
  }

  // ================= AMBIL RIWAYAT =================
  Future<void> fetchRiwayat() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/transaksi_read.php"));

      final List data = jsonDecode(response.body);

      _riwayat = data.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'],
          'total': item['total'],
          'tanggal': item['tanggal'],
        };
      }).toList();
    } catch (e) {
      _riwayat = [];
    }

    _loading = false;
    notifyListeners();
  }
}
