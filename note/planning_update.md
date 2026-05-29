# Log Pembaruan Proyek (Update Log)

Dokumen ini berisi rangkuman seluruh implementasi algoritma dan modifikasi file yang telah dilakukan pada sisi frontend (Laravel Blade & Flutter) menggunakan status/simulasi lokal (tanpa database).

## 1. Perencanaan Logika & Algoritma
- **File Update:** `planning_algoritma.md`
- **Pembaruan:** Membuat rencana komprehensif terkait algoritma yang akan diterapkan, mulai dari form pemesanan Laravel, antrean aplikasi Kasir, rekapitulasi aplikasi Admin, hingga penambahan aturan khusus (pesanan kadaluwarsa dalam 30 menit jika tidak ada aksi).

## 2. Fitur Checkout dan Reservasi (Web - Laravel)
- **File Update:** `realvibe-backend/routes/web.php`
  - Mengonfigurasi `getCommonData()` untuk menyediakan _dummy data_ Jadwal Kereta (`$jadwal_dummy`) dan Riwayat Reservasi Meja (`$reservasi_dummy`).
  - Membuat route simulasi `POST /checkout` untuk menerima data _cart_ pelanggan, meng-generate `order_id` unik, dan menyimpannya di _session history_ sekaligus mengosongkan keranjang.
  - Membuat route simulasi `POST /booking-meja` untuk menangkap form pelanggan dan menghitung sisa ketersediaan meja.
- **File Update:** `realvibe-backend/resources/views/landing_page.blade.php`
  - Menyambungkan Modal Checkout Web dengan endpoint `/checkout` menggunakan Fetch API (menambahkan status _loading_ saat memproses).
  - Merombak tampilan Jadwal (statis) menjadi daftar interaktif (`@foreach`) dengan indikator kuota kursi yang dinamis (jika kosong, tombol menjadi _disabled_).
  - Membangun antarmuka form "Reservasi Meja" yang fungsional secara sesi, serta me-render sisa meja yang tersedia.

## 3. Fitur POS & Antrean Pesanan Kasir (Mobile - Flutter)
- **File Update:** `realvibe_mobile/lib/kasir/dashboard_kasir.dart`
  - Mengonversi `RevenueDashboard` dari `StatelessWidget` ke `StatefulWidget` untuk manajemen _state_ pesanan.
  - Menginisialisasi *dummy list* pesanan masuk dengan nilai waktu mundur (_timeRemaining_).
  - **Auto-Expiry:** Menerapkan fungsi `Timer.periodic` untuk mengurangi waktu tunggu pesanan setiap 1 detik. Jika mencapai 0 detik (maksimal 30 menit), pesanan akan otomatis terhapus dari daftar (mencegah *fake order*).
  - Mengimplementasikan sistem **Tolak (Reject)** dan **Terima (Bayar)**, di mana aksi Terima akan memunculkan _Modal POS Pembayaran_ dengan kalkulasi kembalian otomatis.

## 4. Fitur Dasbor Rekapitulasi Admin (Mobile - Flutter)
- **File Update:** `realvibe_mobile/lib/admin/dashboard_admin.dart`
  - Mengubah bagian `_DashboardSummaryPanel` menjadi `StatefulWidget` agar data dapat diperbarui.
  - Memasukkan array _dummy_ **Riwayat Transaksi** dari tanggal yang berbeda-beda.
  - Menerapkan fungsi `_kalkulasiStatistik` dengan logika _Grouping & Sum_ untuk menjumlahkan semua omzet ("Total Pendapatan") dan transaksi ("Total Penjualan") khusus pada periode **Hari Ini**.
  - Menyuntikkan nilai _return_ kalkulasi tersebut ke UI metrik sehingga angka _dashboard_ sekarang tampil responsif dan dinamis menyesuaikan isi _array_ transaksi.
