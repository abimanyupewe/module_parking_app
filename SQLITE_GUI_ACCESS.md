# SQLite Database GUI Access Guide

Panduan lengkap untuk mengakses dan melihat data SQLite database dengan GUI tools.

## 📍 Database File Location

Database file `parking_app.db` tersimpan di lokasi berbeda tergantung platform:

### **Android**
```
/data/data/com.example.module_parking_app/databases/parking_app/parking_app.db
```
- Accessible via Android Studio Device File Explorer
- Atau pull file menggunakan adb

### **iOS**
```
/var/mobile/Containers/Data/Application/[APP_ID]/Documents/databases/parking_app/parking_app.db
```
- Accessible via Xcode Devices & Simulators

### **Linux (Desktop)**
```
~/.local/share/module_parking_app/databases/parking_app/parking_app.db
```
- Or check actual path dari console debug output:
  ```
  DEBUG: Using standard database path: /path/to/parking_app.db
  ```

### **Windows**
```
C:\Users\[YourUsername]\AppData\Roaming\module_parking_app\databases\parking_app\parking_app.db
```

### **macOS**
```
~/Library/Application Support/module_parking_app/databases/parking_app/parking_app.db
```

---

## 🛠️ Option 1: VS Code SQLite Extension (Recommended)

### **Installation**
1. Open VS Code
2. Go to Extensions (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for **"SQLite"** by alexcvzz
4. Click **Install**

### **Usage**
1. Open the project folder in VS Code
2. Press `Ctrl+Shift+P` (atau `Cmd+Shift+P` on Mac)
3. Type: **"SQLite: Open Database"**
4. Select the `parking_app.db` file dari project folder or known location
5. Click the database in the **SQLite Explorer** sidebar
6. Browse tables, view data, run queries

### **Example Queries**
```sql
-- View all users
SELECT * FROM tb_user;

-- View users by role
SELECT * FROM tb_user WHERE role = 'owner';

-- View vehicle types
SELECT * FROM tb_jenis_kendaraan;

-- Count users
SELECT COUNT(*) as total_users FROM tb_user;

-- View parking areas
SELECT * FROM tb_area_parkir;

-- View transactions
SELECT * FROM tb_transaksi;
```

### **Tips**
- Right-click table → "Show Table" untuk quickview
- Press `Ctrl+Enter` untuk run SQL query
- Extensions sidebar shows all tables & columns

---

## 🗄️ Option 2: DB Browser for SQLite (Standalone)

### **Installation**
1. Download dari: **https://sqlitebrowser.org/dl/**
2. Pilih version sesuai OS (Windows, Mac, Linux)
3. Install aplikasi

### **Usage**
1. Open DB Browser for SQLite
2. Click **"Open Database"** button
3. Navigate ke database file location (lihat paths di atas)
4. Database schema akan ditampilkan di sidebar
5. Click table → view data di tab **"Browse Data"**
6. Use **"Execute SQL"** tab untuk run custom queries

### **Keuntungan**
- ✅ Standalone aplikasi, tidak perlu VS Code
- ✅ User-friendly interface
- ✅ Export data ke CSV/JSON
- ✅ Create backups

### **Shortcomings**
- Sedikit lebih lambat untuk large datasets
- Interface lebih basic dibanding VS Code

---

## 📱 Option 3: Android Studio (For Android Builds)

### **View Database from Android Emulator/Device**

1. **Open Android Studio**
2. Go to **View → Tool Windows → Device File Explorer**
3. Navigate to:
   ```
   data/data/com.example.module_parking_app/databases/parking_app/
   ```
4. Right-click `parking_app.db` → **Save As**
5. Save ke local folder
6. Open dengan DB Browser atau VS Code SQLite extension

---

## 🔍 Debug Database Path at Runtime

### **Method 1: Check Console Output**
When app runs, kita print database path:
```
DEBUG: Using standard database path: /home/user/.local/share/module_parking_app/databases/parking_app/parking_app.db
```
Copy path ini dan buka di SQL tool.

### **Method 2: Add Debug Widget**
Tambah di `SplashPage` atau `LoginPage`:
```dart
print('Database path: ${await database.path}');
```

---

## ✅ Common Tasks

### **Check if Database Exists**
```bash
# Linux/Mac
ls -la ~/.local/share/module_parking_app/databases/parking_app/

# Windows PowerShell
Get-Item "C:\Users\[YourUsername]\AppData\Roaming\module_parking_app\databases\parking_app\"
```

### **Backup Database**
```bash
# Linux/Mac
cp ~/.local/share/module_parking_app/databases/parking_app/parking_app.db ~/backup_parking_app.db

# Windows
copy "C:\Users\...\parking_app.db" "C:\backup_parking_app.db"
```

### **Reset Database** (Delete & Recreate)
```bash
# Linux/Mac
rm ~/.local/share/module_parking_app/databases/parking_app/parking_app.db

# Windows (PowerShell as Admin)
Remove-Item "C:\Users\...\parking_app.db"
```

Then restart app → database akan auto-recreate dengan default tables.

---

## 🚀 Quick Start: VS Code + SQLite Extension

1. **Install extension**: alexcvzz SQLite
2. **Run app** (app akan create database file)
3. **Check console output** untuk database path
4. **Open VS Code Command Palette** (`Ctrl+Shift+P`)
5. **Type**: "SQLite: Open Database"
6. **Select**: `parking_app.db`
7. **Explore**: Tables & data di sidebar
8. **Query**: Run SQL di editor

---

## 📊 Database Schema

### **Tables**
- `tb_user` - User accounts (owner, admin, petugas)
- `tb_jenis_kendaraan` - Vehicle types (Motor, Mobil)
- `tb_area_parkir` - Parking areas
- `tb_kendaraan` - Vehicles (plat nomor, merk, warna)
- `tb_transaksi` - Parking transactions
- `tb_log_aktivitas` - Activity logs

### **Default Data**
Setelah first app run, tabel akan berisi:
- **Vehicle Types**: Motor (Rp2000/jam), Mobil (Rp5000/jam)
- **Users**: Dibuat melalui registration endpoint (tidak hardcoded)

### **User Roles**
```
'owner'    - Parking owner
'admin'    - System admin
'petugas'  - Parking attendant
```

---

## 🐛 Troubleshooting

### **Database File Not Found**
- Check console output untuk exact path
- Pastikan app sudah run minimal 1x (first run creates database)
- Check folder permissions

### **"Cannot Open Database" Error**
- Close file di aplikasi lain (locked file)
- Verify file extension is `.db`
- Try copy file ke folder lain & open copy

### **Data Not Showing**
- Make sure app initialized completely (lihat SplashPage flow)
- Run query: `SELECT COUNT(*) FROM tb_user;`
- If 0, create user via registration endpoint di app

### **SQLite Extension Not Working**
- Reinstall extension
- Reload VS Code (`Ctrl+Shift+P` → "Developer: Reload Window")
- Try DB Browser instead

---

## 📚 Useful Resources

- **SQLite Docs**: https://www.sqlite.org/docs.html
- **SQL Tutorial**: https://www.w3schools.com/sql/
- **VS Code SQLite**: https://github.com/alexcvzz/vscode-sqlite
- **DB Browser**: https://sqlitebrowser.org/

---

## 📝 Notes

- Database file adalah `.db` (SQLite format)
- Pastikan app tidak running saat edit database
- Always backup sebelum delete/modify
- Offline-capable: database persists lokal

---

**Last Updated**: 2026-04-13  
**Status**: Ready to use
