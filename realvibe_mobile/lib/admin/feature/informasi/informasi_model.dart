class InformasiModel {
  final int id;
  final String judul;
  final String gambar;
  final bool isActive;

  InformasiModel({
    required this.id,
    required this.judul,
    required this.gambar,
    required this.isActive,
  });

  factory InformasiModel.fromJson(Map<String, dynamic> json) {
    return InformasiModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      gambar: json['gambar'] ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}
