class LaporanEntry {
  const LaporanEntry({
    required this.kode,
    required this.pembeli,
    required this.detail,
    required this.kasir,
    required this.metode,
    required this.total,
    required this.tanggal,
  });

  final String kode;
  final String pembeli;
  final String detail;
  final String kasir;
  final String metode; // "Tunai" | "Non Tunai"
  final String total;
  final String tanggal;
}

const List<LaporanEntry> laporanTunai = [
  LaporanEntry(
    kode: 'RVD001',
    pembeli: 'Andi Saputra',
    detail: 'Roti Bakar, Kopi',
    kasir: 'Andi',
    metode: 'Tunai',
    total: 'Rp 45.000',
    tanggal: '02/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD002',
    pembeli: 'Siti Rahma',
    detail: 'Nasi Goreng, Es Teh',
    kasir: 'Rina',
    metode: 'Tunai',
    total: 'Rp 38.000',
    tanggal: '03/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD003',
    pembeli: 'Budi Santoso',
    detail: 'Kentang Goreng, Burger',
    kasir: 'Yusuf',
    metode: 'Tunai',
    total: 'Rp 50.000',
    tanggal: '04/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD004',
    pembeli: 'Rina Wijaya',
    detail: 'Ayam Geprek, Kopi Hitam',
    kasir: 'Budi',
    metode: 'Tunai',
    total: 'Rp 48.000',
    tanggal: '05/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD005',
    pembeli: 'Yusuf Hadi',
    detail: 'Nasi Goreng, Kopi',
    kasir: 'Siti',
    metode: 'Tunai',
    total: 'Rp 30.000',
    tanggal: '06/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD006',
    pembeli: 'Andika Pratama',
    detail: 'Ayam Laos, Es Teh',
    kasir: 'Anwar',
    metode: 'Tunai',
    total: 'Rp 42.000',
    tanggal: '07/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD007',
    pembeli: 'Dian Sari',
    detail: 'French Fries, Kopi',
    kasir: 'Andi',
    metode: 'Tunai',
    total: 'Rp 29.000',
    tanggal: '08/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD008',
    pembeli: 'Hendra Wijaya',
    detail: 'Mie Goreng, Es Teh',
    kasir: 'Rina',
    metode: 'Tunai',
    total: 'Rp 25.000',
    tanggal: '09/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD009',
    pembeli: 'Dimas Pratama',
    detail: 'Nasi Goreng, Ayam Geprek, Kopi',
    kasir: 'Yusuf',
    metode: 'Tunai',
    total: 'Rp 53.000',
    tanggal: '10/04/2024',
  ),
];

const List<LaporanEntry> laporanNonTunai = [
  LaporanEntry(
    kode: 'RVD010',
    pembeli: 'Vina Putri',
    detail: 'Burger, Es Teh',
    kasir: 'Rina',
    metode: 'Non Tunai',
    total: 'Rp 40.000',
    tanggal: '11/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD011',
    pembeli: 'Gilang Ramadhan',
    detail: 'Ayam Geprek, Kopi',
    kasir: 'Andi',
    metode: 'Non Tunai',
    total: 'Rp 44.000',
    tanggal: '12/04/2024',
  ),
  LaporanEntry(
    kode: 'RVD012',
    pembeli: 'Maya Lestari',
    detail: 'Roti Bakar, Kentang',
    kasir: 'Budi',
    metode: 'Non Tunai',
    total: 'Rp 36.000',
    tanggal: '12/04/2024',
  ),
];

List<LaporanEntry> laporanKeseluruhan() => [
      ...laporanTunai,
      ...laporanNonTunai,
    ];
