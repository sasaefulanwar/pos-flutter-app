import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  final String baseUrl = "http://192.168.1.6/api_pos";

  List<Map<String, dynamic>> _products = [];
  bool _loading = false;
  String? _error;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _loading;
  String? get error => _error;

  // ================= READ =================
  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/read.php"));

      final List data = jsonDecode(response.body);

      // 🔥 NORMALISASI DATA API DI SINI
      _products = data.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'],
          // API MySQL biasanya pakai nama_produk
          'nama': item['nama_produk'] ?? item['nama'] ?? '',
          // harga sering String → int
          'harga': int.parse(item['harga'].toString()),
        };
      }).toList();
    } catch (e) {
      _error = "Gagal mengambil data produk";
      _products = [];
    }

    _loading = false;
    notifyListeners();
  }

  // ================= CREATE =================
  Future<void> addProduct(String nama, int harga) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/create.php"),
        body: {
          // sesuaikan dengan backend
          'nama_produk': nama,
          'harga': harga.toString(),
        },
      );
      await fetchProducts();
    } catch (e) {
      _error = "Gagal menambah produk";
      notifyListeners();
    }
  }

  // ================= UPDATE =================
  Future<void> updateProduct(int id, String nama, int harga) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/update.php"),
        body: {
          'id': id.toString(),
          'nama_produk': nama,
          'harga': harga.toString(),
        },
      );
      await fetchProducts();
    } catch (e) {
      _error = "Gagal mengubah produk";
      notifyListeners();
    }
  }

  // ================= DELETE =================
  Future<void> deleteProduct(int id) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/delete.php"),
        body: {'id': id.toString()},
      );
      await fetchProducts();
    } catch (e) {
      _error = "Gagal menghapus produk";
      notifyListeners();
    }
  }
}
