class MenuItemInfo {
  const MenuItemInfo({
    required this.id,
    required this.idKategoriMenu,
    required this.namaMenu,
    required this.harga,
    required this.stok,
    this.gambar,
    this.imagePath = '',
  });

  final int id;
  final int idKategoriMenu;
  final String namaMenu;
  final double harga;
  final String stok;
  final String? gambar;
  final String imagePath;

  String get title => namaMenu;

  /// Membuat MenuItemInfo dari JSON response backend
  factory MenuItemInfo.fromJson(Map<String, dynamic> json) {
    return MenuItemInfo(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      idKategoriMenu: json['id_kategori_menu'] is int
          ? json['id_kategori_menu']
          : int.parse(json['id_kategori_menu'].toString()),
      namaMenu: json['nama_menu'] ?? '',
      harga: (json['harga'] is num)
          ? json['harga'].toDouble()
          : double.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      stok: json['stok'] ?? 'tersedia',
      gambar: json['gambar'],
      imagePath: '', // imagePath digunakan untuk asset lokal, gambar dari server pakai field `gambar`
    );
  }

  /// Konversi ke JSON untuk kirim ke backend
  Map<String, dynamic> toJson() {
    return {
      'id_kategori_menu': idKategoriMenu,
      'nama_menu': namaMenu,
      'harga': harga,
      'stok': stok,
    };
  }

  /// URL gambar dari server
  String get gambarUrl {
    if (gambar != null && gambar!.isNotEmpty) {
      return 'http://127.0.0.1:8000/storage/$gambar';
    }
    return '';
  }

  /// Apakah ada gambar dari server
  bool get hasServerImage => gambar != null && gambar!.isNotEmpty;

  /// Apakah ada gambar lokal (asset)
  bool get hasLocalImage => imagePath.isNotEmpty;
}

// Data dummy hanya digunakan sebagai fallback jika API belum tersedia
const List<MenuItemInfo> dummyMenuItems = [
  MenuItemInfo(id: 1, idKategoriMenu: 1, namaMenu: 'Ayam geprek', harga: 15000, stok: 'tersedia', imagePath: 'assets/images/menu9.png'),
  MenuItemInfo(id: 2, idKategoriMenu: 2, namaMenu: 'Tahu', harga: 5000, stok: 'tersedia', imagePath: 'assets/images/menu8.png'),
  MenuItemInfo(id: 3, idKategoriMenu: 3, namaMenu: 'Roti Bakar', harga: 12000, stok: 'tersedia', imagePath: 'assets/images/menu2.png'),
  MenuItemInfo(id: 4, idKategoriMenu: 2, namaMenu: 'Kentang', harga: 10000, stok: 'habis', imagePath: 'assets/images/menu6.png'),
  MenuItemInfo(id: 5, idKategoriMenu: 2, namaMenu: 'Tahu', harga: 5000, stok: 'tersedia', imagePath: 'assets/images/menu8.png'),
  MenuItemInfo(id: 6, idKategoriMenu: 2, namaMenu: 'Tahu Crispy', harga: 8000, stok: 'tersedia', imagePath: 'assets/images/menu10.png'),
  MenuItemInfo(id: 7, idKategoriMenu: 1, namaMenu: 'Burger', harga: 20000, stok: 'tersedia', imagePath: 'assets/images/menu1.png'),
  MenuItemInfo(id: 8, idKategoriMenu: 1, namaMenu: 'Mie goreng', harga: 12000, stok: 'tersedia', imagePath: 'assets/images/menu7.png'),
  MenuItemInfo(id: 9, idKategoriMenu: 4, namaMenu: 'Es Teh', harga: 4000, stok: 'tersedia', imagePath: 'assets/images/menu3.png'),
  MenuItemInfo(id: 10, idKategoriMenu: 1, namaMenu: 'Burger', harga: 20000, stok: 'tersedia', imagePath: 'assets/images/menu1.png'),
  MenuItemInfo(id: 11, idKategoriMenu: 1, namaMenu: 'Ayam geprek', harga: 15000, stok: 'tersedia', imagePath: 'assets/images/menu9.png'),
  MenuItemInfo(id: 12, idKategoriMenu: 2, namaMenu: 'Tahu', harga: 5000, stok: 'tersedia', imagePath: 'assets/images/menu8.png'),
  MenuItemInfo(id: 13, idKategoriMenu: 3, namaMenu: 'Roti Bakar', harga: 12000, stok: 'tersedia', imagePath: 'assets/images/menu2.png'),
  MenuItemInfo(id: 14, idKategoriMenu: 2, namaMenu: 'Kentang', harga: 10000, stok: 'habis', imagePath: 'assets/images/menu6.png'),
  MenuItemInfo(id: 15, idKategoriMenu: 2, namaMenu: 'Tahu', harga: 5000, stok: 'tersedia', imagePath: 'assets/images/menu8.png'),
];
