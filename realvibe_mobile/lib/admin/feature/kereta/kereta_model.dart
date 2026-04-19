class KeretaInfo {
  final int id;
  final String? gambar;
  final String? gambarUrl;

  KeretaInfo({
    required this.id,
    this.gambar,
    this.gambarUrl,
  });

  factory KeretaInfo.fromJson(Map<String, dynamic> json) {
    return KeretaInfo(
      id: json['id'] as int,
      gambar: json['gambar'] as String?,
      gambarUrl: json['gambar_url'] as String? ?? json['gambar'] as String?,
    );
  }
}
