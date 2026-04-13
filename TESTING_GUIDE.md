================================================================================
                    PARKING APP - COMPREHENSIVE TESTING GUIDE
================================================================================

Last Updated: 2026-04-13
Project: module_parking_app (Flutter)
Database: SQLite (Offline-Capable)

================================================================================
                              TABLE OF CONTENTS
================================================================================

1. SETUP & PREREQUISITES
2. DATABASE INITIALIZATION TESTING
3. AUTHENTICATION TESTING (Login/Register)
4. GUI DATABASE ACCESS
5. ROLE-BASED DASHBOARD TESTING
6. OFFLINE FUNCTIONALITY
7. DEBUGGING TIPS
8. TROUBLESHOOTING

================================================================================
1. SETUP & PREREQUISITES
================================================================================

Requirements:
  ✓ Flutter SDK (3.41.4 or later)
  ✓ Android SDK / iOS SDK / Linux Desktop (based on platform)
  ✓ Database: SQLite (bundled with Flutter)
  ✓ VS Code or DB Browser for SQLite (optional, for GUI viewing)

Setup Steps:
  1. Navigate to project folder:
     $ cd /path/to/module_parking_app

  2. Get dependencies:
     $ flutter pub get

  3. Clean build (recommended):
     $ flutter clean

  4. Install on device/emulator:
     $ flutter run -d <device_id>

Platform Devices:
  $ flutter devices     # List available devices
  
  Android Emulator:
    $ flutter run -d emulator-5554
  
  Linux Desktop:
    $ flutter run -d linux
  
  Web:
    $ flutter run -d chrome

================================================================================
2. DATABASE INITIALIZATION TESTING
================================================================================

What to Test:
  ✓ Database file is created on first app run
  ✓ Tables are created correctly
  ✓ Default data is inserted (2 vehicle types)
  ✓ Database persists after app close/restart

Expected Behavior:
  
  FIRST RUN:
    [✓] Console shows: "DEBUG SPLASH: Starting app initialization..."
    [✓] Console shows: "DEBUG SPLASH: Initializing Database..."
    [✓] Console shows: "DEBUG: _createTables called..."
    [✓] Console shows database path (e.g., "/home/user/.local/share/...")
    [✓] Console shows: "Found X users in database" (should be 0 initially)

  VERIFICATION:
    [✓] Check database file exists at path shown in console
    [✓] Open with VS Code SQLite extension or DB Browser
    [✓] Verify tables exist:
        - tb_user (empty initially)
        - tb_jenis_kendaraan (2 default vehicle types)
        - tb_area_parkir (empty)
        - tb_kendaraan (empty)
        - tb_transaksi (empty)
        - tb_log_aktivitas (empty)

  PERSISTENCE CHECK:
    [✓] Close app completely
    [✓] Run app again
    [✓] Database file should still exist with same data
    [✓] No "DEBUG: _createTables called" on second run (onCreate only on first)

Testing Checklist:
  [ ] Database file created in correct location
  [ ] All 6 tables created
  [ ] Default vehicle types inserted (Motor, Mobil)
  [ ] No errors in console output
  [ ] Data persists after app restart

================================================================================
3. AUTHENTICATION TESTING (Login/Register)
================================================================================

Test Scenario 1: User Registration (Create Default Users)
────────────────────────────────────────────────────────

IMPORTANT: Default users are NOT hardcoded. Create them via registration:

Steps:
  1. Open app → Click "Belum punya akun? Daftar"
  2. Register Owner user:
     - Nama Lengkap: Owner Parkir
     - Username: owner
     - Password: 123456
     - Role: auto-set to 'owner' (Owner-only registration)
  
  3. Click Register
     Expected: "Registrasi berhasil! Silakan login dengan akun Anda."
  
  4. Check console:
     [✓] "DEBUG: Starting registration for username: owner"
     [✓] "DEBUG: User inserted successfully with ID: 1"

Test Scenario 2: Login with Owner
──────────────────────────────────

Steps:
  1. From Login page, enter:
     - Username: owner
     - Password: 123456
  
  2. Click Login
     Expected: Navigate to Owner Dashboard
  
  Console output:
    [✓] "DEBUG DB: Query username=owner, found 1 record(s)"
    [✓] "DEBUG LOGIN: Role: owner"
    [✓] "DEBUG LOGIN: Role == \"owner\": true"

Test Scenario 3: Verify Role Constants (Lowercase)
──────────────────────────────────────────────────

Expected behavior:
  - All roles stored in database as LOWERCASE:
    * 'owner'   (not 'Owner')
    * 'admin'   (not 'Admin')
    * 'petugas' (not 'Petugas')

Verify via SQL:
  SELECT username, role FROM tb_user;
  
  Expected Output:
  ┌──────────────┬─────────┐
  │ username     │ role    │
  ├──────────────┼─────────┤
  │ owner        │ owner   │ ← lowercase
  │ admin1       │ admin   │ ← lowercase
  │ petugas1     │ petugas │ ← lowercase
  └──────────────┴─────────┘

Test Scenario 4: Invalid Credentials
──────────────────────────────────────

Test Case 1: Wrong Password
  Username: owner
  Password: wrongpassword
  Expected: "Password salah"

Test Case 2: Non-existent User
  Username: nonexistent
  Password: 123456
  Expected: "Username tidak ditemukan"

Test Case 3: Empty Fields
  Username: (empty)
  Password: (empty)
  Expected: "Username dan password tidak boleh kosong"

Testing Checklist:
  [ ] Register owner user successfully
  [ ] Login with valid credentials navigates to correct dashboard
  [ ] Login with wrong password shows error
  [ ] Login with non-existent user shows error
  [ ] All roles in database are lowercase
  [ ] Console debug messages appear correctly

================================================================================
4. GUI DATABASE ACCESS (Recommended)
================================================================================

OPTION A: VS Code SQLite Extension (RECOMMENDED)
──────────────────────────────────────────────────

1. Install Extension:
   a. Open VS Code
   b. Extensions → Search "SQLite" by alexcvzz
   c. Click Install

2. Open Database:
   a. Run app (creates database file)
   b. Press Ctrl+Shift+P (or Cmd+Shift+P on Mac)
   c. Type: "SQLite: Open Database"
   d. Navigate to parking_app.db file
   e. Click it

3. Browse Data:
   a. Left sidebar shows "SQLite Explorer"
   b. Expand database → see all tables
   c. Right-click table → "Show Table" for quick preview
   d. Double-click table → open in editor

4. Run SQL Queries:
   a. Create new file: queries.sql
   b. Paste queries below
   c. Press Ctrl+Enter to run

EXAMPLE QUERIES:
────────────────

-- Check all users
SELECT * FROM tb_user;

-- Check users by role
SELECT * FROM tb_user WHERE role = 'owner';

-- Count users
SELECT COUNT(*) as total_users FROM tb_user;

-- Check vehicle types
SELECT * FROM tb_jenis_kendaraan;

-- Check password hashing (should be bcrypt)
SELECT username, password FROM tb_user LIMIT 1;

-- Check all tables exist
SELECT name FROM sqlite_master WHERE type='table';

OPTION B: DB Browser for SQLite
─────────────────────────────────

1. Download from: https://sqlitebrowser.org/dl/
2. Install application
3. Open DB Browser for SQLite
4. Click "Open Database" button
5. Navigate to parking_app.db
6. Use "Browse Data" tab to view table contents
7. Use "Execute SQL" tab to run queries

DATABASE PATH REFERENCE:
────────────────────────

Linux:
  ~/.local/share/module_parking_app/databases/parking_app/parking_app.db

Windows:
  C:\Users\[YourUsername]\AppData\Roaming\module_parking_app\databases\parking_app\parking_app.db

macOS:
  ~/Library/Application Support/module_parking_app/databases/parking_app/parking_app.db

Android:
  /data/data/com.example.module_parking_app/databases/parking_app/parking_app.db
  (Access via Android Studio Device File Explorer)

iOS:
  /var/mobile/Containers/Data/Application/[APP_ID]/Documents/databases/parking_app/parking_app.db
  (Access via Xcode)

TIP: Check console output when app runs - it prints exact database path!
     Look for: "DEBUG: Using standard database path: /path/to/parking_app.db"

================================================================================
5. ROLE-BASED DASHBOARD TESTING
================================================================================

After successful login, verify role-based navigation:

OWNER LOGIN (username: owner, password: 123456)
─────────────────────────────────────────────────
Expected: Owner Dashboard displayed
Features to verify:
  [ ] Navigate to /owner_dashboard
  [ ] Owner-specific widgets rendered
  [ ] Profile section shows "owner" role
  [ ] Can access owner features

ADMIN LOGIN (username: admin1, password: 123456)
──────────────────────────────────────────────────
Expected: Admin Dashboard displayed
Features to verify:
  [ ] Navigate to /admin_dashboard
  [ ] Admin-specific widgets rendered
  [ ] Profile section shows "admin" role
  [ ] Can access admin features

PETUGAS LOGIN (username: petugas1, password: 123456)
───────────────────────────────────────────────────────
Expected: Petugas Dashboard displayed
Features to verify:
  [ ] Navigate to /petugas_dashboard
  [ ] Petugas-specific widgets rendered
  [ ] Profile section shows "petugas" role
  [ ] Can access petugas features

Role Switch Testing:
  1. Login as owner
  2. Close/logout
  3. Login as admin1
  4. Verify different dashboard shown
  5. Repeat for petugas1

Console Verification:
  Look for debug output like:
    "DEBUG LOGIN: Role: owner"
    "DEBUG LOGIN: Role == \"owner\": true"

Testing Checklist:
  [ ] Owner login navigates to owner dashboard
  [ ] Admin login navigates to admin dashboard
  [ ] Petugas login navigates to petugas dashboard
  [ ] Role string is exactly lowercase in console
  [ ] Role-based features are visible per user

================================================================================
6. OFFLINE FUNCTIONALITY
================================================================================

SQLite is offline-capable by default. Test offline mode:

Test Scenario: Offline Login
──────────────────────────────

1. Start app and login successfully
2. Disconnect internet (airplane mode / unplug network)
3. Close app completely
4. Restart app (still offline)
5. Try login with same credentials

Expected behavior:
  [✓] Login still works (data is local in SQLite)
  [✓] Dashboard loads normally
  [✓] Can view stored data

NOTE: Registration requires internet if using backend validation
      (Current setup: registration local only, so offline works)

Test Scenario: Data Persistence
──────────────────────────────────

1. Add user via registration (online or offline)
2. Close app
3. Restart app
4. Check user still exists (login works)

Expected: User data persists in SQLite database

Testing Checklist:
  [ ] Can login offline after initial registration
  [ ] Dashboard loads offline
  [ ] Can view stored users offline
  [ ] No network errors if offline
  [ ] Data persists across app restarts

================================================================================
7. DEBUGGING TIPS
================================================================================

Check Console Output:
  When running app, watch console for debug messages:
    - "DEBUG SPLASH: Starting app initialization..."
    - "DEBUG SPLASH: Initializing Database..."
    - "DEBUG: Using standard database path: ..."
    - "DEBUG DB: Query username=..., found X record(s)"
    - "DEBUG INSERT: User map: ..."
    - "DEBUG LOGIN: Role: ..."

Check Log Files:
  Android:
    $ adb logcat | grep "DEBUG"
  
  iOS:
    Console app or Xcode Device Log

Verify Database File Size:
  Linux/Mac:
    $ ls -lh ~/.local/share/module_parking_app/databases/parking_app/parking_app.db
  
  Windows:
    Properties → Size (should be > 10KB after data)

Check Database Integrity:
  $ sqlite3 /path/to/parking_app.db "PRAGMA integrity_check;"
  
  Expected output: "ok"

Enable Verbose Logging:
  Run app with:
    $ flutter run -v    # Verbose mode

Inspect Network (if using API in future):
  $ flutter run -v 2>&1 | grep -i "http\|network\|database"

================================================================================
8. TROUBLESHOOTING
================================================================================

ISSUE: Database file not created
─────────────────────────────────
Cause: App may not have run fully, or path issues

Solution:
  1. Check console for error messages
  2. Verify database path is printed
  3. Run app again and wait for splash screen
  4. Check file system at printed path

ISSUE: "Cannot open database" in VS Code
──────────────────────────────────────────
Cause: File is locked (app running), or file corrupted

Solution:
  1. Close/kill the running app first
  2. Try copying .db file to different location
  3. Open copy instead of original
  4. Use DB Browser if VS Code fails

ISSUE: Login fails with "Username tidak ditemukan"
────────────────────────────────────────────────────
Cause: User not registered yet, or database empty

Solution:
  1. Register user first via registration page
  2. Check database contains users:
     SELECT * FROM tb_user;
  3. Verify username spelling (case-sensitive)

ISSUE: Wrong role showing in dashboard
─────────────────────────────────────────
Cause: Role is capitalized or doesn't match constants

Solution:
  1. Check database: SELECT * FROM tb_user;
  2. Verify role is lowercase ('owner', not 'Owner')
  3. Check AppConstants in constants.dart
  4. Ensure role comparison uses AppConstants

ISSUE: App crashes on first run
─────────────────────────────────
Cause: Database initialization error

Solution:
  1. Check console for full error stack trace
  2. Verify path_provider and sqflite installed
  3. Check storage permissions granted
  4. Try: flutter clean && flutter pub get
  5. Run app again

ISSUE: Data not persisting after app close
────────────────────────────────────────────
Cause: Database not properly initialized or closed

Solution:
  1. Verify app initializes in SplashPage
  2. Check _initDatabase() is called
  3. Verify database file exists at console path
  4. Check permissions on database file/folder
  5. Try backing up & deleting database, restart app

ISSUE: SQLite extension not showing database
──────────────────────────────────────────────
Cause: Extension not installed or database path wrong

Solution:
  1. Verify extension is installed (SQLite by alexcvzz)
  2. Reload VS Code: Ctrl+Shift+P → "Developer: Reload Window"
  3. Try opening database manually via command palette
  4. Use DB Browser as alternative

================================================================================
QUICK REFERENCE: DEFAULT TEST DATA
================================================================================

Vehicle Types (Auto-Inserted):
  1. Motor    - Rp2,000/jam
  2. Mobil    - Rp5,000/jam

Test Users (Created via Registration):
  1. Username: owner    | Password: 123456 | Role: owner
  2. Username: admin1   | Password: 123456 | Role: admin
  3. Username: petugas1 | Password: 123456 | Role: petugas

================================================================================
FINAL CHECKLIST
================================================================================

Before considering testing complete, verify:

Database:
  [ ] Database file created at first run
  [ ] All tables created successfully
  [ ] Default vehicle types inserted
  [ ] Data persists after app restart

Authentication:
  [ ] Can register owner user
  [ ] Can login with valid credentials
  [ ] Wrong password shows error
  [ ] Non-existent user shows error
  [ ] All roles are lowercase in database

Navigation:
  [ ] Owner login → Owner Dashboard
  [ ] Admin login → Admin Dashboard
  [ ] Petugas login → Petugas Dashboard

GUI Access:
  [ ] Can open database with VS Code SQLite extension
  [ ] Or can open with DB Browser
  [ ] Can view tables and data via GUI
  [ ] Can run SQL queries successfully

Offline:
  [ ] App works without internet after first registration
  [ ] Can login offline
  [ ] Data persists offline

================================================================================
STATUS: READY FOR TESTING
================================================================================

If all checklist items pass, the application is ready for:
  ✓ Development
  ✓ Quality Assurance
  ✓ User Acceptance Testing

For issues, refer to Troubleshooting section above.

Questions? Check debug console output first (very helpful!)

================================================================================
