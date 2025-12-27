import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/transaction_provider.dart';
import '../services/socket_service.dart';

class KasirPage extends StatefulWidget {
  const KasirPage({super.key});

  @override
  State<KasirPage> createState() => _KasirPageState();
}

class _KasirPageState extends State<KasirPage> {
  @override
  void initState() {
    super.initState();
    SocketService().connect("http://192.168.1.6:3000");
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna Tema (Konsisten)
    const primaryColor = Color(0xFF334155); // Slate 700
    const accentColor = Color(0xFF0F766E); // Teal 700 (untuk harga/uang)
    const backgroundColor = Color(0xFFF1F5F9); // Slate 100

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Kasir",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        centerTitle: true,
      ),
      body: Consumer3<ProductProvider, CartProvider, TransactionProvider>(
        builder: (context, productProv, cartProv, trxProv, _) {
          // ===== LOADING PRODUK =====
          if (productProv.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          // ===== PRODUK KOSONG =====
          if (productProv.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.blueGrey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data produk",
                    style: TextStyle(color: Colors.blueGrey.shade400),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // ================= LIST PRODUK =================
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: productProv.products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = productProv.products[index];
                    final nama = item['nama']?.toString() ?? '-';
                    final harga = int.tryParse(item['harga'].toString()) ?? 0;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Icon Placeholder Produk
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Detail Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rp $harga",
                                    style: const TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tombol Tambah
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  cartProv.tambahItem(item);
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text(
                                        "Tambah",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.add,
                                        size: 16,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ================= FOOTER TOTAL (CART PANEL) =================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rincian Singkat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Item (${cartProv.totalItem})",
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Rp ${cartProv.totalHarga}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ================= TOMBOL SIMPAN TRANSAKSI =================
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: cartProv.items.isEmpty
                            ? null
                            : () async {
                                await trxProv.simpanTransaksi(
                                  cartProv.items,
                                  cartProv.totalHarga,
                                );

                                SocketService().sendTransaction({
                                  'total': cartProv.totalHarga,
                                  'items_count': cartProv.totalItem,
                                  'timestamp': DateTime.now().toIso8601String(),
                                });

                                cartProv.clearCart();

                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Transaksi berhasil disimpan & disiarkan",
                                    ),
                                    backgroundColor: accentColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: cartProv.items.isEmpty ? 0 : 4,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.print_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Proses Pembayaran",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
