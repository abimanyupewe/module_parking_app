# 📊 Dokumentasi Database - Sistem Manajemen Parkir

## Pendahuluan

Database ini dirancang untuk aplikasi **Manajemen Parkir Multi-Role** yang digunakan oleh 3 jenis user:
- **Owner**: Pemilik sistem, akses penuh untuk laporan dan manajemen
- **Admin**: Mengelola user, tarif, dan laporan
- **Petugas**: Operator, mencatat kendaraan masuk/keluar

---

## 📋 Daftar Tabel dan Fungsinya

| No | Nama Tabel | Fungsi | Tipe |
|:--:|:-----------|:-------|:----:|
| 1 | **TB_USER** | Menyimpan data pengguna sistem | Master |
| 2 | **TB_JENIS_KENDARAAN** | Tipe kendaraan (Motor, Mobil, dll) | Master |
| 3 | **TB_AREA_PARKIR** | Lokasi/area parkir di lapangan | Master |
| 4 | **TB_KENDARAAN** | Data kendaraan yang pernah parkir | Master |
| 5 | **TB_TRANSAKSI** | Transaksi parkir (masuk & keluar) | Transaksi |
| 6 | **TB_LOG_AKTIVITAS** | Audit trail semua aktivitas user | Log |

---

## 1️⃣ TABEL TB_USER

### Fungsi
Menyimpan data semua pengguna yang bisa login ke sistem

### Struktur Kolom

| Kolom | Tipe | Constraint | Penjelasan |
|:------|:-----|:-----------|:-----------|
| **id_user** | INTEGER | PRIMARY KEY | ID unik user (auto increment) |
| **nama_lengkap** | VARCHAR(50) | NOT NULL | Nama lengkap pengguna |
| **username** | VARCHAR(50) | NOT NULL, UNIQUE | Username untuk login (unik, min 3 karakter) |
| **password** | VARCHAR(100) | NOT NULL | Password ter-hash bcrypt (panjang 60 karakter) |
| **role** | TEXT | NOT NULL, DEFAULT 'Admin' | Tipe role: Owner, Admin, atau Petugas |
| **status** | TEXT | NOT NULL, DEFAULT 'aktif' | Status: 'aktif' atau 'nonaktif' |
| **security_question** | TEXT | - | Pertanyaan keamanan untuk reset password |
| **security_answer** | TEXT | - | Jawaban keamanan (ter-hash) |
| **is_default_password** | BOOLEAN | DEFAULT 1 | Flag: 1=password default, 0=sudah diganti |

### Contoh Data
```
id_user  | nama_lengkap | username | role   | status
---------|--------------|----------|--------|--------
1        | Owner        | owner    | Owner  | aktif
2        | Budi Admin   | admin1   | Admin  | aktif
3        | Andi Petugas | petugas1 | Petugas| aktif
```

### Role dan Akses
- **Owner** (Pemilik): Akses penuh, laporan pendapatan, manajemen admin
- **Admin**: Kelola user, tarif, area parkir, laporan
- **Petugas**: Input masuk/keluar, lihat transaksi saat ini

### Catatan Keamanan ⚠️
- Password SELALU di-hash dengan bcrypt, TIDAK pernah disimpan plain text
- security_answer juga di-hash untuk keamanan
- is_default_password = 1 berarti user harus ganti password saat first login

---

## 2️⃣ TABEL TB_JENIS_KENDARAAN

### Fungsi
Master data untuk tipe-tipe kendaraan yang bisa parkir

### Struktur Kolom

| Kolom | Tipe | Constraint | Penjelasan |
|:------|:-----|:-----------|:-----------|
| **jenis_id** | INTEGER | PRIMARY KEY | ID unik tipe kendaraan (auto increment) |
| **nama_jenis** | VARCHAR(50) | NOT NULL, UNIQUE | Nama tipe (Motor, Mobil, Truk, dll) |
| **tarif_per_jam** | INTEGER | NOT NULL | Tarif parkir per jam dalam Rupiah |

### Contoh Data
```
jenis_id | nama_jenis | tarif_per_jam
---------|------------|---------------
1        | Motor      | 2000
2        | Mobil      | 5000
3        | Truk       | 10000
```

### Relasi ke Tabel Lain
- **TB_AREA_PARKIR** menggunakan jenis_id untuk menentukan tipe kendaraan apa yang bisa parkir
- **TB_KENDARAAN** menggunakan jenis_id untuk menentukan tipe kendaraan

### Catatan
- Setiap jenis memiliki tarif sendiri
- Tarif digunakan untuk menghitung biaya saat kendaraan keluar
- Rumus biaya: `(durasi parkir dalam jam) × (tarif_per_jam)`

---

## 3️⃣ TABEL TB_AREA_PARKIR

### Fungsi
Menyimpan lokasi/area parkir fisik di lapangan

### Struktur Kolom

| Kolom | Tipe | Constraint | Penjelasan |
|:------|:-----|:-----------|:-----------|
| **area_id** | INTEGER | PRIMARY KEY | ID unik area (auto increment) |
| **nama_area** | VARCHAR(50) | NOT NULL, UNIQUE | Nama area (Lantai 1 Motor, Lantai 2 Mobil, dll) |
| **jenis_id** | INTEGER | NOT NULL, FK | Referensi ke TB_JENIS_KENDARAAN |
| **kapasitas** | INTEGER | NOT NULL | Total slot parkir di area ini |
| **terisi** | INTEGER | NOT NULL, DEFAULT 0 | Jumlah slot yang terisi sekarang |

### Contoh Data
```
area_id | nama_area         | jenis_id | kapasitas | terisi
--------|-------------------|----------|-----------|--------
1       | Lantai 1 Motor    | 1        | 100       | 45
2       | Lantai 2 Mobil    | 2        | 50        | 30
3       | Basement Motor    | 1        | 80        | 62
4       | Basement Mobil    | 2        | 40        | 28
```

### Relasi Foreign Key
```
TB_AREA_PARKIR.jenis_id → TB_JENIS_KENDARAAN.jenis_id
```
Contoh: Area "Lantai 1 Motor" hanya untuk jenis_id=1 (Motor)

### Logika Kapasitas
- `Slot Kosong = kapasitas - terisi`
- `Persentase Penuh = (terisi / kapasitas) × 100%`
- `terisi` diupdate otomatis saat:
  - Kendaraan masuk → `terisi = terisi + 1`
  - Kendaraan keluar → `terisi = terisi - 1`

---

## 4️⃣ TABEL TB_KENDARAAN

### Fungsi
Master data kendaraan yang pernah parkir di sistem

### Struktur Kolom

| Kolom | Tipe | Constraint | Penjelasan |
|:------|:-----|:-----------|:-----------|
| **kendaraan_id** | INTEGER | PRIMARY KEY | ID unik kendaraan (auto increment) |
| **plat_nomor** | VARCHAR(15) | NOT NULL, UNIQUE | Nomor plat kendaraan (unik) |
| **jenis_id** | INTEGER | NOT NULL, FK | Referensi ke TB_JENIS_KENDARAAN |
| **merk** | VARCHAR(50) | NOT NULL | Merek kendaraan (Honda, Toyota, Yamaha, dll) |
| **warna** | VARCHAR(30) | NOT NULL | Warna untuk identifikasi visual |

### Contoh Data
```
kendaraan_id | plat_nomor  | jenis_id | merk    | warna
-------------|-------------|----------|---------|--------
1            | H 1234 ABC  | 1        | Honda   | Merah
2            | B 5678 CDE  | 2        | Toyota  | Hitam
3            | H 2020 XYZ  | 1        | Yamaha  | Putih
4            | B 9999 DEF  | 2        | Daihatsu| Biru
```

### Relasi Foreign Key
```
TB_KENDARAAN.jenis_id → TB_JENIS_KENDARAAN.jenis_id
```

### Catatan
- plat_nomor HARUS UNIK untuk identifikasi
- Data dibuat/diupdate saat kendaraan pertama kali parkir
- Satu kendaraan bisa parkir berkali-kali (multiple transactions)

---

## 5️⃣ TABEL TB_TRANSAKSI ⭐ (PALING PENTING)

### Fungsi
Mencatat SETIAP transaksi parkir (masuk dan keluar)

### Struktur Kolom

| Kolom | Tipe | Constraint | Penjelasan |
|:------|:-----|:-----------|:-----------|
| **transaksi_id** | INTEGER | PRIMARY KEY | ID unik transaksi (auto increment) |
| **kendaraan_id** | INTEGER | NOT NULL, FK | Referensi ke TB_KENDARAAN |
| **area_id** | INTEGER | NOT NULL, FK | Referensi ke TB_AREA_PARKIR (tempat parkir) |
| **waktu_masuk** | DATETIME | NOT NULL | Waktu kendaraan masuk |
| **waktu_keluar** | DATETIME | - | Waktu kendaraan keluar (NULL jika masih parkir) |
| **status** | TEXT | NOT NULL, DEFAULT 'parkir' | Status: 'parkir' atau 'keluar' |
| **total_biaya** | INTEGER | - | Total biaya (NULL jika masih parkir) |
| **user_id** | INTEGER | NOT NULL, FK | Referensi ke TB_USER (petugas) |

### Contoh Data
```
transaksi_id | kendaraan_id | area_id | waktu_masuk         | waktu_keluar        | status | total_biaya | user_id
-------------|--------------|---------|---------------------|---------------------|--------|------------|--------
1            | 1            | 1       | 2024-01-15 08:00:00 | 2024-01-15 10:30:00 | keluar | 5000       | 3
2            | 2            | 2       | 2024-01-15 09:15:00 | NULL                | parkir | NULL       | 3
3            | 3            | 1       | 2024-01-15 10:00:00 | 2024-01-15 14:20:00 | keluar | 8000       | 3
```

### Relasi Foreign Key
```
TB_TRANSAKSI.kendaraan_id → TB_KENDARAAN.kendaraan_id
TB_TRANSAKSI.area_id → TB_AREA_PARKIR.area_id
TB_TRANSAKSI.user_id → TB_USER.id_user
```

### Flow Transaksi Parkir Lengkap

#### Step 1: KENDARAAN MASUK (Input by Petugas)
```sql
INSERT INTO tb_transaksi (
  kendaraan_id,
  area_id,
  waktu_masuk,
  status,
  user_id
) VALUES (1, 1, '2024-01-15 08:00:00', 'parkir', 3);

-- Update area kapasitas
UPDATE tb_area_parkir SET terisi = terisi + 1 WHERE area_id = 1;
```

#### Step 2: KENDARAAN PARKIR (Masih di Lapangan)
```
Status: 'parkir'
waktu_keluar: NULL
total_biaya: NULL
```

#### Step 3: KENDARAAN KELUAR (Input by Petugas)
```sql
UPDATE tb_transaksi SET
  waktu_keluar = '2024-01-15 10:30:00',
  status = 'keluar',
  total_biaya = 5000  -- dihitung: durasi × tarif
WHERE transaksi_id = 1;

-- Update area kapasitas
UPDATE tb_area_parkir SET terisi = terisi - 1 WHERE area_id = 1;
```

### Perhitungan Biaya
```
Durasi Parkir = waktu_keluar - waktu_masuk
Total Biaya = ROUND(durasi_jam) × tarif_per_jam

Contoh:
- Masuk: 08:00, Keluar: 10:30 → Durasi 2.5 jam → Biaya 2.5 × Rp2000 = Rp5000
- Masuk: 14:00, Keluar: 14:30 → Durasi 0.5 jam → Biaya 1 × Rp5000 = Rp5000 (minimum 1 jam)
```

---

## 6️⃣ TABEL TB_LOG_AKTIVITAS

### Fungsi
Mencatat semua aktivitas user untuk audit trail dan monitoring keamanan

### Struktur Kolom

| Kolom | Tipe | Constraint | Penjelasan |
|:------|:-----|:-----------|:-----------|
| **log_id** | INTEGER | PRIMARY KEY | ID unik log (auto increment) |
| **user_id** | INTEGER | NOT NULL, FK | Referensi ke TB_USER (siapa) |
| **kategori_log** | TEXT | NOT NULL | Kategori aktivitas |
| **aktivitas** | VARCHAR(100) | NOT NULL | Deskripsi detail aktivitas |
| **waktu** | DATETIME | NOT NULL | Waktu aktivitas terjadi |

### Kategori Aktivitas
```
- Otorisasi: Login, Logout, Reset Password
- Input Data: Masuk, Keluar, Tambah User
- Ubah Data: Ubah Tarif, Ubah Status User
- Hapus Data: Hapus User, Hapus Transaksi
- Laporan: Cetak Laporan, Export Data
```

### Contoh Data
```
log_id | user_id | kategori_log | aktivitas              | waktu
-------|---------|--------------|------------------------|--------------------
1      | 1       | Otorisasi    | Login ke sistem        | 2024-01-15 08:00:00
2      | 3       | Input Data   | Kendaraan masuk H 1234 | 2024-01-15 08:05:00
3      | 3       | Input Data   | Kendaraan keluar H1234 | 2024-01-15 10:30:00
4      | 2       | Ubah Data    | Ubah tarif motor Rp3000| 2024-01-15 11:00:00
5      | 1       | Laporan      | Export laporan harian  | 2024-01-15 17:00:00
```

### Relasi Foreign Key
```
TB_LOG_AKTIVITAS.user_id → TB_USER.id_user
```

### Kegunaan Log
- **Audit Trail**: Tracking siapa yang melakukan apa dan kapan
- **Monitoring**: Melihat aktivitas user dalam periode tertentu
- **Keamanan**: Mendeteksi aktivitas mencurigakan
- **Laporan**: Data untuk analisis penggunaan sistem

---

## 🔗 DIAGRAM RELASI ANTAR TABEL

```
                    TB_USER (Pusat)
                        |
                   [id_user] PK
                        |
              +---------+---------+---------+
              |         |         |         |
              ↓         ↓         ↓         ↓
         LOG_ACT   TRANSAKSI  (1:Many)   (lainnya)
         [user_id]  [user_id]


    TB_JENIS_KENDARAAN (Master)
            |
       [jenis_id] PK
            |
            ├───→ TB_AREA_PARKIR
            |     [jenis_id] FK
            |     Menentukan tipe apa di area ini
            |
            └───→ TB_KENDARAAN
                  [jenis_id] FK
                  Menentukan tipe kendaraan


    TB_TRANSAKSI (Core Business)
            |
            ├─→ TB_KENDARAAN [kendaraan_id] FK
            |   Mobil apa yang parkir?
            |
            ├─→ TB_AREA_PARKIR [area_id] FK
            |   Di mana dia parkir?
            |
            └─→ TB_USER [user_id] FK
                Siapa yang mencatat?
```

---

## 📊 QUERY CONTOH UNTUK PEMBELAJARAN

### 1. Query Autentikasi (Login)
```sql
-- Cari user saat login
SELECT * 
FROM tb_user 
WHERE username = 'owner' 
  AND status = 'aktif';
```

### 2. Query Dashboard - Pendapatan Hari Ini
```sql
-- Hitung total pendapatan hari ini
SELECT 
  SUM(total_biaya) as total_pendapatan,
  COUNT(*) as jumlah_transaksi
FROM tb_transaksi 
WHERE DATE(waktu_keluar) = DATE('now') 
  AND status = 'keluar';
```

### 3. Query Dashboard - Kendaraan Masih Parkir
```sql
-- Lihat kendaraan yang masih parkir sekarang
SELECT 
  t.transaksi_id,
  k.plat_nomor,
  jk.nama_jenis,
  ap.nama_area,
  t.waktu_masuk,
  CAST((julianday('now') - julianday(t.waktu_masuk)) * 24 AS INTEGER) as lama_jam
FROM tb_transaksi t
JOIN tb_kendaraan k ON t.kendaraan_id = k.kendaraan_id
JOIN tb_jenis_kendaraan jk ON k.jenis_id = jk.jenis_id
JOIN tb_area_parkir ap ON t.area_id = ap.area_id
WHERE t.status = 'parkir'
ORDER BY t.waktu_masuk ASC;
```

### 4. Query Dashboard - Kapasitas Area
```sql
-- Hitung kapasitas area parkir sekarang
SELECT 
  nama_area,
  kapasitas,
  terisi,
  (kapasitas - terisi) as kosong,
  ROUND(CAST(terisi AS FLOAT) / kapasitas * 100, 2) as persentase_terisi
FROM tb_area_parkir
ORDER BY persentase_terisi DESC;
```

### 5. Query Laporan - Transaksi Per Hari
```sql
-- Laporan harian: jumlah transaksi dan pendapatan
SELECT 
  DATE(waktu_masuk) as tanggal,
  COUNT(*) as jumlah_transaksi,
  SUM(total_biaya) as total_pendapatan,
  ROUND(AVG(total_biaya), 2) as rata_rata_biaya
FROM tb_transaksi
WHERE status = 'keluar'
GROUP BY DATE(waktu_masuk)
ORDER BY tanggal DESC;
```

### 6. Query Audit - Aktivitas User
```sql
-- Lihat aktivitas user dalam 24 jam terakhir
SELECT 
  u.nama_lengkap,
  l.kategori_log,
  l.aktivitas,
  l.waktu
FROM tb_log_aktivitas l
JOIN tb_user u ON l.user_id = u.id_user
WHERE l.waktu >= datetime('now', '-24 hours')
ORDER BY l.waktu DESC;
```

### 7. Query Manajemen - List User
```sql
-- List semua user dengan informasi lengkap
SELECT 
  id_user,
  nama_lengkap,
  username,
  role,
  status,
  is_default_password
FROM tb_user
ORDER BY role, nama_lengkap;
```

---

## 🔒 Catatan Keamanan & Best Practice

### Password Hashing
- **JANGAN PERNAH** menyimpan password plain text
- **SELALU** gunakan bcrypt untuk hash password
- Hash bcrypt terdiri dari 60 karakter

```dart
// Contoh hashing di Dart/Flutter
import 'package:bcrypt/bcrypt.dart';

String password = 'owner123';
String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
// Hasil: $2a$12$abcdefghijklmnopqrstuvwxyz123...
```

### Constraint dan Validasi
- **UNIQUE**: plat_nomor, username, nama_jenis, nama_area
- **NOT NULL**: Semua field yang penting
- **FOREIGN KEY**: Menjaga integritas relasi antar tabel
- **DEFAULT**: Nilai otomatis saat insert tanpa value

### Audit Trail
- Setiap aktivitas penting harus di-log ke TB_LOG_AKTIVITAS
- Berguna untuk tracking dan keamanan
- Contoh: Login, Ubah Password, Ubah Tarif, Laporan

---

## 📌 Checklist untuk Pembelajaran Siswa

- [ ] Pahami fungsi setiap tabel
- [ ] Pahami relasi antar tabel (Foreign Key)
- [ ] Pahami flow transaksi parkir dari masuk sampai keluar
- [ ] Pahami perhitungan biaya parkir
- [ ] Bisa membuat query SELECT dengan JOIN
- [ ] Bisa membuat query INSERT untuk input data
- [ ] Bisa membuat query UPDATE untuk ubah data
- [ ] Pahami fungsi aggregate (SUM, COUNT, AVG)
- [ ] Pahami GROUP BY dan DATE function
- [ ] Pahami pentingnya password hashing dan audit trail

---

## 📚 Referensi File

- **schema.sql**: File SQL lengkap dengan struktur dan contoh data
- **database_helper.dart**: Implementasi database di Flutter (CRUD operations)
- **app_preferences.dart**: Session management untuk login user
- **password_service.dart**: Bcrypt hashing dan validasi password

---

**Dibuat untuk pembelajaran SMK | Modul: Sistem Manajemen Parkir | Level: Advanced**
