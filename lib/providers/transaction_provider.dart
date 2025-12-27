import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/socket_service.dart';

class TransactionProvider extends ChangeNotifier {
  final String baseUrl = "http://192.168.1.6/api_pos";

  List<Map<String, dynamic>> _riwayat = [];
  bool _loading = false;

  List<Map<String, dynamic>> get riwayat => _riwayat;
  bool get isLoading => _loading;

  // ================= SIMPAN TRANSAKSI =================
  Future<void> simpanTransaksi(
    List<Map<String, dynamic>> items,
    int total,
  ) async {
    try {
      // 1. Simpan ke database via PHP
      final response = await http.post(
        Uri.parse("$baseUrl/transaksi_add.php"),
        body: {'items': jsonEncode(items), 'total': total.toString()},
      );

      if (response.statusCode == 200) {
        // 2. TRIGGER SOCKET (Agar notifikasi muncul)
        // Kirim data ke server Node.js
        SocketService().sendTransaction({
          'total': total,
          'sender': 'Kasir App', // Opsional
        });

        await fetchRiwayat();
      }
    } catch (e) {
      print("Error simpan transaksi: $e");
    }
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
