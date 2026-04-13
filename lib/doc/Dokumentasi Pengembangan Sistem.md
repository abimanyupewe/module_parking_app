# **DOKUMENTASI PENGEMBANGAN SISTEM (DEVELOPMENT DOC)**

**Aplikasi Manajemen Parkir Multi-Role**  
*(Dapat digunakan sebagai lampiran Laporan UKK Siswa)*

## **1. DESAIN PANDUAN UI/UX (Color Setup & Tema)**

Aplikasi ini menggunakan tema *Clean & Modern* dengan latar belakang putih bersih, memastikan kemudahan membaca (*readability*) dan kenyamanan mata bagi petugas yang menggunakannya seharian.

* **Background (Putih Bersih):** \#FFFFFF — Digunakan untuk latar belakang utama aplikasi (Scaffold).  
* **Primary Color (Gelap Elegan):** \#343858 — Digunakan untuk App Bar, teks *heading* utama, warna *icon* menu aktif, dan tombol aksi utama (seperti tombol "Simpan" atau "Login").  
* **Secondary Color (Biru Terang Halus):** \#EEF4FF — Digunakan untuk elemen *highlight*, latar belakang *Card* atau *Tab* yang sedang aktif, atau indikator status "Selesai/Aman".  
* **Tertiary / Input Color (Abu-abu Kebiruan):** \#EEF1F7 — Digunakan untuk latar belakang form pengisian (TextField), efek *hover*, dan warna latar tabel data.  
* **Text & Icon Inactive (Abu-abu Netral):** \#737686 — Digunakan untuk teks sekunder (sub-judul), label pada form, garis batas (*border*), dan *icon* menu yang tidak sedang dipilih.  
* *Catatan Tambahan:* Gunakan warna Merah standar bawaan Material Design hanya untuk peringatan (seperti "Slot Penuh", "Hapus Data", atau akun "Nonaktif").

## **2. ARSITEKTUR FOLDER & KOMPONEN (WIDGETS)**

Untuk menghindari penumpukan ratusan baris kode di satu file (*Spaghetti Code*), aplikasi ini menerapkan prinsip *Clean Code* dengan memisahkan komponen antarmuka (*UI Components*) ke dalam file terpisah.  
Semua komponen yang bisa didaur ulang (*reusable*) akan diletakkan di dalam folder **lib/widgets/**. Saat membuat halaman (screens), developer hanya perlu memanggil *widget* ini.  

**Daftar Widget yang Dipisah:**

1. **custom_textfield.dart**: Komponen form input (dengan warna latar \#EEF1F7 dan *border* radius yang halus). Bisa digunakan untuk form login, form input plat nomor, dan form tambah data master.  
2. **primary_button.dart**: Komponen tombol aksi utama (berwarna \#343858 dengan teks putih). Bisa diatur lebar dan teksnya secara dinamis.  
3. **summary_card.dart**: Komponen kotak/kartu (*Card*) untuk menampilkan ringkasan data. Digunakan di Dashboard Owner (Total Pendapatan) dan Dashboard Petugas (Sisa Slot Area).  
4. **status_badge.dart**: Label kecil penanda status dengan warna dinamis (contoh: hijau untuk 'Aktif'/'Selesai', merah untuk 'Nonaktif'/'Parkir'). Digunakan di dalam tabel data.  
5. **log_timeline_tile.dart**: Desain khusus berbentuk *list* bergaris untuk menampilkan riwayat log aktivitas agar terlihat rapi dan elegan.

## **3. DESAIN BASIS DATA (Database Schema)**

Aplikasi ini menggunakan SQLite dengan skema relasional kompleks yang terdiri dari 6 tabel. Beberapa kolom menggunakan *constraint* UNIQUE untuk menjaga integritas data agar tidak terjadi duplikasi ganda.

### **A. Tabel tb_user**

Menyimpan data pengguna aplikasi. Ditambahkan kolom status agar Admin/Owner bisa menonaktifkan (*disable*) akun tanpa harus menghapus datanya.

| Nama Atribut | Tipe Data | Keterangan |
| :---- | :---- | :---- |
| id_user | INTEGER | Primary Key, Auto Increment |
| nama_lengkap | VARCHAR(50) | Nama asli pengguna |
| username | VARCHAR(50) | Untuk login **(UNIQUE)** |
| password | VARCHAR(100) | Kata sandi login |
| role | TEXT / ENUM | 'admin', 'petugas', 'owner' |
| status | TEXT / ENUM | 'aktif', 'nonaktif' (Default: aktif) |

### **B. Tabel tb_jenis_kendaraan (Kategori Master)**

Menyimpan kategori kendaraan (Motor, Mobil, Truk, dll) beserta tarifnya. Dibuat dinamis agar Admin bisa menambah kategori baru kapan saja.

| Nama Atribut | Tipe Data | Keterangan |
| :---- | :---- | :---- |
| id_jenis | INTEGER | Primary Key, Auto Increment |
| nama_jenis | VARCHAR(50) | Contoh: 'Motor Roda 2' **(UNIQUE)** |
| tarif_per_jam | INTEGER | Harga per jam (Rp) |

### **C. Tabel tb_area_parkir**

Menyimpan informasi kapasitas lahan parkir dan dikhususkan untuk kategori kendaraan tertentu.

| Nama Atribut | Tipe Data | Keterangan |
| :---- | :---- | :---- |
| id_area | INTEGER | Primary Key, Auto Increment |
| nama_area | VARCHAR(50) | Contoh: "Blok A" **(UNIQUE)** |
| id_jenis | INTEGER | Foreign Key ke tb_jenis_kendaraan |
| kapasitas | INTEGER | Kapasitas maksimal kendaraan |
| terisi | INTEGER | Jumlah kendaraan yang sedang parkir |

### **D. Tabel tb_kendaraan**

Menyimpan master data fisik kendaraan yang pernah masuk ke area parkir.

| Nama Atribut | Tipe Data | Keterangan |
| :---- | :---- | :---- |
| id_kendaraan | INTEGER | Primary Key, Auto Increment |
| plat_nomor | VARCHAR(15) | Plat nomor kendaraan **(UNIQUE)** |
| id_jenis | INTEGER | Foreign Key ke tb_jenis_kendaraan |
| merk | VARCHAR(50) | Contoh: "Honda Vario", "Toyota Avanza" |
| warna | VARCHAR(30) | Contoh: "Hitam", "Putih" |

### **E. Tabel tb_transaksi (Operasional)**

Menyimpan riwayat parkir. *Validasi Logika: Kendaraan dengan id_kendaraan yang sama TIDAK BISA di-insert ke tabel ini jika masih ada data yang berstatus 'Parkir' (belum checkout).*

| Nama Atribut | Tipe Data | Keterangan |
| :---- | :---- | :---- |
| id_transaksi | INTEGER | Primary Key, Auto Increment |
| id_kendaraan | INTEGER | Foreign Key ke tb_kendaraan |
| id_area | INTEGER | Foreign Key ke tb_area_parkir |
| waktu_masuk | DATETIME | Waktu kendaraan masuk |
| waktu_keluar | DATETIME | Waktu kendaraan keluar (Bisa NULL) |
| status | TEXT / ENUM | 'Parkir', 'Selesai' |
| total_biaya | INTEGER | Dihitung saat checkout |
| id_user | INTEGER | Foreign Key ke tb_user (Petugas) |

### **F. Tabel tb_log_aktivitas (Transparansi Sistem)**

Menyimpan riwayat sistem. **Aturan Mutlak:** Aplikasi TIDAK BOLEH memiliki fungsi UPDATE atau DELETE untuk tabel ini. (Read-Only).

| Nama Atribut | Tipe Data | Keterangan |
| :---- | :---- | :---- |
| id_log | INTEGER | Primary Key, Auto Increment |
| id_user | INTEGER | Foreign Key ke user yang bertugas |
| kategori_log | TEXT / ENUM | 'Transaksi' atau 'Otorisasi' |
| aktivitas | VARCHAR(100) | Contoh: "Edit Kendaraan", "Disable Petugas" |
| waktu | DATETIME | Waktu aktivitas dilakukan |

## **4. PEMBAGIAN FITUR & UI BERDASARKAN ROLE**

### **1. owner_dashboard.dart (Pemegang Kendali Penuh)**

Halaman ini dirancang untuk pimpinan dengan tampilan yang menekankan pada analitik, laporan, dan transparansi.

* **Halaman Beranda (Dashboard Overview):**  
  * *Quick Access:* Filter rentang waktu laporan (Hari Ini, Minggu Ini, Bulan Ini) di pojok kanan atas.  
  * *Widget Ringkasan (Grid):* Menggunakan summary_card.dart untuk menampilkan Total Pendapatan (\#343858), Jumlah Petugas Aktif, Jumlah Admin, dan Total Kendaraan.  
  * *Tabel Mini:* Menampilkan 5 transaksi terakhir secara *real-time*.  
* **Halaman Audit Transparansi (Log Aktivitas):**  
  * *Konten:* Menggunakan 2 *Tab Bar* dengan *background* aktif \#EEF4FF.  
  * *Tab 1 (Log Transaksi):* Riwayat kasir diimplementasikan menggunakan log_timeline_tile.dart.  
  * *Tab 2 (Log Otorisasi):* Riwayat admin. Data bersifat *Read-Only*.  
* **Halaman History Global:**  
  * *Konten:* Data Table yang berisi seluruh riwayat transaksi. Dilengkapi *Search bar* (berwarna \#EEF1F7) untuk mencari plat nomor.  
* **Halaman Manajemen SDM:**  
  * *Quick Access:* Tombol FAB "Tambah SDM Baru".  
  * *Konten:* List karyawan. Terdapat *Toggle Switch* untuk mengubah status aktif/nonaktif.

### **2. admin_dashboard.dart (Manajer Operasional)**

Halaman ini fokus pada pengaturan konfigurasi sistem, perbaikan data, dan kontrol area parkir.

* **Halaman Beranda (Monitoring Parkir):**  
  * *Quick Access:* Tombol aksi cepat di header.  
  * *Konten Utama:* *List view* kendaraan yang sedang parkir saat ini (status \= 'Parkir'). Jika kasir salah input, Admin bisa menekan tombol *Edit*.  
* **Halaman Master Kategori & Area:**  
  * *Tab Kategori & Area:* Tabel CRUD untuk tb_jenis_kendaraan dan tb_area_parkir. Menggunakan custom_textfield.dart pada *modal popup* form inputnya.  
* **Halaman Manajemen Petugas:**  
  * *Konten:* Melihat daftar Petugas dan fungsi *Disable*. Tombol Hapus di-*hide* untuk Admin.  
* **Halaman Audit Terbatas:**  
  * *Konten:* Menampilkan Log Aktivitas yang HANYA milik Petugas saja.

### **3. petugas_dashboard.dart (Kasir / Ujung Tombak)**

UI halaman ini harus sangat bersih, elemen *input*\-nya besar (agar tidak salah ketik), dan proses kerjanya instan.

* **Halaman Beranda Operasional:**  
  * *Informasi Area (Header):* Menggunakan summary_card.dart (warna \#EEF4FF) untuk menampilkan sisa slot parkir *real-time*.  
  * *Tab Kendaraan Masuk:* Memanggil custom_textfield.dart untuk Form Input Plat Nomor, Merk, dan Warna. Di bawahnya memanggil primary_button.dart untuk "Simpan & Cetak Karcis".  
  * *Tab Kendaraan Keluar:* Terdapat kolom *Search* raksasa. Mengetik 3 huruf plat nomor akan otomatis memfilter data.  
* **Alur Checkout (Pop-up Modal):**  
  * Saat checkout, muncul *Pop-up Dialog* merangkum Durasi dan **Total Biaya**.

## **5. TASK LIST PENGEMBANGAN (To-Do List Siswa)**

* **Fase 1: Setup & Database Tingkat Lanjut**  
  * [x] Membuat database_helper.dart dengan 6 tabel (menerapkan UNIQUE).  
  * [x] Menyalin sintaks ke file eksternal database_parkir.sql.  
* **Fase 2: Arsitektur UI (Pembuatan Reusable Widgets)**  
  * [ ] Mengatur warna utama aplikasi di MaterialApp *theme* sesuai panduan palet warna (Primary \#343858, dll).  
  * [ ] Membuat folder lib/widgets/.  
  * [ ] Membuat file custom_textfield.dart (Desain form input standar).  
  * [ ] Membuat file primary_button.dart (Tombol aksi standar).  
  * [ ] Membuat file summary_card.dart (Kotak dashboard).  
* **Fase 3: Core Logic (Biaya & PDF Service)**
  * [ ] Menambahkan dependencies `pdf`, `printing`, dan `intl` di `pubspec.yaml`.
  * [ ] Membuat file `03-logika-biaya-parkir.md` (Sudah dibuat).
  * [ ] Membuat file `01-flow-cetak-struk.md` (Sudah dibuat).
  * [ ] Implementasi class `FormatHelper` untuk Rupiah & Tanggal.
* **Fase 4: Autentikasi & Security Validasi**  
  * [ ] Membuat UI Login (memanggil custom_textfield dan primary_button).  
  * [ ] Menambahkan logika: Cek status user di database. Jika 'nonaktif', tolak login dan tampilkan *Alert*.  
* **Fase 5: Modul Petugas (UI Cepat & Validasi)**  
  * [ ] Membuat UI Form Input Masuk & Keluar.  
  * [ ] Membuat query SELECT untuk memeriksa status plat_nomor agar tidak terjadi duplikasi parkir berjalan.  
  * [ ] Membuat *trigger/logic* update kolom terisi di tb_area_parkir.  
  * [ ] Integrasi Cetak Struk PDF saat Check-in & Check-out.
* **Fase 6: Modul Admin (Manajemen Master Data)**  
  * [ ] Membuat UI Modal Form untuk CRUD tb_jenis_kendaraan & tb_area_parkir.  
  * [ ] Membuat fungsi *Update Status User* untuk men-disable Petugas.  
* **Fase 7: Modul Owner & Transparansi Log**  
  * [ ] Mengunci *query* tabel tb_log_aktivitas khusus untuk INSERT saja.  
  * [ ] Membuat UI *Tab Bar* elegan untuk Owner (Log Transaksi & Log Otorisasi).  
  * [ ] Ekstraksi query agregasi SQLite (seperti SUM(total_biaya)) untuk ditampilkan pada *Widget* Ringkasan.
