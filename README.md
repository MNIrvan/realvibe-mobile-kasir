# realvibe-project

Dokumen ini menjelaskan cara menjalankan aplikasi Flutter dan backend Laravel di proyek ini.

---

## 1. Syarat yang harus di penuhi

- Flutter SDK + Dart
- Android SDK / emulator atau target device lain
- PHP 8.x
- Composer
- Node.js + npm

---

## 2. Jalankan Flutter

a. Buka terminal di folder `realvibe_mobile`
b. Install dependensi:

```bash
cd realvibe_mobile
flutter pub get
```

c. Jalankan aplikasi:

```bash
flutter run
```

## 3. Jalankan Laravel

a. Buka terminal di folder `realvibe-backend`
b. Install dependensi PHP:

```bash
cd realvibe-backend
composer install
```

c. Salin file environment dan generate app key:

```bash
copy .env.example .env
php artisan key:generate
```

d. Jika diperlukan, install asset frontend:

```bash
npm install
```

e. Jalankan server Laravel:

```bash
php artisan serve / php artisan serve --host=127.0.0.1 --port=8000
```

f. Jika ingin mode development untuk aset Vite (run frontend):

```bash
npm run dev
```

---

## 4. Catatan Tambahan

- Jalankan Flutter dan Laravel di terminal terpisah.
- Pastikan backend Laravel berjalan sebelum Flutter memanggil API.
- Di Windows, gunakan `flutter doctor` untuk cek environment Flutter.
