import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchRiwayat();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna (Konsisten)
    const primaryColor = Color(0xFF334155); // Slate 700
    const backgroundColor = Color(0xFFF1F5F9); // Slate 100
    const successColor = Color(0xFF0F766E); // Teal 700

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        centerTitle: true,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, prov, _) {
          // ===== LOADING =====
          if (prov.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          // ===== DATA KOSONG =====
          if (prov.riwayat.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      size: 64,
                      color: Colors.blueGrey.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat transaksi",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // ===== LIST RIWAYAT =====
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: prov.riwayat.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final trx = prov.riwayat[index];
              // Pastikan data string aman
              final total = trx['total'] ?? 0;
              final tanggal = trx['tanggal']?.toString() ?? '-';

              // Simulasi ID Transaksi (opsional, untuk visual saja)
              final trxId = "#TRX-${1000 + index}";

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Struk
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: successColor,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Info Tanggal & ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                trxId,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey.shade300,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Badge Status Kecil
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Sukses",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tanggal,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Total Harga
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          "Rp $total",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: successColor,
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
