class MasukanModel {
  final int id;
  final String namaPelanggan;
  final String kontak;
  final String pesan;
  final int rating;
  final bool isRead;
  final String createdAt;

  MasukanModel({
    required this.id,
    required this.namaPelanggan,
    required this.kontak,
    required this.pesan,
    required this.rating,
    required this.isRead,
    required this.createdAt,
  });

  factory MasukanModel.fromJson(Map<String, dynamic> json) {
    return MasukanModel(
      id: json['id'] ?? 0,
      namaPelanggan: json['nama_pelanggan'] ?? 'Anonim',
      kontak: json['kontak'] ?? '-',
      pesan: json['pesan'] ?? '',
      rating: json['rating'] ?? 5,
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at'] != null 
          ? json['created_at'].toString().split('T')[0] 
          : '-',
    );
  }
}
