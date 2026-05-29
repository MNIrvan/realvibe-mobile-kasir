class LaporanModel {
  final int id;
  final String kode;
  final String pembeli;
  final String detail;
  final String kasir;
  final String metode;
  final String total;
  final String tanggal;

  LaporanModel({
    required this.id,
    required this.kode,
    required this.pembeli,
    required this.detail,
    required this.kasir,
    required this.metode,
    required this.total,
    required this.tanggal,
  });

  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    // Parse kasir relation if exists
    String kasirName = '-';
    if (json['kasir'] != null && json['kasir']['name'] != null) {
      kasirName = json['kasir']['name'];
    }

    // Default values since some are not in DB
    String metodePembayaran = 'Tunai'; 
    String detailPesanan = '-';

    return LaporanModel(
      id: json['id'] ?? 0,
      kode: json['order_id'] ?? '-',
      pembeli: json['nama_pelanggan'] ?? '-',
      detail: detailPesanan,
      kasir: kasirName,
      metode: metodePembayaran,
      total: 'Rp ${json['grand_total'] ?? 0}',
      tanggal: json['created_at'] != null 
          ? json['created_at'].toString().split('T')[0] 
          : '-',
    );
  }
}
