# Debug: Database Path Detection

Ketika app berjalan, check console output untuk melihat pesan DEBUG.

Pesan-pesan penting yang akan ditampilkan:

1. **Database Initialization Started**
   ```
   DEBUG: Starting database initialization...
   ```

2. **Path Detection Attempt 1 (getDatabasesPath)**
   ```
   DEBUG: Trying getDatabasesPath()...
   DEBUG: Got system path: /path/to/databases
   DEBUG: Using standard database path: /path/to/parking_app.db
   ```
   
   ATAU jika gagal:
   ```
   DEBUG: getDatabasesPath failed: [error message]
   ```

3. **Fallback to getApplicationDocumentsDirectory**
   ```
   DEBUG: Falling back to getApplicationDocumentsDirectory()...
   DEBUG: Got app doc dir: /home/user/Documents  (or C:\Users\...)
   DEBUG: Using fallback database path: /home/user/Documents/parking_app_db/parking_app.db
   ```

4. **Directory Creation**
   ```
   DEBUG: Creating directory: /path/to/directory
   DEBUG: Created database directory at: /path/to/directory
   ```

5. **Database Opening**
   ```
   DEBUG: Opening database at: /full/path/to/parking_app.db
   DEBUG: _createTables called - creating tables for database...
   ```

6. **Verification**
   ```
   DEBUG SPLASH: Database initialized
   DEBUG SPLASH: Database path: /full/path/to/parking_app.db
   DEBUG SPLASH: Found X users in database
   ```

---

## Expected Database Paths by Platform

### Linux (Desktop)
```
~/.local/share/[app]/parking_app_db/parking_app.db
```
OR
```
~/.local/share/gvfs-metadata
```

### Windows
```
C:\Users\[YourName]\AppData\Roaming\[app]\parking_app_db\parking_app.db
```

### macOS
```
~/Library/Application Support/[app]/parking_app_db/parking_app.db
```

### Android
```
/data/data/com.example.module_parking_app/databases/parking_app/parking_app.db
```

### iOS
```
/var/mobile/Containers/Data/Application/[APP_ID]/Documents/databases/parking_app/parking_app.db
```

---

## How to Find Your Database File

### Step 1: Run the app
Run Flutter app dan wait untuk splash screen selesai.

### Step 2: Check Console Output
Lihat console output (Run panel di VS Code atau terminal) dan cari baris yang dimulai dengan:
```
DEBUG: Full Database File: /actual/path/to/parking_app.db
```

COPY path tersebut.

### Step 3: Navigate to File
Buka file manager dan paste path ke location bar.

### Step 4: Verify File Exists
Database file `parking_app.db` harus ada di directory tersebut dengan size > 10KB.

---

## Troubleshooting

### Database File Not Found

1. **Check Console Output**
   - Lihat apakah ada error message
   - Copy exact path dari DEBUG message

2. **Check Permissions**
   - Pastikan folder memiliki read/write permissions
   - Linux: `chmod 755 /path/to/folder`

3. **Check Directory Creation**
   - If "Creating directory" message tidak muncul, directory mungkin sudah exist
   - Manually create directory: `mkdir -p /path/to/parking_app_db`

4. **Clean and Rebuild**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## Locating Database After Creation

### Option 1: Direct Path (Recommended)
Copy path dari console `DEBUG: Full Database File:` langsung ke file manager.

### Option 2: Search by Name
```bash
# Linux/Mac
find ~/ -name "parking_app.db" -type f

# Windows (PowerShell)
Get-ChildItem -Path C:\ -Name parking_app.db -Recurse
```

### Option 3: Check Last Modified Files
```bash
# Linux/Mac - Find files modified in last 5 minutes
find ~/ -name "*.db" -mmin -5

# Windows - List recent .db files
Get-ChildItem -Path $env:APPDATA -Filter *.db -Recurse | Sort-Object LastWriteTime -Descending
```

---

## Opening Database with GUI Tools

Once you locate the file:

### VS Code SQLite Extension
1. Cmd/Ctrl+Shift+P → "SQLite: Open Database"
2. Paste file path from console
3. Browse tables and data

### DB Browser for SQLite
1. Download from https://sqlitebrowser.org/
2. Open application → "Open Database"
3. Navigate to file location and open
4. Use "Browse Data" tab

---

## Notes

- App akan create database automatically pada first run
- Folder akan auto-create jika belum ada
- File size harus > 10KB setelah initialization
- Check console BEFORE trying to locate file - semua info ada di sana!

