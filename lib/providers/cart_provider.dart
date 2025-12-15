import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  int get totalItem => _items.length;

  int get totalHarga => _items.fold(
    0,
    (sum, item) => sum + (int.tryParse(item['harga'].toString()) ?? 0),
  );

  void tambahItem(Map<String, dynamic> item) {
    _items.add({
      'id': item['id'],
      'nama': item['nama'],
      'harga': int.tryParse(item['harga'].toString()) ?? 0,
    });
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> exportItems() {
    return List<Map<String, dynamic>>.from(_items);
  }
}
