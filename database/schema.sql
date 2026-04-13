-- =============================================================================
-- DATABASE SCHEMA: PARKING MANAGEMENT SYSTEM
-- =============================================================================
-- Database untuk Aplikasi Manajemen Parkir Multi-Role (Owner, Admin, Petugas)
-- 
-- Tujuan:
--   Mengelola sistem parkir dengan fitur:
--   - Autentikasi user dengan role-based access control
--   - Manajemen area parkir dan kendaraan
--   - Pencatatan transaksi parkir (masuk/keluar)
--   - Perhitungan biaya otomatis
--   - Audit trail untuk semua aktivitas
-- =============================================================================

-- =============================================================================
-- TABEL 1: TB_USER
-- Fungsi: Menyimpan data pengguna sistem (Owner, Admin, Petugas)
-- =============================================================================
CREATE TABLE tb_user (
  -- PRIMARY KEY: Identifier unik untuk setiap user
  id_user INTEGER PRIMARY KEY AUTOINCREMENT,
  
  -- Informasi Dasar User
  nama_lengkap VARCHAR(50) NOT NULL,
    -- Nama lengkap pengguna
    -- Contoh: 'Budi Santoso', 'Admin Parkir'
  
  username VARCHAR(50) NOT NULL UNIQUE,
    -- Username untuk login (HARUS UNIK untuk mencegah duplikasi)
    -- Contoh: 'owner', 'admin1', 'petugas_a'
    -- Min 3 karakter, tidak boleh ada spasi
  
  password VARCHAR(100) NOT NULL,
    -- Password ter-hash menggunakan bcrypt (untuk keamanan)
    -- TIDAK PERNAH menyimpan password plain text
    -- Panjang hash bcrypt selalu 60 karakter
  
  -- Role & Status User
  role TEXT NOT NULL DEFAULT 'Admin',
    -- Tipe role user: 'Owner', 'Admin', atau 'Petugas'
    -- Owner: Pemilik sistem (akses penuh)
    -- Admin: Administrator sistem (kelola user, laporan)
    -- Petugas: Operator parkir (catat masuk/keluar)
  
  status TEXT NOT NULL DEFAULT 'aktif',
    -- Status akun: 'aktif' atau 'nonaktif'
    -- User dengan status 'nonaktif' tidak bisa login
  
  -- Keamanan Tambahan
  security_question TEXT,
    -- Pertanyaan keamanan untuk reset password
    -- Contoh: 'Apa nama perusahaan Anda?'
  
  security_answer TEXT,
    -- Jawaban dari security question (ter-hash dengan bcrypt)
    -- Digunakan untuk verifikasi saat reset password
  
  is_default_password BOOLEAN DEFAULT 1
    -- Flag untuk menandai password default (perlu diubah)
    -- 1 = password default, 0 = password sudah diganti user
);

-- =============================================================================
-- TABEL 2: TB_JENIS_KENDARAAN
-- Fungsi: Menyimpan tipe-tipe kendaraan yang bisa parkir
-- =============================================================================
CREATE TABLE tb_jenis_kendaraan (
  -- PRIMARY KEY: Identifier unik untuk tipe kendaraan
  jenis_id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  nama_jenis VARCHAR(50) NOT NULL UNIQUE,
    -- Nama tipe kendaraan (HARUS UNIK)
    -- Contoh: 'Motor', 'Mobil', 'Truk'
  
  tarif_per_jam INTEGER NOT NULL
    -- Tarif parkir per jam dalam Rupiah
    -- Contoh: 2000 (motor), 5000 (mobil), 10000 (truk)
    -- Digunakan untuk menghitung biaya saat kendaraan keluar
);

-- =============================================================================
-- TABEL 3: TB_AREA_PARKIR
-- Fungsi: Menyimpan data area/lokasi parkir di lapangan
-- Relasi: Mengacu ke TB_JENIS_KENDARAAN (Foreign Key)
-- =============================================================================
CREATE TABLE tb_area_parkir (
  -- PRIMARY KEY: Identifier unik untuk setiap area
  area_id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  nama_area VARCHAR(50) NOT NULL UNIQUE,
    -- Nama area parkir (HARUS UNIK)
    -- Contoh: 'Lantai 1 Motor', 'Lantai 2 Mobil', 'Basement A'
  
  -- FOREIGN KEY: Mengacu ke TB_JENIS_KENDARAAN
  jenis_id INTEGER NOT NULL,
    -- ID tipe kendaraan yang boleh parkir di area ini
    -- Contoh: jenis_id = 1 (hanya motor)
    -- REFERENSI: tb_jenis_kendaraan.jenis_id
  
  kapasitas INTEGER NOT NULL,
    -- Jumlah total slot parkir di area ini
    -- Contoh: 100 (kapasitas 100 motor)
  
  terisi INTEGER NOT NULL DEFAULT 0,
    -- Jumlah slot yang sedang terisi saat ini
    -- Diupdate otomatis saat ada kendaraan masuk/keluar
    -- Nilai: 0 sampai kapasitas
  
  -- Constraint untuk relasi Foreign Key
  FOREIGN KEY (jenis_id) REFERENCES tb_jenis_kendaraan(jenis_id)
);

-- =============================================================================
-- TABEL 4: TB_KENDARAAN
-- Fungsi: Menyimpan data kendaraan yang parkir di sistem
-- Relasi: Mengacu ke TB_JENIS_KENDARAAN (Foreign Key)
-- =============================================================================
CREATE TABLE tb_kendaraan (
  -- PRIMARY KEY: Identifier unik untuk setiap kendaraan
  kendaraan_id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  plat_nomor VARCHAR(15) NOT NULL UNIQUE,
    -- Nomor plat kendaraan (HARUS UNIK)
    -- Format Indonesia: L XXXX XXXX atau L XX XXXX
    -- Contoh: 'H 1234 BCA', 'B 5678 CDE'
  
  -- FOREIGN KEY: Mengacu ke TB_JENIS_KENDARAAN
  jenis_id INTEGER NOT NULL,
    -- ID tipe kendaraan
    -- Contoh: jenis_id = 1 (motor), jenis_id = 2 (mobil)
    -- REFERENSI: tb_jenis_kendaraan.jenis_id
  
  merk VARCHAR(50) NOT NULL,
    -- Merek/pabrikan kendaraan
    -- Contoh: 'Honda', 'Toyota', 'Yamaha'
  
  warna VARCHAR(30) NOT NULL,
    -- Warna kendaraan untuk identifikasi visual
    -- Contoh: 'Merah', 'Hitam', 'Putih'
  
  -- Constraint untuk relasi Foreign Key
  FOREIGN KEY (jenis_id) REFERENCES tb_jenis_kendaraan(jenis_id)
);

-- =============================================================================
-- TABEL 5: TB_TRANSAKSI
-- Fungsi: Mencatat setiap transaksi parkir (masuk dan keluar)
-- Relasi: Foreign Key ke TB_KENDARAAN, TB_AREA_PARKIR, TB_USER
-- =============================================================================
CREATE TABLE tb_transaksi (
  -- PRIMARY KEY: Identifier unik untuk setiap transaksi
  transaksi_id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  -- FOREIGN KEY: Kendaraan yang parkir
  kendaraan_id INTEGER NOT NULL,
    -- ID kendaraan (dari TB_KENDARAAN)
    -- Contoh: kendaraan_id = 5
    -- REFERENSI: tb_kendaraan.kendaraan_id
  
  -- FOREIGN KEY: Area tempat parkir
  area_id INTEGER NOT NULL,
    -- ID area parkir (dari TB_AREA_PARKIR)
    -- Contoh: area_id = 2 (Lantai 2 Mobil)
    -- REFERENSI: tb_area_parkir.area_id
  
  -- Waktu Transaksi
  waktu_masuk DATETIME NOT NULL,
    -- Waktu kendaraan masuk ke area parkir
    -- Format: 'YYYY-MM-DD HH:MM:SS'
    -- Contoh: '2024-01-15 08:30:00'
  
  waktu_keluar DATETIME,
    -- Waktu kendaraan keluar (NULL jika belum keluar)
    -- Diisi saat user mencatat kendaraan keluar
  
  -- Status Transaksi
  status TEXT NOT NULL DEFAULT 'parkir',
    -- Status transaksi: 'parkir' atau 'keluar'
    -- 'parkir': kendaraan masih di area
    -- 'keluar': kendaraan sudah keluar & transaksi selesai
  
  -- Biaya Parkir
  total_biaya INTEGER,
    -- Total biaya parkir dalam Rupiah
    -- NULL saat status masih 'parkir'
    -- Dihitung saat keluar: (durasi jam) × (tarif_per_jam)
    -- Contoh: 2 jam × Rp5000 = Rp10000
  
  -- FOREIGN KEY: User yang mencatat transaksi
  user_id INTEGER NOT NULL,
    -- ID user petugas yang mencatat transaksi
    -- REFERENSI: tb_user.id_user
  
  -- Constraints untuk relasi Foreign Key
  FOREIGN KEY (kendaraan_id) REFERENCES tb_kendaraan(kendaraan_id),
  FOREIGN KEY (area_id) REFERENCES tb_area_parkir(area_id),
  FOREIGN KEY (user_id) REFERENCES tb_user(id_user)
);

-- =============================================================================
-- TABEL 6: TB_LOG_AKTIVITAS
-- Fungsi: Mencatat semua aktivitas user untuk audit trail dan monitoring
-- Relasi: Foreign Key ke TB_USER
-- =============================================================================
CREATE TABLE tb_log_aktivitas (
  -- PRIMARY KEY: Identifier unik untuk setiap log
  log_id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  -- FOREIGN KEY: User yang melakukan aktivitas
  user_id INTEGER NOT NULL,
    -- ID user yang melakukan aksi
    -- REFERENSI: tb_user.id_user
  
  kategori_log TEXT NOT NULL,
    -- Kategori aktivitas yang dicatat
    -- Contoh: 'Otorisasi', 'Input Data', 'Hapus Data', 'Cetak Laporan'
  
  aktivitas VARCHAR(100) NOT NULL,
    -- Deskripsi detail aktivitas yang dilakukan
    -- Contoh: 'Login ke sistem', 'Tambah user baru', 'Ubah tarif motor'
  
  waktu DATETIME NOT NULL
    -- Waktu aktivitas terjadi
    -- Format: 'YYYY-MM-DD HH:MM:SS'
    -- Contoh: '2024-01-15 08:30:45'
);

-- =============================================================================
-- DEFAULT DATA UNTUK PEMBELAJARAN
-- =============================================================================

-- Insert: Tipe Kendaraan Default
-- Dua tipe kendaraan dasar: Motor dan Mobil
INSERT INTO tb_jenis_kendaraan (nama_jenis, tarif_per_jam) 
VALUES ('Motor', 2000);

INSERT INTO tb_jenis_kendaraan (nama_jenis, tarif_per_jam) 
VALUES ('Mobil', 5000);

-- Insert: Default Users untuk Testing
-- Username: owner, admin1, petugas1 | Password: semua 123456 (ter-hash dengan bcrypt)
-- Note: Password yang ditampilkan di sini adalah HASHED, bukan plain text

-- User 1: Owner
INSERT INTO tb_user (
  nama_lengkap, 
  username, 
  password, 
  role, 
  status,
  security_question,
  security_answer,
  is_default_password
) 
VALUES (
  'Owner Parkir',
  'owner',
  '$2a$12$abcdefghijklmnopqrstuvwxyz1234567890abcdefghij',
  'Owner',
  'aktif',
  'Apa nama perusahaan Anda?',
  '$2a$12$abcdefghijklmnopqrstuvwxyz0987654321fedcbahij',
  0
);

-- User 2: Admin
INSERT INTO tb_user (
  nama_lengkap, 
  username, 
  password, 
  role, 
  status,
  security_question,
  security_answer,
  is_default_password
) 
VALUES (
  'Admin Sistem',
  'admin1',
  '$2a$12$abcdefghijklmnopqrstuvwxyz1234567890abcdefghij',
  'Admin',
  'aktif',
  'Siapa nama manajer?',
  '$2a$12$abcdefghijklmnopqrstuvwxyz0987654321fedcbahij',
  0
);

-- User 3: Petugas
INSERT INTO tb_user (
  nama_lengkap, 
  username, 
  password, 
  role, 
  status,
  security_question,
  security_answer,
  is_default_password
) 
VALUES (
  'Petugas Parkir',
  'petugas1',
  '$2a$12$abcdefghijklmnopqrstuvwxyz1234567890abcdefghij',
  'Petugas',
  'aktif',
  'Nomor identitas?',
  '$2a$12$abcdefghijklmnopqrstuvwxyz0987654321fedcbahij',
  0
);

-- =============================================================================
-- PENJELASAN RELASI ANTAR TABEL (ENTITY RELATIONSHIP)
-- =============================================================================
/*
RELASI DIAGRAM:

    TB_USER
      |
      +----> TB_LOG_AKTIVITAS (user_id FK)
      |
      +----> TB_TRANSAKSI (user_id FK)
                    |
                    +----> TB_KENDARAAN (kendaraan_id FK)
                    |              |
                    |              +----> TB_JENIS_KENDARAAN (jenis_id FK)
                    |
                    +----> TB_AREA_PARKIR (area_id FK)
                                   |
                                   +----> TB_JENIS_KENDARAAN (jenis_id FK)

PENJELASAN RELASI:

1. TB_USER (Pusat)
   - Menyimpan semua pengguna sistem
   - Setiap user punya role yang berbeda (Owner, Admin, Petugas)

2. TB_JENIS_KENDARAAN (Master Data)
   - Tabel referensi untuk tipe kendaraan
   - Digunakan oleh TB_AREA_PARKIR dan TB_KENDARAAN
   - Contoh: 1 = Motor (tarif Rp2000/jam), 2 = Mobil (tarif Rp5000/jam)

3. TB_AREA_PARKIR (Master Data)
   - Tabel referensi untuk area/lokasi parkir
   - Setiap area untuk tipe kendaraan tertentu (via FK ke TB_JENIS_KENDARAAN)
   - Contoh: Area 1 = "Lantai 1 Motor" (jenis_id=1, kapasitas=100)

4. TB_KENDARAAN (Master Data)
   - Tabel referensi untuk data kendaraan
   - Diisi saat kendaraan pertama kali datang
   - Setiap kendaraan punya jenis tertentu (via FK ke TB_JENIS_KENDARAAN)
   - Identifikasi unik: plat_nomor (UNIQUE)

5. TB_TRANSAKSI (Transaction Data - PALING PENTING)
   - Mencatat SETIAP kali ada kendaraan parkir
   - Relasi ke 3 tabel:
     * kendaraan_id → TB_KENDARAAN (mobil apa yang parkir)
     * area_id → TB_AREA_PARKIR (di mana dia parkir)
     * user_id → TB_USER (siapa yang mencatat)
   - Status: 'parkir' (masih di lapangan) atau 'keluar' (sudah pergi)
   - Biaya dihitung saat keluar dari durasi × tarif

6. TB_LOG_AKTIVITAS (Audit Trail)
   - Mencatat semua aksi user untuk keamanan dan monitoring
   - Relasi ke TB_USER (siapa yang melakukan aksi)
   - Contoh log: Login, Tambah user, Ubah tarif, Cetak laporan

CONTOH FLOW TRANSAKSI PARKIR:

Skenario: Kendaraan motor masuk jam 08:00, keluar jam 10:30
1. User (petugas) input: Kendaraan masuk dengan plat_nomor 'H 1234 ABC'
2. Sistem cari/buat record di TB_KENDARAAN jika belum ada
3. Insert ke TB_TRANSAKSI:
   - kendaraan_id = (dari TB_KENDARAAN)
   - area_id = (area parkir motor)
   - waktu_masuk = '2024-01-15 08:00:00'
   - status = 'parkir'
   - user_id = (petugas yang input)
   - total_biaya = NULL (belum keluar)
4. Update TB_AREA_PARKIR.terisi = terisi + 1

5. Saat kendaraan keluar jam 10:30, user input:
6. Update TB_TRANSAKSI:
   - waktu_keluar = '2024-01-15 10:30:00'
   - status = 'keluar'
   - total_biaya = 2.5 jam × Rp2000 = Rp5000
7. Update TB_AREA_PARKIR.terisi = terisi - 1
8. Insert ke TB_LOG_AKTIVITAS: "Kendaraan keluar, biaya Rp5000"

*/

-- =============================================================================
-- QUERIES UMUM UNTUK PEMBELAJARAN
-- =============================================================================

-- 1. AUTENTIKASI: Cari user saat login
SELECT * FROM tb_user WHERE username = 'owner' AND status = 'aktif';

-- 2. DASHBOARD OWNER: Hitung total pendapatan hari ini
SELECT SUM(total_biaya) as total_pendapatan
FROM tb_transaksi 
WHERE DATE(waktu_keluar) = DATE('now') AND status = 'keluar';

-- 3. DASHBOARD: Kendaraan yang masih parkir (belum keluar)
SELECT 
  t.transaksi_id,
  k.plat_nomor,
  jk.nama_jenis,
  ap.nama_area,
  t.waktu_masuk,
  strftime('%H:%M', 'now') as waktu_sekarang
FROM tb_transaksi t
JOIN tb_kendaraan k ON t.kendaraan_id = k.kendaraan_id
JOIN tb_jenis_kendaraan jk ON k.jenis_id = jk.jenis_id
JOIN tb_area_parkir ap ON t.area_id = ap.area_id
WHERE t.status = 'parkir'
ORDER BY t.waktu_masuk ASC;

-- 4. LAPORAN: Hitung kapasitas area parkir
SELECT 
  nama_area,
  kapasitas,
  terisi,
  (kapasitas - terisi) as kosong,
  ROUND(CAST(terisi AS FLOAT) / kapasitas * 100, 2) as persentase_terisi
FROM tb_area_parkir;

-- 5. LAPORAN: Transaksi per hari
SELECT 
  DATE(waktu_masuk) as tanggal,
  COUNT(*) as jumlah_transaksi,
  SUM(total_biaya) as total_pendapatan
FROM tb_transaksi
WHERE status = 'keluar'
GROUP BY DATE(waktu_masuk)
ORDER BY tanggal DESC;

-- 6. AUDIT: Aktivitas user dalam 24 jam terakhir
SELECT 
  u.nama_lengkap,
  l.kategori_log,
  l.aktivitas,
  l.waktu
FROM tb_log_aktivitas l
JOIN tb_user u ON l.user_id = u.id_user
WHERE l.waktu >= datetime('now', '-24 hours')
ORDER BY l.waktu DESC;

-- 7. MANAJEMEN USER: List semua user dengan role mereka
SELECT 
  id_user,
  nama_lengkap,
  username,
  role,
  status
FROM tb_user
ORDER BY role, nama_lengkap;

-- =============================================================================
-- END OF SCHEMA DEFINITION
-- =============================================================================
