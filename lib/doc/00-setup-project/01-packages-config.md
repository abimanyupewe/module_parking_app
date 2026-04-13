# Packages & Configuration

Dokumentasi ini mengatur ketergantungan (dependencies) dan konfigurasi awal project.

## Dependencies (pubspec.yaml)

Tambahkan package berikut ke dalam `dependencies:`:

| Package | Fungsi |
| :--- | :--- |
| `sqflite` | Database lokal SQLite. |
| `path_provider` | Menemukan lokasi penyimpanan database di perangkat. |
| `path` | Manipulasi path file database. |
| `intl` | Format mata uang (Rupiah) dan tanggal. |

## Catatan Implementasi
- Pastikan menjalankan `flutter pub get` setelah menambahkan package.
- Atur versi SDK Flutter minimum di `pubspec.yaml`.

## Checklist Implementasi
- [ ] Tambahkan `sqflite`, `path_provider`, `path`, dan `intl`.
- [ ] Jalankan `flutter pub get`.
- [ ] Pastikan tidak ada konflik versi package.
