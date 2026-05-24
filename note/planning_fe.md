# Identifikasi Fitur Frontend (Aplikasi Admin Flutter)

Dokumen ini berisi rangkuman fitur-fitur yang sudah terstruktur di dalam bagian UI/Frontend aplikasi Admin (`realvibe_mobile/lib/admin`). Identifikasi ini berguna sebagai dasar untuk merancang algoritma backend (Laravel API) dan skema database agar selaras dengan kebutuhan tampilan.

## 1. Dasbor Utama (`dashboard_admin.dart`)
Berfungsi sebagai halaman beranda admin untuk memantau performa bisnis.
- **Fitur Tersedia:**
  - Panel Metrik: Menampilkan Total Menu, Total Penjualan (Hari Ini), dan Total Pendapatan (Hari Ini).
  - Grafik Pendapatan (_Revenue Chart_): Menampilkan tren penjualan dalam grafik garis.
  - Kalender Mini & Notifikasi: Tampilan kalender singkat dan riwayat aktivitas terbaru.

## 2. Manajemen Menu (`feature/menu/menu_page.dart`)
Berfungsi untuk mengelola produk/makanan yang dijual.
- **Fitur Tersedia:**
  - **Tampilan Fleksibel:** Bisa di-switch antara _Grid View_ (kartu gambar) dan _Table View_ (baris data).
  - **Pencarian (Search):** Mencari menu berdasarkan nama.
  - **CRUD Interaktif:** Terdapat *Modal/Form* untuk Tambah Menu, Edit Menu, dan pop-up Hapus Menu.
  - **Offline Fallback:** Sudah dilengkapi logika *state* sementara jika gagal terhubung ke _server_ (API).

## 3. Manajemen Jadwal Kereta (`feature/kereta/kereta_page.dart`)
Berfungsi untuk mengatur tiket atau ketersediaan kereta gantung/kendaraan.
- **Fitur Tersedia:**
  - Menampilkan daftar kereta beserta Rute dan Waktu keberangkatan.
  - Pengelolaan kuota kursi atau sisa ketersediaan.

## 4. Manajemen Pengguna (`feature/users/users_page.dart`)
Berfungsi untuk mengontrol siapa saja pegawai yang bisa login ke aplikasi.
- **Fitur Tersedia:**
  - Tampilan daftar akun staf.
  - Manajemen peran (_Role_), seperti: Admin, Kasir, atau CS (Customer Service).

## 5. Manajemen Laporan (`feature/laporan/laporan_page.dart`)
Berfungsi sebagai pembukuan digital kasir dan sistem.
- **Fitur Tersedia:**
  - Menampilkan tabel riwayat transaksi secara historis.
  - (Rencana Frontend): Filter berdasarkan tanggal/bulan, serta ekspor ke format laporan (PDF/Excel).

## 6. Manajemen Informasi & Promo (`feature/informasi/informasi_page.dart`)
Berfungsi mengatur konten dinamis di _Landing Page_ pelanggan.
- **Fitur Tersedia:**
  - Pengaturan _Banner_ promo atau _slider_ yang muncul di halaman web.

## 7. Manajemen Masukan/Feedback (`feature/masukan/masukan_page.dart`)
- **Fitur Tersedia:**
  - Kotak masuk (_inbox_) untuk melihat ulasan pelanggan, komplain, atau saran terkait layanan.

---
**Catatan untuk Tahap Selanjutnya (Backend):**
Setiap poin modul di atas membutuhkan penyediaan _Endpoint API RESTful_ di Laravel. (Misal: `/api/admin/menu`, `/api/admin/kereta`, `/api/admin/laporan`). Desain algoritma database (Migration & Controller) akan dikerjakan berdasarkan struktur ini.
