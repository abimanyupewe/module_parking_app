# DATABASE INITIALIZATION FLOW DIAGRAM

## 1. APP STARTUP FLOW

```
┌─────────────────────────────────────────────────────────────┐
│                      main() FUNCTION                         │
│                   (lib/main.dart lines 17-33)               │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
         ┌──────────────────────────────────────┐
         │ WidgetsFlutterBinding                │
         │ .ensureInitialized()                 │
         └──────────────────────────────────────┘
                            │
                            ▼
         ┌──────────────────────────────────────┐
         │ sqfliteFfiInit()                     │
         │ Initialize FFI for desktop           │
         └──────────────────────────────────────┘
                            │
                            ▼
         ┌─────────────────────────────────────────┐
         │ Platform Detection Check               │
         └─────────────────────────────────────────┘
           │                                      │
      ✅ DESKTOP                           ✅ MOBILE
      (Win/Linux/Mac)                   (Android/iOS)
           │                                      │
           ▼                                      ▼
    ┌──────────────────┐              (No action needed)
    │ Set global       │              (Default sqflite
    │ databaseFactory= │               handles it)
    │ databaseFactoryFfi│
    └──────────────────┘
           │
           ▼
    ┌──────────────────────────────────────┐
    │ AppPreferences.init()                │
    │ Load SharedPreferences               │
    └──────────────────────────────────────┘
           │
           ▼
    ┌──────────────────────────────────────┐
    │ runApp(const MyApp())                │
    │ Start Flutter app                    │
    └──────────────────────────────────────┘
           │
           ▼
    ┌──────────────────────────────────────┐
    │ SplashPage initState()               │
    │ _initializeApp()                     │
    └──────────────────────────────────────┘
           │
           ▼ (CRITICAL: databaseFactory already set!)
    ┌──────────────────────────────────────┐
    │ DatabaseHelper.get database          │
    │ _initDatabase() CALLED               │
    └──────────────────────────────────────┘
```

## 2. DATABASE INITIALIZATION PATH RESOLUTION

```
DatabaseHelper._initDatabase()
│
├─ Attempt 1: getDatabasesPath()
│  │
│  ├─ Success ✅ → Use this path
│  │
│  └─ Fail ❌ → Continue to Fallback 1
│
├─ Fallback 1: getApplicationDocumentsDirectory()
│  │
│  ├─ Success ✅ → Use fallback path
│  │
│  └─ Fail ❌ → Continue to Fallback 2
│
├─ Fallback 2: Platform.environment['HOME']/['USERPROFILE']
│  │
│  ├─ Success ✅ → Create ~/.parking_app/parking_app.db
│  │
│  └─ Fail ❌ → Throw detailed error
│
└─ (All 3 fallbacks tried, show all error messages)
```

## 3. PLATFORM-SPECIFIC PATHS

```
┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE PATH SELECTION                      │
└─────────────────────────────────────────────────────────────────┘

ANDROID (Mobile)
├─ Primary:   /data/data/com.example.module_parking_app/databases/
├─ Fallback:  (getApplicationDocumentsDirectory())
└─ Final:     /databases/parking_app/parking_app.db

iOS (Mobile)
├─ Primary:   /var/mobile/Containers/Data/Application/[APP_ID]/
├─ Fallback:  (getApplicationDocumentsDirectory())
└─ Final:     /Documents/databases/parking_app/parking_app.db

LINUX (Desktop)
├─ Primary:   ~/.local/share/module_parking_app/
├─ Fallback1: ~/Documents/parking_app_db/
├─ Fallback2: ~/.parking_app/
└─ Final:     parking_app.db

WINDOWS (Desktop)
├─ Primary:   C:\Users\[User]\AppData\Roaming\module_parking_app\
├─ Fallback1: C:\Users\[User]\Documents\parking_app_db\
├─ Fallback2: C:\Users\[User]\.parking_app\
└─ Final:     parking_app.db

macOS (Desktop)
├─ Primary:   ~/Library/Application Support/module_parking_app/
├─ Fallback1: ~/Documents/parking_app_db/
├─ Fallback2: ~/.parking_app/
└─ Final:     parking_app.db
```

## 4. DATABASE OPENING & TABLE CREATION

```
Database Path Resolved
│
▼
┌──────────────────────────────────────────┐
│ Check if directory exists               │
└──────────────────────────────────────────┘
  │
  ├─ No ❌ → Create with recursive: true
  │
  └─ Yes ✅ → Continue
           │
           ▼
┌──────────────────────────────────────────┐
│ Platform Check:                          │
│ Windows/Linux/macOS? → Use databaseFactoryFfi
│ Android/iOS? → Use default openDatabase()
└──────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────┐
│ openDatabase() called                    │
│ Database file created if not exists      │
└──────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────┐
│ ON CREATE CALLBACK: _createTables()     │
└──────────────────────────────────────────┘
           │
           ├─ CREATE TABLE tb_user
           ├─ CREATE TABLE tb_jenis_kendaraan
           ├─ CREATE TABLE tb_area_parkir
           ├─ CREATE TABLE tb_kendaraan
           ├─ CREATE TABLE tb_transaksi
           └─ CREATE TABLE tb_log_aktivitas
                    │
                    ▼
         INSERT DEFAULT DATA
         ├─ 2 Jenis Kendaraan (Motor, Mobil)
         └─ 3 Test Users (owner, admin1, petugas1)
```

## 5. CRITICAL FIX LOCATION

```
┌──────────────────────────────────────────────────────────────┐
│                    CRITICAL FIX (Commit f1d6e5a)            │
│                  "Initialize databaseFactory"                │
└──────────────────────────────────────────────────────────────┘

PROBLEM:
  databaseFactory not initialized on desktop platforms
  ↓
  Error: "databaseFactory is not initialized"
  ↓
  App crashes before database can be created

SOLUTION:
  lib/main.dart (lines 20-25)
  └─ if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
       sqfliteFfiInit();                    ← FIRST
       databaseFactory = databaseFactoryFfi; ← SECOND (CRITICAL)
     }

  This must happen BEFORE:
  ✅ AppPreferences.init()
  ✅ runApp()
  ✅ Any database access

RESULT:
  ✅ Database initialization succeeds on all platforms
  ✅ Triple-fallback path resolution works
  ✅ Default data created automatically
```

## 6. ERROR HANDLING FLOW

```
Database Operation
│
▼
┌────────────────────────┐
│ Try Operation          │
└────────────────────────┘
  │
  ├─ Success ✅ → Return result
  │
  └─ Error ❌ → Check fallback level
                │
                ├─ Level 1 (getDatabasesPath failed)
                │  └─ Print: "getDatabasesPath failed: [error]"
                │  └─ Try Level 2
                │
                ├─ Level 2 (getApplicationDocumentsDirectory failed)
                │  └─ Print: "getApplicationDocumentsDirectory failed: [error]"
                │  └─ Try Level 3
                │
                └─ Level 3 (Home directory failed)
                   └─ Print: "Home directory failed: [error]"
                   └─ Throw detailed exception with ALL 3 errors
                   └─ App logs complete error stack
```

## 7. DEBUG LOGGING POINTS

```
Console Output During Startup
│
├─ DEBUG MAIN: sqfliteFfiInit() called
│
├─ DEBUG MAIN: databaseFactory set to databaseFactoryFfi
│
├─ DEBUG: Starting database initialization...
│
├─ DEBUG: Trying getDatabasesPath()...
│  ├─ DEBUG: Got system path: /path/to/databases
│  ├─ DEBUG: Creating directory: /path/to/directory
│  └─ DEBUG: Using standard database path: /path/to/parking_app.db
│
├─ DEBUG: Full Database File: /full/path/to/parking_app.db
│
├─ DEBUG: Using sqflite_ffi for desktop platform
│
├─ DEBUG: Opening database at: /full/path/to/parking_app.db
│
├─ DEBUG: _createTables called
│
├─ DEBUG SPLASH: Database initialized
│
├─ DEBUG SPLASH: Database path: /full/path/to/parking_app.db
│
└─ DEBUG SPLASH: Found 3 users in database
```

## 8. VERIFICATION CHECKLIST

```
After Database Initialization
│
├─ [✅/❌] Check console for all expected DEBUG messages
│
├─ [✅/❌] Check file exists at printed path:
│          ls -lh /path/to/parking_app.db
│
├─ [✅/❌] Check file size > 10KB:
│          (Empty database ~20KB, populated ~25KB)
│
├─ [✅/❌] Check table count = 6:
│          SELECT name FROM sqlite_master WHERE type='table'
│
├─ [✅/❌] Check default users = 3:
│          SELECT COUNT(*) FROM tb_user
│
├─ [✅/❌] Check default jenis_kendaraan = 2:
│          SELECT COUNT(*) FROM tb_jenis_kendaraan
│
├─ [✅/❌] Login test: owner / 123456 → owner dashboard
│
├─ [✅/❌] Login test: admin1 / 123456 → admin dashboard
│
└─ [✅/❌] Data persistence: Close and reopen app
```

## 9. SYNC BETWEEN main.dart AND database_helper.dart

```
                main.dart                    database_helper.dart
                ────────                    ────────────────────

              ┌──────────────┐           ┌────────────────────┐
              │ Startup      │           │ First Usage        │
              └──────────────┘           └────────────────────┘
                    │                          │
                    ▼                          ▼
         ┌─────────────────────┐  ┌──────────────────────────┐
         │ sqfliteFfiInit()    │  │ await database getter    │
         │ Set databaseFactory │  │ _initDatabase() called   │
         │ ✅ Desktop check    │  │ ✅ Desktop check again   │
         └─────────────────────┘  └──────────────────────────┘
                                          │
                    MUST MATCH:           ▼
              Platform.isWindows   ┌──────────────────────────┐
              Platform.isLinux     │ if (Platform.isWindows...│
              Platform.isMacOS     │   databaseFactoryFfi    │
                                   │ else                     │
                                   │   openDatabase()         │
                                   └──────────────────────────┘

✅ Consistency Check:
Both files check Platform.isWindows/isLinux/isMacOS
Both use databaseFactoryFfi for desktop
Both use default openDatabase for mobile
```

