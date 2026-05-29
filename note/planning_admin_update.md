# Log Pembaruan Admin Backend (Update Log)

Dokumen ini berisi rangkuman seluruh modifikasi kode yang telah dilakukan pada sisi Backend Laravel untuk mengakomodasi algoritma yang telah direncanakan di Frontend Admin.

## 1. Migrations (Skema Database)
File-file _migration_ berikut telah disesuaikan dan dibuat:
- **`kereta` (Update):** Menambahkan field baru yaitu `rute`, `waktu_keberangkatan`, `kuota_maksimal`, `sisa_kuota`, dan `harga_tiket`.
- **`transactions` (Baru):** Membuat tabel untuk laporan transaksi dan perhitungan pendapatan (_revenue_).
- **`informasis` (Baru):** Membuat tabel untuk menyimpan _content management_ promo/banner dengan _toggle_ status `is_active`.
- **`feedbacks` (Baru):** Membuat tabel untuk menampung masukan pengguna dengan status notifikasi `is_read`.

## 2. Models (ORM Database)
File _Model_ (representasi tabel pada Laravel) telah ditambahkan:
- **`Kereta.php` (Update):** Menambahkan array `$fillable` baru sesuai _migration_ agar mendukung _Mass Assignment_.
- **`Transaction.php`:** Mengatur relasi _Foreign Key_ `kasir_id` ke tabel `users`.
- **`Informasi.php`:** Mendefinisikan model untuk _Promo_.
- **`Feedback.php`:** Mendefinisikan model untuk _Masukan_.
- **`User.php` (Exist):** Telah dipastikan kompatibel karena field `role` sudah terdapat di migrasi.

## 3. Controllers & Routes (Logika API)
File _Controller_ berikut telah dikerjakan beserta pengikatan (*routing*) URL-nya di `routes/api.php`:
- **`DashboardController.php`:** Menampung logika `summary()` dengan _COUNT_ dan _SUM_ berdasarkan tanggal, dan `chart()` yang me-_return_ kumpulan data mingguan. Terdaftar di route `admin/dashboard/`.
- **`TransactionController.php`:** Menyediakan fungsi `index()` untuk menarik riwayat laporan dan `export()` sebagai *dummy* ekspor dokumen. Terdaftar di route `admin/laporan/`.
- **`InformasiController.php`:** Mengatur pendaftaran promo baru dan fitur khusus `toggle()` untuk menghidupkan/mematikan promo. Terdaftar di route `admin/informasi/`.
- **`FeedbackController.php`:** Menyediakan balasan pesan pelanggan yang otomatis tersortir berdasar waktu, dan fitur `markAsRead()` untuk hilangkan notifikasi. Terdaftar di route `admin/masukan/`.
- **`UserController.php`:** _Controller_ terakhir yang ditambahkan untuk melengkapi manajemen staf admin (*Create, Read, Update, Delete*). Berisi validasi khusus role (`admin`, `kasir`, `cs`) beserta pembuatan sandi (*Password Hashing*). Terdaftar otomatis menggunakan `Route::apiResource('users')`.

Dengan pembaruan ini, maka 100% desain logika backend _Endpoint API_ untuk antarmuka Admin Flutter telah rampung direalisasikan dalam wujud baris kode _Controller_ dan _Route_.
