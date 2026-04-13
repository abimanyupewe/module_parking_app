# Database Schema & Services

Dokumentasi ini mendefinisikan struktur database dan pembuatan `DatabaseHelper`.

## Lokasi File: `lib/services/database_helper.dart`

## Langkah-langkah Implementasi
1. Buat class `DatabaseHelper` dengan pola Singleton (agar hemat RAM).
2. Deklarasikan nama tabel dan kolom-kolomnya sebagai konstanta `static final`.
3. Gunakan `openDatabase` dengan `path_provider` untuk inisialisasi.
4. Tulis perintah `CREATE TABLE` di method `_onCreate`.
5. Implementasikan metode `insert`, `query`, `update`, `delete` standar.

## Tabel & Relasi Utama
- **tb_user**: (Primary Key id_user, username UNIQUE).
- **tb_jenis_kendaraan**: (Primary Key id_jenis, nama_jenis UNIQUE).
- **tb_area_parkir**: (Primary Key id_area, id_jenis FK).
- **tb_kendaraan**: (Primary Key id_kendaraan, plat_nomor UNIQUE).
- **tb_transaksi**: (Primary Key id_transaksi, id_kendaraan FK, id_area FK, id_user FK).
- **tb_log_aktivitas**: (Primary Key id_log, id_user FK, kategori_log, aktivitas, waktu).

## Checklist Implementasi
- [ ] Implementasikan Singleton `DatabaseHelper`.
- [ ] Definisi 6 tabel lengkap dengan `UNIQUE` constraint.
- [ ] Implementasikan relasi Foreign Key (FK).
- [ ] Pastikan SQLite database tersimpan di path aplikasi (`getApplicationDocumentsDirectory`).
