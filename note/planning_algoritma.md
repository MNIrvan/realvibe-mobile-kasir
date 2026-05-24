# Planning & Perancangan Algoritma Frontend (Tanpa Koneksi Database)

Dokumen ini berisi perencanaan algoritma untuk fitur-fitur pada frontend (Laravel Web dan Flutter Mobile) yang belum terhubung sepenuhnya dengan backend API atau database. Logika di bawah ini dirancang menggunakan struktur data sementara (seperti array lokal, list, atau session) untuk menyimulasikan fungsi yang sebenarnya.

---

## 1. Frontend Web (Laravel Blade) - Fitur Pemesanan & Reservasi

Saat ini web (Landing Page) sudah memiliki logika _Cart_ menggunakan Session. Berikut adalah alur yang perlu disempurnakan:

### A. Algoritma Checkout & Pemesanan (Reservasi)
*   **Form Validation:** Membuat validasi form pemesanan (Nama Pemesan, Nomor Meja/Gerbong, Tanggal Reservasi) sebelum submit.
*   **Generate Order ID:** Membuat fungsi _random string_ unik (contoh: `ORD-20260522-XYZ`) untuk setiap transaksi checkout.
*   **Kalkulasi Total Pembayaran:** Menjumlahkan `(harga * qty)` dari seluruh item di keranjang session ditambah biaya layanan/pajak (jika ada).
*   **Mocking Pengiriman Data:** Saat tombol "Pesan" ditekan, data keranjang dan detail pemesan disimpan ke dalam _Session Array_ khusus (misal: `session('orders_history')`). Hal ini memungkinkan simulasi cetak struk atau riwayat pesanan.
*   **Clear Cart:** Membuat logika pengosongan keranjang session (`session()->forget('cart')`) setelah checkout berhasil disimulasikan.

### B. Algoritma Ketersediaan Jadwal
*   **Struktur Data:** Membuat Array Multidimensi _dummy_ berisi daftar jadwal kereta/reservasi (Tanggal, Waktu, Kuota Maksimal, Sisa Kuota).
*   **Filter Data:** Logika filter yang menampilkan data berdasarkan tanggal yang dipilih oleh user di UI.
*   **Validasi Kuota:** Jika nilai _Sisa Kuota_ pada suatu jadwal bernilai `0`, maka tombol "Booking" atau "Pilih" dinonaktifkan (disabled).

---

## 2. Frontend Mobile (Flutter) - Aplikasi Kasir (`dashboard_kasir.dart`)

### A. Algoritma Point of Sale (POS)
*   **State Management Menu:** Membuat _List of Maps_ (dummy data) yang menyerupai respons data dari backend `/api/menu`.
*   **Cart Kasir (Local State):** Membuat variabel state `List<Map> currentOrder` untuk menampung item yang di-tap oleh kasir.
*   **Kalkulasi Real-time:** Fungsi otomatis yang menghitung `Subtotal`, `Pajak (misal 11%)`, dan `Grand Total` setiap kali ada perubahan data (tambah/kurang qty) di `currentOrder`.
*   **Logika Pembayaran:**
    *   Menerima input nominal uang pelanggan.
    *   Fungsi menghitung: `Kembalian = Uang Masuk - Grand Total`.
    *   Validasi: Menampilkan peringatan (alert/snackbar) jika uang yang diinput kurang dari Grand Total.

### B. Algoritma Antrean Pesanan Web (Order Queue & Auto Expiry)
*   **Data Dummy Pesanan Web:** Membuat _List_ statis berisi pesanan simulasi dari web. Setiap elemen ditambahkan atribut `waktu_masuk` atau `sisa_waktu` (dalam detik, misal 1800 detik = 30 menit).
*   **Countdown Timer (Real-time):** Menjalankan perulangan/timer (`Timer.periodic` di Flutter) setiap 1 detik untuk mengurangi `sisa_waktu` pada semua pesanan berstatus _Menunggu_.
*   **Auto-Reject (Expired):** Jika ada pesanan yang `sisa_waktu` nya mencapai 0 dan belum ada tindakan (belum dibayar), otomatis ubah statusnya menjadi `Batal` atau hapus dari antrean UI (mencegah fake order).
*   **Aksi Terima/Tolak (Action):**
    *   **Terima/Bayar:** Membuka modal pop-up pembayaran (POS), mengurangi stok, dan menyelesaikan pesanan.
    *   **Tolak (Reject):** Membatalkan pesanan seketika dan menghapusnya dari daftar antrean.

---

## 3. Frontend Mobile (Flutter) - Aplikasi Admin (`dashboard_admin.dart`)

### A. Algoritma CRUD Menu & Kereta (Lokal)
*   **State Management:** Menggunakan Global List atau State Provider (Provider/GetX) untuk menyimpan array dummy Menu dan Kereta.
*   **Create:** Menerima input dari _TextField_, membungkusnya dalam objek `Map`, lalu memanggil `.add()` ke dalam list.
*   **Update:** Mencari berdasarkan _index_ data yang dipilih, kemudian menimpa datanya (`listData[index] = newData`).
*   **Delete:** Menampilkan dialog konfirmasi, lalu menjalankan method `.removeAt(index)` atau `.removeWhere()`.
*   **Simulasi Upload Foto:** Untuk data kereta, membuat variabel string untuk menyimpan sementara _path_ gambar dari galeri perangkat sebelum simulasi disubmit.

### B. Algoritma Dasbor Laporan (Statistik)
*   **Data Historis:** Membuat array berisi riwayat transaksi dummy (Tanggal dan Total Penjualan).
*   **Logika Grouping & Sum:** Algoritma perulangan (loop) untuk memfilter transaksi berdasarkan "Hari Ini" atau "Bulan Ini", kemudian menjumlahkan nilainya.
*   **Render UI:** Menampilkan hasil perhitungan algoritma ke dalam _Card_ atau widget metrik di halaman dasbor.

---

## 4. Autentikasi dan Role Management (Flutter)

### A. Alur Login & Routing
*   **Validasi Form:** Di halaman `login.dart` dan `registrasi.dart`, buat pengecekan input seperti format email (regex) dan panjang minimal password.
*   **Role-Based Routing (Mocking):** Logika percabangan untuk navigasi setelah login divalidasi:
    *   Jika `username == "admin"`, simpan state `isLoggedIn = true, role = admin`, jalankan `Navigator.push` ke `DashboardAdmin`.
    *   Jika `username == "kasir"`, jalankan navigasi ke `DashboardKasir`.
    *   Jika `username == "cs"`, jalankan navigasi ke `DashboardCS`.
*   **Logout:** Fungsi untuk menghapus variabel kredensial login (di memory/SharedPreferences) dan menavigasikan kembali ke halaman Login.
