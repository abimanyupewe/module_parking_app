MANAJEMEN PARKIR MULTI-ROLE (Aplikasi Flutter Modern)

Aplikasi ini adalah sistem manajemen parkir berbasis Flutter yang dirancang untuk kebutuhan operasional real-time dengan tiga peran utama: Owner, Admin, dan Petugas. Fokus utama aplikasi adalah pada kecepatan operasional, transparansi audit log otomatis, dan manajemen master data yang dinamis.

1. PANDUAN DESAIN UI/UX (COLOR PALETTE)

Aplikasi menggunakan tema Clean & Modern untuk kenyamanan operasional jangka panjang.
- Background: #FFFFFF (Putih Bersih) - Latar belakang utama aplikasi.
- Primary Color: #343858 (Gelap Elegan) - AppBar, Heading, Icon aktif, dan Tombol utama.
- Secondary Color: #EEF4FF (Biru Terang Halus) - Highlight Tab aktif dan Indikator status Selesai.
- Tertiary Color: #EEF1F7 (Abu-abu Kebiruan) - Latar belakang form input dan tabel data.
- Text & Icon Inactive: #737686 (Abu-abu Netral) - Teks sekunder dan label form.

2. ARSITEKTUR FOLDER (MODULAR & GRANULAR)

Proyek ini menerapkan prinsip Clean Architecture dengan memisahkan komponen antarmuka, logika bisnis, dan data secara terstruktur di bawah folder lib/features/.

Struktur Folder Fitur (Contoh: lib/features/owner/):
- pages/: Kontainer halaman utama (UI screens).
- widgets/: Komponen UI spesifik yang hanya digunakan oleh fitur tersebut.
- controllers/: Logika bisnis, manajemen state, dan query database (SQLite).

Struktur Global:
- lib/widgets/: Komponen reusable yang digunakan di seluruh aplikasi (custom_textfield, primary_button, summary_card, status_badge, log_timeline_tile).
- lib/doc/: Pusat dokumentasi teknis proyek yang terbagi dalam folder bernomor (00-10).

3. DAFTAR LIBRARY DAN DEPENDENCIES

Aplikasi memanfaatkan library standar industri untuk memastikan performa dan kemudahan pemeliharaan:
- sqlite: Manajemen basis data relasional lokal (Offline-first).
- flutter_native_splash: Menangani Splash Screen pada level native Android/iOS.
- flutter_launcher_icons: Otomatisasi pembuatan ikon aplikasi di berbagai platform.
- cupertino_icons: Ikon standar untuk konsistensi di perangkat iOS.
- flutter_lints: Menjaga standar kualitas kode (Clean Code).

4. SKEMA DATABASE (6 TABEL UTAMA)

Sistem menggunakan SQLite dengan integritas data yang ketat (UNIQUE & Foreign Key):
- tb_user: Data pengguna dengan role (owner, admin, petugas) dan status (aktif/nonaktif).
- tb_jenis_kendaraan: Master kategori kendaraan (Motor, Mobil, dll) dan tarif per jam.
- tb_area_parkir: Manajemen kapasitas lahan parkir per blok/area.
- tb_kendaraan: Master data fisik kendaraan (Plat Nomor UNIQUE).
- tb_transaksi: Log operasional parkir (Masuk, Keluar, Biaya).
- tb_log_aktivitas: Audit sistem otomatis (Read-Only, No Update/Delete).

5. FITUR UTAMA BERDASARKAN ROLE

A. Owner Dashboard (Analitik & Audit)
- Ringkasan pendapatan (SUM total biaya) dan jumlah SDM aktif.
- Audit Log Otomatis: Monitoring riwayat transaksi dan otorisasi secara transparan.
- Manajemen SDM: Menambah akun dan mengontrol status aktif/nonaktif petugas/admin.

B. Admin Dashboard (Manajer Operasional)
- Monitoring kendaraan parkir secara real-time.
- Koreksi Data: Edit transaksi aktif jika terjadi kesalahan input kasir.
- Master Data: Pengaturan kategori kendaraan dan kapasitas area parkir.

C. Petugas Dashboard (Kasir / Operasional)
- Check-in: Input plat nomor cepat dengan validasi duplikasi parkir.
- Check-out: Fitur search plat nomor otomatis dan kalkulasi biaya instan.
- Monitoring Slot: Informasi sisa lahan parkir secara real-time.

6. PANDUAN PENGEMBANGAN (CLI COMMANDS)

Untuk memperbarui aset aplikasi, jalankan perintah berikut di terminal:
- Generasi Icon: flutter pub run flutter_launcher_icons:main
- Generasi Splash: flutter pub run flutter_native_splash:create

Catatan: Dokumen README ini akan diperbarui secara berkala sesuai dengan perkembangan fitur dan perubahan struktur pada proyek.
