import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'kasir_page.dart';
import 'riwayat_page.dart';
import 'product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna (Sama dengan Login)
    const primaryColor = Color(0xFF334155); // Slate 700
    const backgroundColor = Color(0xFFF1F5F9); // Slate 100
    const cardColor = Colors.white;

    // Mengambil user saat ini untuk menyapa (Opsional, visual saja)
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.email?.split('@')[0] ?? "Kasir";

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER CUSTOM =================
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar / Icon User
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: const Icon(Icons.person, color: primaryColor),
                  ),
                  const SizedBox(width: 16),

                  // Sapaan User
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo, $displayName",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Siap bertransaksi hari ini?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Logout (Lebih sopan visualnya)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.logout_rounded,
                        color: Colors.red.shade400,
                      ),
                      onPressed: logout,
                      tooltip: "Keluar",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= GRID MENU =================
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.9, // Agar kartu sedikit lebih tinggi
                children: [
                  _menuItem(
                    title: "Kasir",
                    subtitle: "Buat Transaksi",
                    icon: Icons.point_of_sale_rounded,
                    color: primaryColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KasirPage()),
                    ),
                  ),
                  _menuItem(
                    title: "Riwayat",
                    subtitle: "Data Penjualan",
                    icon: Icons.receipt_long_rounded,
                    color: Colors.orange.shade700, // Warna pembeda halus
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RiwayatPage()),
                    ),
                  ),
                  _menuItem(
                    title: "Produk",
                    subtitle: "Stok Barang",
                    icon: Icons.inventory_2_rounded,
                    color: Colors.teal.shade700, // Warna pembeda halus
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductPage()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET MENU CARD YANG DIPERCANTIK
  Widget _menuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color, // Warna aksen untuk ikon
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 0, // Flat design dengan shadow manual di container
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100), // Border tipis
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon dengan Background Circle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const Spacer(),

              // Teks Judul
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 4),

              // Teks Subtitle
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
