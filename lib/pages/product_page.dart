import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final namaController = TextEditingController();
  final hargaController = TextEditingController();

  // Warna Tema (Konsisten)
  final primaryColor = const Color(0xFF334155); // Slate 700
  final backgroundColor = const Color(0xFFF1F5F9); // Slate 100
  final accentColor = const Color(0xFF0F766E); // Teal 700

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  // ================= FORM DIALOG (MODERN UI) =================
  void showForm({Map<String, dynamic>? item}) {
    if (item != null) {
      namaController.text = item['nama']?.toString() ?? '';
      hargaController.text = item['harga']?.toString() ?? '';
    } else {
      namaController.clear();
      hargaController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              item == null ? Icons.add_circle_outline : Icons.edit_note,
              color: primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              item == null ? "Tambah Produk" : "Edit Produk",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField(
              controller: namaController,
              label: "Nama Produk",
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 16),
            _buildDialogTextField(
              controller: hargaController,
              label: "Harga (Rp)",
              icon: Icons.monetization_on_outlined,
              inputType: TextInputType.number,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              final nama = namaController.text.trim();
              final hargaText = hargaController.text.trim();

              // ================= VALIDASI =================
              if (nama.isEmpty || hargaText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Nama dan harga tidak boleh kosong"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final harga = int.tryParse(hargaText);
              if (harga == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Harga harus berupa angka"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              // ================= CRUD LOGIC (TETAP) =================
              if (item == null) {
                await context.read<ProductProvider>().addProduct(nama, harga);
              } else {
                final id = int.tryParse(item['id']?.toString() ?? '') ?? 0;
                if (id == 0) return;
                await context.read<ProductProvider>().updateProduct(
                  id,
                  nama,
                  harga,
                );
              }

              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text(
              "Simpan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Input Field di Dialog
  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Manajemen Produk",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        centerTitle: true,
      ),

      // Floating Action Button Custom
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showForm(),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add),
        label: const Text("Produk Baru"),
        elevation: 4,
      ),

      body: Consumer<ProductProvider>(
        builder: (context, prov, _) {
          if (prov.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          // EMPTY STATE
          if (prov.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 64,
                    color: Colors.blueGrey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada produk tersimpan",
                    style: TextStyle(color: Colors.blueGrey.shade400),
                  ),
                ],
              ),
            );
          }

          // LIST PRODUK
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: prov.products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = prov.products[index];
              final id = int.tryParse(item['id']?.toString() ?? '') ?? 0;
              final nama = item['nama']?.toString() ?? '-';
              final harga = item['harga'] ?? 0;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Produk
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.inventory_2, color: primaryColor),
                    ),
                    const SizedBox(width: 16),

                    // Detail Produk
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rp $harga",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons (Edit & Delete)
                    Row(
                      children: [
                        // Tombol Edit
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit_rounded, size: 20),
                            color: Colors.blue.shade700,
                            tooltip: "Edit",
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: () => showForm(item: item),
                          ),
                        ),

                        // Tombol Delete
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                            ),
                            color: Colors.red.shade400,
                            tooltip: "Hapus",
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: id == 0
                                ? null
                                : () {
                                    // Dialog Konfirmasi Hapus (Opsional UX improvement)
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Hapus Produk?"),
                                        content: Text(
                                          "Anda yakin ingin menghapus '$nama'?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                ctx,
                                              ); // Tutup dialog konfirmasi
                                              context
                                                  .read<ProductProvider>()
                                                  .deleteProduct(id);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "$nama dihapus",
                                                  ),
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              "Hapus",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
