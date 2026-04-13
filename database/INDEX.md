# 📚 Database Documentation Index

## Lokasi File Dokumentasi Database

```
📁 database/
├── 📄 schema.sql           (15 KB) - SQL dump lengkap dengan comments
├── 📄 README.md            (16 KB) - Penjelasan lengkap setiap tabel
├── 📄 ER_DIAGRAM.txt       (19 KB) - Diagram relasi dan contoh query
└── 📄 INDEX.md             (ini)    - Panduan navigasi
```

---

## 🗂️ Quick Navigation

### Untuk Pemula (Baru belajar Database)
1. **Mulai dari**: `README.md` - bagian "Daftar Tabel dan Fungsinya"
2. **Lanjut ke**: `ER_DIAGRAM.txt` - bagian "DATA FLOW" untuk memahami alur
3. **Praktik**: `schema.sql` - lihat contoh CREATE TABLE dengan comments

### Untuk Intermediate (Sudah paham basic SQL)
1. **Fokus**: `README.md` - bagian "Query Contoh untuk Pembelajaran"
2. **Deep dive**: `ER_DIAGRAM.txt` - bagian "RELASI DETAIL" dan "USE CASE"
3. **Praktik**: Jalankan query di `ER_DIAGRAM.txt` section 7

### Untuk Advanced (Siap optimasi database)
1. **Review**: `README.md` - bagian "Catatan Keamanan & Best Practice"
2. **Analisis**: `ER_DIAGRAM.txt` - bagian "NORMALISASI DATABASE"
3. **Implementasi**: Integrasikan dengan kode Dart di `lib/services/database_helper.dart`

---

## 📖 Deskripsi File

### 1. **schema.sql** (15 KB)
**Gunakan untuk:**
- Import langsung ke database tools (DB Browser for SQLite, DBeaver, phpMyAdmin)
- Dokumentasi teknis SQL yang formal
- Backup dan restore database
- Referensi struktur CREATE TABLE yang tepat

**Isi:**
- Header penjelasan database
- 6 CREATE TABLE statements dengan inline comments
- Default data untuk testing (Motor, Mobil, Owner user)
- 7 contoh query untuk berbagai use case

**Tools yang cocok:**
```bash
# Import ke SQLite
sqlite3 parking_app.db < schema.sql

# View di command line
cat schema.sql | less
```

---

### 2. **README.md** (16 KB)
**Gunakan untuk:**
- Pembelajaran dan pemahaman konsep
- Dokumentasi untuk siswa SMK
- Reference untuk developer
- Training material

**Isi:**
- Penjelasan fungsi setiap tabel
- Struktur kolom dengan tipe data & constraint
- Contoh data lengkap untuk setiap tabel
- Relasi Foreign Key
- Flow transaksi parkir step-by-step
- 7 contoh query untuk berbagai skenario
- Best practice & catatan keamanan
- Checklist pembelajaran

**Panduan Membaca:**
- Mulai dari index untuk overview
- Baca satu tabel per sesi (jangan sekaligus)
- Pahami relasi antar tabel sebelum query
- Praktik dengan contoh data yang diberikan

---

### 3. **ER_DIAGRAM.txt** (19 KB)
**Gunakan untuk:**
- Memahami relasi antar tabel secara visual
- Analisis data flow dan normalisasi
- Contoh query untuk berbagai use case
- Dokumentasi architecture database

**Isi:**
- Diagram relasi lengkap (ASCII art)
- Tabel & relationship summary
- Relasi detail dengan cardinality (1:Many)
- Penjelasan normalisasi (1NF, 2NF, 3NF)
- Data flow lengkap transaksi parkir
- Contoh data lengkap (scenario real)
- 4 query untuk berbagai use case
- Penjelasan setiap query dan hasilnya

**Panduan Membaca:**
- Bagian 1: Lihat diagram relasi lengkap
- Bagian 2-4: Pahami relasi detail
- Bagian 5: Pelajari data flow & normalisasi
- Bagian 6: Contoh data konkret
- Bagian 7: Praktik query dengan scenario

---

## 🔍 How to Use Sesuai Kebutuhan

### ❓ "Saya ingin tahu struktur tabel..."
→ Buka **README.md**, cari section "TABEL..." yang relevan

### ❓ "Bagaimana relasi antar tabel?"
→ Buka **ER_DIAGRAM.txt**, section "TABEL DAN RELATIONSHIP SUMMARY"

### ❓ "Berapa jumlah transaksi hari ini?"
→ Buka **ER_DIAGRAM.txt**, section "USE CASE 1"

### ❓ "Saya ingin import database ke tool..."
→ Gunakan **schema.sql** dengan command line atau IDE

### ❓ "Saya bingung dengan flow parkir..."
→ Buka **ER_DIAGRAM.txt**, section "DATA FLOW"

### ❓ "Saya mau praktik INSERT/UPDATE..."
→ Buka **schema.sql**, lihat contoh INSERT statements

### ❓ "Bagaimana query dengan JOIN?"
→ Buka **README.md**, section "Query Contoh", lihat Query 3 & 5

---

## 📊 File Size & Kompleksitas

| File | Ukuran | Garis | Level | Est. Time |
|:-----|:------:|:----:|:-----:|:---------:|
| schema.sql | 15 KB | ~500 | ⭐⭐ | 20 min |
| README.md | 16 KB | ~600 | ⭐⭐⭐ | 45 min |
| ER_DIAGRAM.txt | 19 KB | ~650 | ⭐⭐⭐⭐ | 60 min |
| **TOTAL** | **50 KB** | **~1750** | - | **125 min** |

*Est. Time = Waktu untuk membaca + memahami semuanya*

---

## 🎯 Learning Path Recommended

### **Week 1: Fundamental**
- [ ] Baca README.md sections 1-3 (Intro, Daftar Tabel, TB_USER)
- [ ] Baca ER_DIAGRAM.txt section 1-2
- [ ] Pahami primary key dan unique constraint
- **Goal**: Mengerti tabel user dan cara authentikasi

### **Week 2: Master Data**
- [ ] Baca README.md sections 4-6 (Jenis Kendaraan, Area Parkir, Kendaraan)
- [ ] Baca ER_DIAGRAM.txt section 3-4 (Relasi Detail)
- [ ] Praktik buat query SELECT JOIN untuk master data
- **Goal**: Mengerti relasi 1:Many antar master table

### **Week 3: Transaction & Flow**
- [ ] Baca README.md section 5 (TB_TRANSAKSI - Core)
- [ ] Baca ER_DIAGRAM.txt section 5 (DATA FLOW)
- [ ] Pahami flow lengkap masuk-keluar & perhitungan biaya
- **Goal**: Mengerti business logic transaksi parkir

### **Week 4: Query & Reporting**
- [ ] Baca README.md section 7 (Query Contoh)
- [ ] Baca ER_DIAGRAM.txt section 7 (USE CASE)
- [ ] Praktik setiap query dengan real data
- **Goal**: Bisa buat query aggregate, GROUP BY, JOIN

### **Week 5: Security & Advanced**
- [ ] Baca README.md section 8 (Keamanan)
- [ ] Baca ER_DIAGRAM.txt section 6 (Normalisasi)
- [ ] TB_LOG_AKTIVITAS dan pentingnya audit trail
- **Goal**: Best practice & optimization

---

## 💡 Tips Pembelajaran

### 1. **Baca Perlahan, Tidak Perlu Cepat**
- Satu tabel per session
- Istirahat setiap 30 menit
- Catat poin penting

### 2. **Praktik Langsung**
- Buka DB Browser for SQLite
- Jalankan query dari dokumentasi
- Lihat hasilnya, modifikasi query

### 3. **Buat Mind Map**
- Hubungkan relasi antar tabel
- Catat constraint dan validasi
- Gambar ERD di kertas/whiteboard

### 4. **Bikin Contoh Data Sendiri**
- Buat scenario parkir Anda sendiri
- Insert data ke database
- Jalankan query dengan data Anda

### 5. **Diskusi dengan Teman**
- Jelaskan tabel kepada teman
- Tanya pertanyaan spesifik
- Review bersama query

---

## 🔗 Hubungan dengan Kode Flutter

Dokumentasi database ini terintegrasi dengan:

```
lib/services/database_helper.dart
  ↓ (mengimplementasikan)
schema.sql (struktur tabel)

lib/features/auth/controllers/auth_controller.dart
  ↓ (query)
TB_USER (login)

lib/features/*/pages/*_dashboard_page.dart
  ↓ (query)
TB_TRANSAKSI (tampil data)
```

**Jadi pembelajaran database ini LANGSUNG applicable ke kode Flutter!**

---

## 📝 Checklist Sebelum Implementasi

Sebelum coding fitur apapun, pastikan Anda sudah:
- [ ] Pahami tabel yang akan digunakan
- [ ] Pahami relasi Foreign Key-nya
- [ ] Pahami constraint dan validasi
- [ ] Bikin query SELECT yang tepat
- [ ] Pahami flow data (insert → update → select)
- [ ] Tahu bagian mana yang perlu di-log

---

## 🆘 Troubleshooting

### "Saya bingung TABEL MANA yang digunakan untuk FITUR X?"
1. Baca deskripsi fitur di README.md
2. Lihat relasi di ER_DIAGRAM.txt
3. Trace dari primary table yang relevan

### "Query saya tidak return hasil yang diharapkan"
1. Check struktur tabel di README.md
2. Check relasi Foreign Key di ER_DIAGRAM.txt
3. Pastikan WHERE clause sesuai
4. Test dengan contoh data dari dokumentasi

### "Saya mau tambah field baru ke tabel"
1. Review struktur tabel di schema.sql
2. Check constraint yang sudah ada
3. Update schema.sql
4. Update database_helper.dart di Flutter
5. Migration jika database sudah ada

---

## 📞 Referensi Cepat

**Database Name**: `parking_app.db`

**Database Constants** (di `lib/config/constants.dart`):
```dart
tableUser = 'tb_user'
tableJenisKendaraan = 'tb_jenis_kendaraan'
tableAreaParkir = 'tb_area_parkir'
tableKendaraan = 'tb_kendaraan'
tableTransaksi = 'tb_transaksi'
tableLogAktivitas = 'tb_log_aktivitas'
```

**Default User untuk Testing**:
```
Username: owner
Password: owner123
Role: Owner
Status: aktif
```

**Default Master Data**:
- Jenis Kendaraan: Motor (Rp2000/jam), Mobil (Rp5000/jam)

---

## 📄 Lisensi & Disclaimer

- Dokumentasi ini dibuat untuk pembelajaran SMK
- Boleh digunakan, dimodifikasi, dibagikan
- Dibuat oleh: OpenCode | Date: 13 April 2024
- Database design mengikuti 3NF normalization

---

**Selamat belajar! Jika ada pertanyaan, review dokumentasi dengan teliti.** 🚀
