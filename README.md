# MANAJEMEN PARKIR MULTI-ROLE

Aplikasi Flutter modern untuk manajemen parkir dengan sistem multi-role (Owner, Admin, Petugas) yang lengkap dengan audit trail otomatis, master data management, dan operasional real-time.

## 📋 Daftar Isi
1. [Panduan Desain UI/UX](#panduan-desain-uiux-color-palette)
2. [Arsitektur Folder](#arsitektur-folder-modular--granular)
3. [Dependencies & Libraries](#daftar-library-dan-dependencies)
4. [Skema Database](#skema-database-6-tabel-utama)
5. [Fitur Utama per Role](#fitur-utama-berdasarkan-role)
6. [Panduan Pengembangan](#panduan-pengembangan-cli-commands)
7. [Struktur Proyek Lengkap](#struktur-proyek-lengkap)

---

## 1. PANDUAN DESAIN UI/UX (COLOR PALETTE)

Aplikasi menggunakan tema **Clean & Modern** untuk kenyamanan operasional jangka panjang dengan visual hierarchy yang jelas.

### Warna-warna Utama

| Nama | Hex Code | Penggunaan |
|------|----------|-----------|
| **Background** | #FFFFFF | Latar belakang utama aplikasi (Putih Bersih) |
| **Primary** | #343858 | AppBar, Heading, Icon aktif, Tombol utama (Gelap Elegan) |
| **Secondary** | #EEF4FF | Highlight Tab aktif, Indikator status Selesai (Biru Terang Halus) |
| **Tertiary** | #EEF1F7 | Latar belakang form input, tabel data (Abu-abu Kebiruan) |
| **Inactive** | #737686 | Teks sekunder, label form (Abu-abu Netral) |
| **Success** | #4CAF50 | Status aktif, transaksi berhasil (Hijau) |
| **Warning** | #FFC107 | Status pending, peringatan (Kuning) |
| **Danger** | #F44336 | Status error, slot penuh (Merah) |
| **Info** | #2196F3 | Informasi umum (Biru) |

---

## 2. ARSITEKTUR FOLDER (MODULAR & GRANULAR)

Proyek ini menerapkan **Clean Architecture** dengan pemisahan yang jelas antara UI, Business Logic, dan Data Layer.

### Prinsip Organisasi
- **Feature-based structure**: Setiap fitur (Auth, Petugas, Admin, Owner) memiliki folder tersendiri
- **Reusable widgets**: Komponen global yang digunakan di berbagai fitur
- **Singleton services**: Database dan helper utilities
- **Models as data classes**: Pure data models dengan konversi map otomatis

---

## 3. STRUKTUR PROYEK LENGKAP

```
module_parking_app/
│
├── lib/
│   │
│   ├── config/
│   │   ├── colors.dart              # Palet warna global (#343858, #EEF4FF, dll)
│   │   ├── themes.dart              # Material theme configuration
│   │   └── constants.dart           # Konstanta (DB names, table names, roles, dll)
│   │
│   ├── models/
│   │   ├── user_model.dart          # User (Owner, Admin, Petugas)
│   │   ├── jenis_kendaraan_model.dart # Kategori kendaraan & tarif/jam
│   │   ├── area_parkir_model.dart   # Area parkir dengan kapasitas & terisi
│   │   ├── kendaraan_model.dart     # Master kendaraan
│   │   ├── transaksi_model.dart     # Transaksi parkir (check-in/out)
│   │   ├── log_aktivitas_model.dart # Audit trail (append-only)
│   │   └── models.dart              # Barrel export semua models
│   │
│   ├── services/
│   │   ├── database_helper.dart     # Singleton DatabaseHelper
│   │   │   ├── CRUD User operations
│   │   │   ├── CRUD Jenis Kendaraan operations
│   │   │   ├── CRUD Area Parkir operations
│   │   │   ├── CRUD Kendaraan operations
│   │   │   ├── CRUD Transaksi operations
│   │   │   ├── Log Aktivitas operations (append-only)
│   │   │   └── Utility operations (close, delete)
│   │   │
│   │   ├── format_helper.dart       # Utility formatting
│   │   │   ├── formatRupiah()
│   │   │   ├── formatDate(), formatTime(), formatDateTime()
│   │   │   ├── formatDuration()
│   │   │   ├── calculateParkingHours()
│   │   │   └── Validasi plat nomor
│   │   │
│   │   ├── pdf_service.dart         # [AKAN DATANG] PDF generation
│   │   │
│   │   └── services.dart            # Barrel export services
│   │
│   ├── widgets/
│   │   ├── custom_textfield.dart    # Input field dengan label, validasi, eye toggle
│   │   ├── primary_button.dart      # Primary & Secondary buttons dengan loading state
│   │   ├── summary_card.dart        # Summary card (2 variants: vertical & horizontal)
│   │   ├── status_badge.dart        # Status badge & indicator dengan dynamic colors
│   │   ├── log_timeline_tile.dart   # Timeline tile untuk audit log
│   │   └── widgets.dart             # Barrel export semua widgets
│   │
│   ├── features/
│   │   │
│   │   ├── splash/                  # [FASE 6] Splash Screen & Onboarding
│   │   │   └── splash_page.dart
│   │   │
│   │   ├── auth/                    # [FASE 7] Authentication Module
│   │   │   ├── pages/
│   │   │   │   ├── login_page.dart
│   │   │   │   ├── forgot_password_page.dart
│   │   │   │   └── change_password_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── login_form_widget.dart
│   │   │   │   └── auth_header_widget.dart
│   │   │   └── controllers/
│   │   │       ├── auth_controller.dart
│   │   │       └── forgot_password_controller.dart
│   │   │
│   │   ├── onboarding/              # [FASE 6] Onboarding Module
│   │   │   ├── pages/
│   │   │   │   └── onboarding_page.dart
│   │   │   └── controllers/
│   │   │       └── onboarding_controller.dart
│   │   │
│   │   ├── petugas/                 # [FASE 8] Petugas Dashboard Module
│   │   │   ├── pages/
│   │   │   │   ├── petugas_dashboard_page.dart
│   │   │   │   ├── vehicle_in_page.dart
│   │   │   │   ├── vehicle_out_page.dart
│   │   │   │   └── shift_history_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── slot_info_card.dart
│   │   │   │   ├── checkout_modal_dialog.dart
│   │   │   │   ├── vehicle_in_form.dart
│   │   │   │   └── petugas_summary_grid.dart
│   │   │   └── controllers/
│   │   │       ├── petugas_dashboard_controller.dart
│   │   │       ├── vehicle_checkout_controller.dart
│   │   │       └── shift_history_controller.dart
│   │   │
│   │   ├── admin/                   # [FASE 9] Admin Dashboard Module
│   │   │   ├── pages/
│   │   │   │   ├── admin_dashboard_page.dart
│   │   │   │   ├── category_area_page.dart
│   │   │   │   ├── petugas_management_page.dart
│   │   │   │   └── audit_activity_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── monitoring_list_tile.dart
│   │   │   │   ├── category_tabs_widget.dart
│   │   │   │   └── admin_summary_grid.dart
│   │   │   └── controllers/
│   │   │       ├── admin_dashboard_controller.dart
│   │   │       ├── category_area_controller.dart
│   │   │       └── petugas_management_controller.dart
│   │   │
│   │   └── owner/                   # [FASE 10] Owner Dashboard Module
│   │       ├── pages/
│   │       │   ├── owner_dashboard_page.dart
│   │       │   ├── log_activity_page.dart
│   │       │   ├── management_sdm_page.dart
│   │       │   └── history_global_page.dart
│   │       ├── widgets/
│   │       │   ├── quick_access_section.dart
│   │       │   ├── revenue_summary_grid.dart
│   │       │   ├── recent_transaction_table.dart
│   │       │   └── log_filter_tabs.dart
│   │       └── controllers/
│   │           ├── owner_dashboard_controller.dart
│   │           ├── log_activity_controller.dart
│   │           └── management_sdm_controller.dart
│   │
│   ├── assets/
│   │   ├── images/                  # Logo, icon, placeholder images
│   │   │   ├── logo.png
│   │   │   ├── ic_motor.png
│   │   │   ├── ic_mobil.png
│   │   │   └── placeholder.png
│   │   └── icons/                   # Custom icons jika diperlukan
│   │
│   ├── doc/                         # Dokumentasi teknis (maintained)
│   │   ├── 00-setup-project/
│   │   ├── 01-ui-ux-design/
│   │   ├── 02-database-core/
│   │   ├── 03-pdf-printing/
│   │   ├── 04-shared-logic/
│   │   ├── 05-onboarding/
│   │   ├── 06-auth-system/
│   │   ├── 07-petugas-dashboard/
│   │   ├── 08-admin-dashboard/
│   │   ├── 09-owner-dashboard/
│   │   ├── 10-splash-screen/
│   │   └── Dokumentasi Pengembangan Sistem.md
│   │
│   └── main.dart                    # Entry point aplikasi
│
├── android/                         # Android native code
├── ios/                             # iOS native code
├── web/                             # Web support (optional)
├── windows/                         # Windows support (optional)
├── linux/                           # Linux support (optional)
├── macos/                           # macOS support (optional)
│
├── pubspec.yaml                     # Dependencies & configuration
├── pubspec.lock                     # Lock file (generated)
├── analysis_options.yaml            # Lint rules
├── .gitignore                       # Git ignore rules
└── README.md                        # Dokumentasi utama (file ini)

```

---

## 4. DAFTAR LIBRARY DAN DEPENDENCIES

Aplikasi memanfaatkan library standar industri untuk memastikan performa dan kemudahan pemeliharaan:

### Production Dependencies

| Library | Versi | Fungsi |
|---------|-------|--------|
| **sqflite** | ^2.4.2 | Database SQLite lokal (offline-first) |
| **path_provider** | ^2.0.0 | Lokasi penyimpanan database & files |
| **path** | ^1.8.0 | Manipulasi path file cross-platform |
| **intl** | ^0.19.0 | Format Rupiah, Tanggal, Waktu (i18n) |
| **pdf** | ^3.10.0 | Generate dokumen PDF (karcis, struk) |
| **printing** | ^5.11.0 | Preview & cetak PDF ke printer |
| **shared_preferences** | ^2.0.0 | Persistensi lokal (flag onboarding, user session) |
| **flutter_launcher_icons** | ^0.13.0 | Generate launcher icon otomatis |
| **flutter_native_splash** | ^2.3.0 | Generate native splash screen |
| **cupertino_icons** | ^1.0.8 | iOS-style icons |

### Dev Dependencies

| Library | Fungsi |
|---------|--------|
| **flutter_test** | Unit testing framework |
| **flutter_lints** | Code quality & style linting |

---

## 5. SKEMA DATABASE (6 TABEL UTAMA)

Sistem menggunakan SQLite dengan integritas data yang ketat menggunakan UNIQUE constraints dan Foreign Keys.

### tb_user (Manajemen Pengguna)
```sql
CREATE TABLE tb_user (
  id_user INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_lengkap VARCHAR(50) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  role TEXT NOT NULL DEFAULT 'admin',      -- 'owner', 'admin', 'petugas'
  status TEXT NOT NULL DEFAULT 'aktif'     -- 'aktif', 'nonaktif'
)
```

### tb_jenis_kendaraan (Kategori Kendaraan)
```sql
CREATE TABLE tb_jenis_kendaraan (
  id_jenis INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_jenis VARCHAR(50) NOT NULL UNIQUE,  -- 'Motor', 'Mobil', dll
  tarif_per_jam INTEGER NOT NULL           -- Rp 2000, Rp 5000, dll
)
```

### tb_area_parkir (Manajemen Area Parkir)
```sql
CREATE TABLE tb_area_parkir (
  id_area INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_area VARCHAR(50) NOT NULL UNIQUE,   -- 'Area A', 'Area B', dll
  id_jenis INTEGER NOT NULL,
  kapasitas INTEGER NOT NULL,              -- Total slot
  terisi INTEGER NOT NULL DEFAULT 0,       -- Slot terisi saat ini
  FOREIGN KEY (id_jenis) REFERENCES tb_jenis_kendaraan(id_jenis)
)
```

### tb_kendaraan (Master Kendaraan)
```sql
CREATE TABLE tb_kendaraan (
  id_kendaraan INTEGER PRIMARY KEY AUTOINCREMENT,
  plat_nomor VARCHAR(15) NOT NULL UNIQUE, -- 'B 1234 ABC', 'D 5678 XYZ'
  id_jenis INTEGER NOT NULL,
  merk VARCHAR(50) NOT NULL,               -- 'Honda', 'Toyota', dll
  warna VARCHAR(30) NOT NULL,              -- 'Merah', 'Hitam', dll
  FOREIGN KEY (id_jenis) REFERENCES tb_jenis_kendaraan(id_jenis)
)
```

### tb_transaksi (Riwayat Parkir)
```sql
CREATE TABLE tb_transaksi (
  id_transaksi INTEGER PRIMARY KEY AUTOINCREMENT,
  id_kendaraan INTEGER NOT NULL,
  id_area INTEGER NOT NULL,
  waktu_masuk DATETIME NOT NULL,
  waktu_keluar DATETIME,                    -- NULL saat masuk, diisi saat keluar
  status TEXT NOT NULL DEFAULT 'Parkir',    -- 'Parkir', 'Selesai'
  total_biaya INTEGER,                      -- NULL saat masuk, diisi saat keluar
  id_user INTEGER NOT NULL,                 -- Petugas yang menangani
  FOREIGN KEY (id_kendaraan) REFERENCES tb_kendaraan(id_kendaraan),
  FOREIGN KEY (id_area) REFERENCES tb_area_parkir(id_area),
  FOREIGN KEY (id_user) REFERENCES tb_user(id_user)
)
```

### tb_log_aktivitas (Audit Trail - Append Only)
```sql
CREATE TABLE tb_log_aktivitas (
  id_log INTEGER PRIMARY KEY AUTOINCREMENT,
  id_user INTEGER NOT NULL,
  kategori_log TEXT NOT NULL,               -- 'Transaksi', 'Otorisasi'
  aktivitas VARCHAR(100) NOT NULL,          -- Deskripsi aksi
  waktu DATETIME NOT NULL,
  FOREIGN KEY (id_user) REFERENCES tb_user(id_user)
  -- CATATAN: Tidak boleh ada UPDATE/DELETE pada tabel ini!
)
```

### Validasi Kritis
- Username di `tb_user` UNIQUE (tidak boleh duplikat login)
- Plat nomor di `tb_kendaraan` UNIQUE
- Nama jenis kendaraan UNIQUE
- Nama area parkir UNIQUE
- Satu kendaraan tidak bisa masuk 2x sebelum checkout (cek status='Parkir')

---

## 6. FITUR UTAMA BERDASARKAN ROLE

### A. Owner Dashboard (Analitik & Audit Transparansi)

**Fitur-fitur:**
- **Analytics Dashboard**
  - Total Pendapatan (SUM dari total_biaya di tb_transaksi)
  - Jumlah Petugas Aktif (COUNT dari tb_user dengan role='petugas' dan status='aktif')
  - Jumlah Admin Aktif
  - Total Kendaraan Terdaftar (COUNT dari tb_kendaraan)
  - 5 Transaksi Terakhir (real-time update)

- **Quick Access Filter**
  - Hari Ini (filter transaksi yang dibuat hari ini)
  - Minggu Ini (7 hari terakhir)
  - Bulan Ini (bulan current)

- **Audit Transparansi (Read-Only)**
  - Tab 1: Log Transaksi (kategori = 'Transaksi')
  - Tab 2: Log Otorisasi (kategori = 'Otorisasi')
  - Visual: log_timeline_tile

- **History Global**
  - Data table seluruh transaksi dari tb_transaksi
  - Search bar untuk filter plat nomor
  - Filter status (Parkir / Selesai)

- **Manajemen SDM**
  - Floating button: Tambah akun baru (admin/petugas)
  - List karyawan dengan toggle status
  - Reset password user
  - Delete user

---

### B. Admin Dashboard (Manajer Operasional)

**Fitur-fitur:**
- **Dashboard Beranda**
  - List kendaraan parkir aktif (status = 'Parkir' di tb_transaksi)
  - Button Edit untuk koreksi data jika ada kesalahan kasir
  - Auto-log ke tb_log_aktivitas saat edit

- **Master Data Management**
  - Tab 1: CRUD Jenis Kendaraan (nama, tarif/jam)
  - Tab 2: CRUD Area Parkir (nama, kapasitas, pilih jenis)
  - Modal form untuk create/update
  - Data table dengan delete button

- **Manajemen Petugas**
  - List petugas (tb_user dengan role='petugas')
  - Toggle status aktif/nonaktif
  - Delete button (hanya visible untuk owner)
  - Auto-log status change

- **Audit Log Terbatas**
  - Filter log petugas saja (role='petugas')
  - Read-only view dengan log_timeline_tile
  - Tidak bisa melihat log admin/owner

---

### C. Petugas Dashboard (Kasir / Operasional)

**Fitur-fitur:**
- **Dashboard Beranda**
  - Summary card: Sisa slot real-time
  - 2 Tab: Check-In & Check-Out

- **Check-In Flow**
  - Form input: Plat nomor, Merk, Warna
  - Validasi: Cek duplikasi di tb_kendaraan
  - Klik "Simpan & Cetak Karcis"
  - Insert ke tb_kendaraan (jika baru)
  - Insert ke tb_transaksi (waktu_masuk = now, status='Parkir')
  - Update tb_area_parkir: terisi += 1
  - Generate PDF karcis via PdfService
  - Auto-insert log ke tb_log_aktivitas

- **Check-Out Flow**
  - Search filter 3 huruf plat nomor → list kendaraan parkir
  - Pilih kendaraan dari list
  - Modal popup: Ringkasan durasi, total biaya
  - Validasi durasi: `ceil(detik / 3600) * tarif`
  - Update tb_transaksi: status='Selesai', waktu_keluar=now, total_biaya=hitung
  - Update tb_area_parkir: terisi -= 1
  - Generate PDF struk invoice
  - Auto-insert log ke tb_log_aktivitas

- **Shift History**
  - List transaksi selesai hari ini
  - Visual: log_timeline_tile

- **Profile**
  - Nama, username, role
  - Ganti password

---

## 7. PANDUAN PENGEMBANGAN (CLI COMMANDS)

Untuk memperbarui aset aplikasi dan generate konfigurasi native, jalankan perintah berikut di terminal:

### Generate Launcher Icons
```bash
flutter pub run flutter_launcher_icons:main
```
Konfigurasi di `pubspec.yaml` section `flutter_launcher_icons`.

### Generate Native Splash Screen
```bash
flutter pub run flutter_native_splash:create
```
Konfigurasi di `pubspec.yaml` section `flutter_native_splash`.

### Run Aplikasi
```bash
flutter run
```

### Build APK (Android)
```bash
flutter build apk --release
```

### Build APP Bundle (Play Store)
```bash
flutter build appbundle --release
```

### Analyze Code Quality
```bash
flutter analyze
```

### Format Code
```bash
dart format lib/
```

---

## 📊 Status Implementasi

### ✅ SELESAI (Fase 1-5)
- [x] Setup proyek & pubspec.yaml configuration
- [x] Color palette & Material theme
- [x] Reusable widgets (5 widgets global)
- [x] Models & data classes (6 models)
- [x] DatabaseHelper dengan Singleton pattern (600+ lines)
- [x] Format helper utilities
- [x] Folder structure & assets setup

### 🚀 AKAN DATANG (Fase 6-10)
- [ ] Splash Screen & Onboarding UI
- [ ] Authentication Module (Login, Forgot Password, Change Password)
- [ ] Petugas Dashboard & Check-in/out
- [ ] Admin Dashboard & Master Data Management
- [ ] Owner Dashboard & Analytics

---

## 📝 Catatan Penting

- Aplikasi menggunakan **offline-first** architecture dengan SQLite
- Semua model memiliki konversi `.fromMap()` dan `.toMap()` otomatis
- DatabaseHelper menggunakan **Singleton pattern** untuk efisiensi memory
- Widgets 100% reusable dan fully customizable
- Setiap aksi penting otomatis di-log ke `tb_log_aktivitas` (append-only)
- Format numbers menggunakan `intl` package untuk Locale Indonesia
- Code mengikuti **Clean Code** dan **Flutter best practices**

---

## 📞 Support & Dokumentasi

Untuk informasi lebih detail tentang arsitektur dan alur pengembangan, lihat folder `lib/doc/` yang berisi dokumentasi lengkap terbagi menjadi 11 sub-folder:
- `00-setup-project/` - Setup proyek
- `01-ui-ux-design/` - Desain UI/UX
- `02-database-core/` - Arsitektur database
- `03-pdf-printing/` - Integrasi PDF printing
- `04-shared-logic/` - Shared logic & utilities
- `05-onboarding/` - Onboarding flow
- `06-auth-system/` - Authentication system
- `07-petugas-dashboard/` - Petugas dashboard specs
- `08-admin-dashboard/` - Admin dashboard specs
- `09-owner-dashboard/` - Owner dashboard specs
- `10-splash-screen/` - Splash screen setup

---

**Versi**: 1.0.0  
**Last Updated**: April 2026  
**Author**: Development Team
