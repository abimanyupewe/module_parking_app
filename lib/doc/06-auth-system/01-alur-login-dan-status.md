1. ALUR LOGIN DAN VALIDASI STATUS

Sistem autentikasi aplikasi Manajemen Parkir ini dirancang sebagai sistem tertutup (Closed System) dengan validasi role dan status akun yang ketat.

A. UI Halaman Login
- Header: Teks heading utama menggunakan warna #343858 (Primary Color).
- Form Input: Menggunakan custom_textfield.dart untuk input Username dan Password.
- Latar Belakang Form: Menggunakan #EEF1F7 (Tertiary Color).
- Tombol Utama: Menggunakan primary_button.dart berwarna #343858 dengan teks "Login".

B. Logika Autentikasi
1. User memasukkan kredensial (Username & Password).
2. Sistem melakukan query ke tabel tb_user.
3. Jika akun ditemukan, sistem mengecek kolom status:
   - Jika status = 'nonaktif': Login ditolak, tampilkan pesan peringatan "Akun Anda telah dinonaktifkan. Silakan hubungi Owner."
   - Jika status = 'aktif': Lanjutkan ke proses routing.

C. Role-Based Routing
Setelah login berhasil, sistem secara otomatis mengalihkan user ke dashboard yang sesuai:
- Role 'owner' -> owner_dashboard_page.dart
- Role 'admin' -> admin_dashboard_page.dart
- Role 'petugas' -> petugas_dashboard_page.dart
