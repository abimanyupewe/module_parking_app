# 🚀 QUICK START - DATABASE FIXES

**Estimasi waktu baca**: 5 menit  
**Target**: User/Developer yang ingin langsung testing

---

## ✅ APA YANG SUDAH DIPERBAIKI?

### 1️⃣ Database Factory Error (CRITICAL)
❌ **Sebelum**: "databaseFactory not initialized" error  
✅ **Sesudah**: Database initialization berhasil di semua platform

### 2️⃣ Database File Tersembunyi
❌ **Sebelum**: Sulit menemukan file `.db`  
✅ **Sesudah**: Path ditampilkan di console + symlink otomatis

### 3️⃣ Akses Database dengan Tools
❌ **Sebelum**: Perlu cari folder manual  
✅ **Sesudah**: Copy path dari console, langsung buka di VS Code/DB Browser

---

## 🎯 LANGSUNG TESTING

### Step 1: Run Aplikasi
```bash
cd /home/clara/Project/FLutter/basic_flutter/module_parking_app
flutter run
```

### Step 2: Lihat Console Output
Cari pesan ini di console:
```
================== DATABASE LOCATION ==================
📁 Database Path: /home/clara/...
```

### Step 3: Copy Path
Copy seluruh path dari console (contoh: `/home/clara/.parking_app/parking_app.db`)

### Step 4: Login
```
Username: owner
Password: 123456
```

### Step 5: Buka Database dengan Tools
**Pilih salah satu:**

#### Option A: VS Code SQLite Extension
1. Install "SQLite" extension di VS Code
2. Ctrl+Shift+P → "SQLite: Open Database"
3. Paste path dari console
4. Lihat tables dan data

#### Option B: DB Browser for SQLite
1. Download dari https://sqlitebrowser.org/
2. File → Open Database
3. Paste path dari console
4. Browse tables dan data

---

## 📋 CHECKLIST TESTING

Jalankan checklist ini setelah aplikasi berjalan:

- [ ] Console menampilkan "DATABASE LOCATION" section
- [ ] Path database terlihat di console
- [ ] Login berhasil dengan owner/123456
- [ ] Database file ada di lokasi yang ditunjukkan
- [ ] Bisa buka database dengan VS Code atau DB Browser
- [ ] Lihat tabel `user` dan data default

---

## 📂 LOKASI DATABASE

Bergantung platform:

| Platform | Path |
|----------|------|
| **Linux** | `~/.parking_app/parking_app.db` (juga di `~/.local/share/...`) |
| **Windows** | `C:\Users\[User]\AppData\Roaming\module_parking_app\databases\...` |
| **macOS** | `~/Library/Application Support/module_parking_app/...` |
| **Android** | `/data/data/com.example.module_parking_app/databases/` |
| **iOS** | `/var/mobile/Containers/...` |

**Symlink/Shortcut**:
- Linux/macOS: `~/.parking_app_db` → real path
- Windows: `parking_app.lnk.txt` di home (isi: path)

---

## 🔍 DEBUGGING TIPS

### Jika Path Tidak Muncul
1. Check console output - cari error message
2. Lihat file git log untuk latest commits
3. Run `flutter clean && flutter pub get`
4. Run lagi: `flutter run`

### Jika Database File Tidak Ketemu
1. Buka terminal/command prompt
2. Cari file database:
   - **Linux**: `find ~/ -name "parking_app.db" 2>/dev/null`
   - **macOS**: `find ~/ -name "parking_app.db" 2>/dev/null`
   - **Windows**: `dir /s %APPDATA%\module_parking_app`

### Jika VS Code Extension Tidak Bisa Buka
1. Pastikan extension sudah install dan aktif
2. Coba dengan DB Browser for SQLite (more reliable)
3. Atau copy database ke Desktop dulu, buka dari sini

### Jika Login Gagal
1. Check console - lihat error message
2. Verify database path ada
3. Verify file size > 10KB (database sudah punya tabel)
4. Coba buka database dengan DB Browser - lihat apakah ada data

---

## 💡 TIPS DEVELOPER

### Akses Database Path dari Code

```dart
// Dalam aplikasi:
final dbHelper = DatabaseHelper();

// Dapatkan path
final path = await dbHelper.getDatabasePath();
print('Database: $path');

// Atau cetak langsung
dbHelper.printDatabaseLocation();

// Copy ke lokasi lain (backup)
await dbHelper.copyDatabaseToAccessibleLocation(
  '/home/user/Desktop/backup.db'
);
```

### File Penting untuk Diketahui
- `lib/main.dart` - Database factory initialization
- `lib/services/database_helper.dart` - Database operations + visibility features
- `lib/features/splash/pages/splash_page.dart` - Startup initialization

---

## 📚 DOKUMENTASI LENGKAP

Untuk informasi lebih detail, baca:

1. **DATABASE_FIXES_SUMMARY_ID.md** ← Ringkasan semua fixes
2. **DATABASE_VISIBILITY_SOLUTION_ID.md** ← Solusi visibility detail
3. **SQLITE_GUI_ACCESS.md** ← Setup tools (VS Code, DB Browser)
4. **TESTING_GUIDE.md** ← Testing procedures lengkap

---

## 🎉 SELESAI!

Setelah selesai testing:

1. Database sudah working ✅
2. Bisa akses dari tools GUI ✅
3. Path mudah ditemukan ✅
4. Siap untuk testing fitur lainnya ✅

**Next Step**: Test role-based features (Owner, Admin, Petugas dashboards)

---

## ❓ QUICK FAQ

**Q: Database file tersimpan di mana?**  
A: Lihat console output - akan dicetak saat startup

**Q: Kenapa database hidden di folder tersembunyi?**  
A: Ini standard Flutter practice - untuk security dan organization

**Q: Bisa ubah lokasi database?**  
A: Bisa, via `copyDatabaseToAccessibleLocation()` atau copy manual ke lokasi lain

**Q: Apa itu symlink yang dibuat otomatis?**  
A: Shortcut ke database file di home directory, agar akses lebih mudah

**Q: Apakah symlink wajib?**  
A: Tidak - kalau gagal, user masih bisa copy path dari console

**Q: Apakah perlu install tools tambahan?**  
A: Opsional - bisa lihat data dari console atau buka dengan GUI tools

---

**Status**: ✅ Ready to Test  
**Last Updated**: 13 April 2026  
**Version**: 1.0
