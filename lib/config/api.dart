class Api {
  static const String baseUrl = "http://192.168.1.6/api_pos/";

  static const readProduk = "$baseUrl/read.php";
  static const addProduk = "$baseUrl/create.php";
  static const editProduk = "$baseUrl/update.php";
  static const deleteProduk = "$baseUrl/delete.php";

  // transaksi
  static const simpanTransaksi = "$baseUrl/transaksi_add.php";
  static const readTransaksi = "$baseUrl/transaksi_read.php";
}
