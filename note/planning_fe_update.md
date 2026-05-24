# Perancangan Algoritma & Struktur Backend (Laravel API)

Dokumen ini memuat perancangan struktur tabel database, alur logika (algoritma), dan *Endpoint API* untuk fitur-fitur Admin (Kecuali Manajemen Menu) yang telah diidentifikasi pada Frontend.

---

## 1. Dasbor Utama (Statistik & Grafik)
Berfungsi menyuplai data metrik ke halaman depan aplikasi Admin.

- **Struktur Endpoint API:**
  - `GET /api/admin/dashboard/summary`
    - **Algoritma (Controller Logic):** 
      1. Hitung agregat `COUNT(id)` dari tabel `transactions` dengan kondisi `DATE(created_at) = CURDATE()` untuk _Total Penjualan Hari Ini_.
      2. Hitung agregat `SUM(grand_total)` dari tabel `transactions` dengan kondisi `DATE(created_at) = CURDATE()` untuk _Total Pendapatan Hari Ini_.
      3. Ambil _Total Menu_ (kecuali jika dikelola terpisah).
  - `GET /api/admin/dashboard/chart`
    - **Algoritma:** Menjalankan `GROUP BY DATE(created_at)` dengan limit 7 hari terakhir untuk menghasilkan _array_ tanggal dan jumlah pendapatan, lalu mengembalikannya (return) dalam format JSON untuk dirender oleh _fl_chart_.

---

## 2. Manajemen Kereta & Jadwal
- **Struktur Database (Tabel `keretas`):**
  - `id` (Primary Key)
  - `rute` (String) - cth: "Stasiun A - Stasiun B"
  - `waktu_keberangkatan` (Time)
  - `kuota_maksimal` (Integer)
  - `sisa_kuota` (Integer)
  - `harga_tiket` (Integer, opsional)
  
- **Struktur Endpoint API:**
  - `GET /api/admin/kereta` : Mengembalikan daftar seluruh kereta/jadwal.
  - `POST /api/admin/kereta` : _Create_ data jadwal baru.
  - `PUT /api/admin/kereta/{id}` : _Update_ rute, waktu, atau kuota.
  - `DELETE /api/admin/kereta/{id}` : Menghapus data kereta.
  - **Algoritma Pengurangan Kuota:**
    Setiap kali pelanggan melakukan pesanan (checkout kereta) dan pesanan tersebut berstatus disetujui, backend akan menjalankan _Query Builder_ `decrement('sisa_kuota', $jumlah_pesanan)` pada baris ID yang terkait.

---

## 3. Manajemen Pengguna (Users & Roles)
- **Struktur Database (Tabel `users` bawaan Laravel dimodifikasi):**
  - `id` (Primary Key)
  - `name` (String)
  - `email` (String, Unique)
  - `password` (String, Hashed)
  - `role` (Enum: 'admin', 'kasir', 'cs')
  
- **Struktur Endpoint API:**
  - `GET /api/admin/users` : Mengambil daftar pegawai dan rolenya.
  - `POST /api/admin/users` : Menambahkan staf baru (hash password menggunakan `Hash::make()`).
  - `PUT /api/admin/users/{id}` : Mengubah role atau reset password.
  - `DELETE /api/admin/users/{id}` : Menonaktifkan atau menghapus staf.
  - **Algoritma Autentikasi (Sanctum/JWT):** 
    Fungsi `POST /login` akan memvalidasi *credentials*. Jika cocok, API me-*return* Token Auth (Bearer) beserta informasi `role` agar Frontend Flutter bisa memutuskan navigasi navigasi halaman (*Routing*).

---

## 4. Manajemen Laporan (Riwayat Transaksi)
- **Struktur Database (Tabel `transactions`):**
  - `id` (Primary Key)
  - `order_id` (String, Unique) - cth: "#RV-001"
  - `kasir_id` (Foreign Key -> users)
  - `nama_pelanggan` (String)
  - `grand_total` (Integer)
  - `status` (Enum: 'success', 'refund')
  - `created_at` (Timestamp)
  
- **Struktur Endpoint API:**
  - `GET /api/admin/laporan`
    - **Algoritma:** Menjalankan _Query_ untuk mengambil seluruh riwayat transaksi. Mendukung *Query Parameter* `?start_date=xxx&end_date=yyy` untuk logika filter berdasarkan rentang waktu.
  - `GET /api/admin/laporan/export`
    - **Algoritma:** Meng-generate file PDF atau Excel (menggunakan *package* seperti Laravel Excel atau DomPDF) berdasarkan parameter rentang tanggal yang dikirim, lalu mengirimkan *Stream Response* untuk diunduh.

---

## 5. Manajemen Informasi (Promo/Banner)
- **Struktur Database (Tabel `informasis`):**
  - `id` (Primary Key)
  - `judul` (String)
  - `deskripsi` (Text)
  - `image_path` (String)
  - `is_active` (Boolean)
  
- **Struktur Endpoint API:**
  - `GET /api/admin/informasi` : Menampilkan semua banner konten.
  - `POST /api/admin/informasi` : Menerima form-data (_multipart_) untuk *upload* gambar banner ke *storage*, lalu menyimpan _path_-nya di database.
  - `PUT /api/admin/informasi/{id}/toggle` : **Algoritma Toggle** mengubah status `is_active` menjadi true/false agar bisa dimatikan atau dihidupkan di _Landing Page_.

---

## 6. Manajemen Masukan (Feedback Pelanggan)
- **Struktur Database (Tabel `feedbacks`):**
  - `id` (Primary Key)
  - `nama_pelanggan` (String)
  - `kontak` (String, opsional)
  - `pesan` (Text)
  - `rating` (Integer, 1-5)
  - `is_read` (Boolean) - Default: false
  
- **Struktur Endpoint API:**
  - `GET /api/admin/masukan` : Mengambil daftar semua feedback secara menurun berdasar `created_at`.
  - `PUT /api/admin/masukan/{id}/read` : **Algoritma Update** yang dipanggil otomatis ketika Admin mengklik baris pesan di Flutter, berfungsi untuk meng-_update_ kolom `is_read` menjadi `true` sehingga menghilangkan tanda *badge* notifikasi.
