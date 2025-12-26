🧾 Point of Sale (POS) Flutter App
Aplikasi Point of Sale (POS) berbasis Flutter yang dikembangkan sebagai Tugas Besar, dengan fitur manajemen produk, transaksi kasir, dan riwayat transaksi.
Aplikasi ini menerapkan Global State Management menggunakan Provider, integrasi Firebase Authentication, serta backend API MySQL (PHP).

🚀 Fitur Utama

🔐 Login menggunakan Firebase Authentication

📦 Manajemen Produk (CRUD)

🛒 Sistem Kasir & Keranjang Belanja

💾 Simpan Transaksi ke Database

📜 Riwayat Transaksi

🔄 Global State Management dengan Provider

📱 UI responsif dan mudah digunakan

🧱 Arsitektur Aplikasi

Aplikasi ini menerapkan pemisahan tanggung jawab sebagai berikut:

UI Layer → Halaman Flutter (pages)

State Management Layer → Provider

Data Layer → API MySQL & Firebase

Provider yang Digunakan :

| Provider            | Fungsi                        |
| ------------------- | ----------------------------- |
| ProductProvider     | Mengelola data produk         |
| CartProvider        | Mengelola keranjang transaksi |
| TransactionProvider | Mengelola transaksi & riwayat |

📂 Struktur Folder
lib/
│── main.dart
│
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── kasir_page.dart
│   ├── product_page.dart
│   └── riwayat_page.dart
│
├── providers/
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   └── transaction_provider.dart
│
└── services/

🛠️ Teknologi yang Digunakan

Flutter

Dart

Provider (State Management)

Firebase Authentication

REST API (PHP + MySQL)

HTTP Package

⚙️ Instalasi & Menjalankan Aplikasi
1️⃣ Clone Repository

git clone https://github.com/username/pos-flutter.git
cd pos-flutter

2️⃣ Install Dependency

flutter pub get

Konfigurasi Firebase

Buat project di Firebase Console

Tambahkan aplikasi Android

Download google-services.json

Letakkan di: android/app/google-services.json

4️⃣ Jalankan Aplikasi

flutter run

🔗 Konfigurasi API Backend

Pastikan backend API MySQL (PHP) sudah berjalan, dan ubah base URL pada Provider:
final String baseUrl = "http://10.0.2.2/api_pos";

✨ Penutup

Terima kasih telah mengunjungi repository ini.
Semoga aplikasi ini dapat menjadi referensi dalam pengembangan aplikasi Flutter berbasis Provider & Firebase.
