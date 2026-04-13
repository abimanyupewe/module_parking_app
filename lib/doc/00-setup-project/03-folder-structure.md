# Folder Structure (Clean Code)

Dokumentasi ini mengatur arsitektur folder aplikasi agar tetap rapi dan mudah di-maintain. Ikuti struktur ini saat membuat file baru.

## Arsitektur Folder `lib/`

| Folder | Isi File | Deskripsi |
| :--- | :--- | :--- |
| `config/` | `colors.dart`, `themes.dart` | Pengaturan tema dan warna global. |
| `models/` | `user_model.dart`, `transaksi_model.dart` | Class data (POJO) untuk SQLite. |
| `pages/` | `login_page.dart`, `dashboard_page.dart` | Halaman utama (Screen) aplikasi. |
| `services/` | `database_helper.dart` | Logika koneksi dan query database. |
| `widgets/` | `primary_button.dart`, `custom_field.dart` | Komponen UI yang bisa digunakan kembali. |

## Step-by-Step Pembuatan Halaman (Page)
Setiap halaman baru harus mengikuti pola berikut:
1. Buat file di folder `lib/pages/`.
2. Gunakan `StatefulWidget` jika ada interaksi data (seperti Form atau List).
3. Panggil widget dari folder `lib/widgets/` untuk membangun UI.
4. Hubungkan dengan `DatabaseHelper` dari folder `lib/services/` untuk ambil data.

## Step-by-Step Pembuatan Widget
Setiap widget reusable harus:
1. Berada di folder `lib/widgets/`.
2. Menerima parameter melalui constructor (misal: `label`, `onPressed`, `controller`).
3. Memiliki style yang konsisten dengan `AppColors`.

## Checklist Implementasi
- [ ] Folder `lib/config` sudah ada.
- [ ] Folder `lib/models` sudah ada.
- [ ] Folder `lib/pages` sudah ada.
- [ ] Folder `lib/services` sudah ada.
- [ ] Folder `lib/widgets` sudah ada.
